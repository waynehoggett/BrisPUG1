#Classes

#Define a class
class server {
    [string]$Name
    [string]$IPaddress
}

#Create an instance of the class
$Server1 = [server]::new()
#or New-Object -TypeName Server

#Assign properties
$Server1.Name = "DC1"
$Server1.IPAddress = "192.168.1.1"
$Server1

#Add another property that is not defined the class it will error
$Server1.DomainName = "domain.local"

#PSCustomObject
$Server2 = [PSCustomObject]@{
    Name     = "DC2"
    IPAddress = "192.168.1.2"
    DomainName    = "domain.local"
}

$ServerList = New-Object -TypeName System.Collections.ArrayList
$ServerList.Add($Server2)

#Create a PSCustomObject with a different set of properties
$Server3 = [PSCustomObject]@{
    Name     = "WEB1"
    IPAddress = "192.168.1.3"
    User = "Domain.Admin"
}
$ServerList.Add($Server3)

#The User property, exists on the second item in the list
$ServerList[1].User

#Performance of PSObject
$ServerNumbers = 1..100000
$ServerList = New-Object -TypeName System.Collections.ArrayList
$ScriptBlock = {
    foreach ($ServerNumber in $ServerNumbers)
    {
        $ServerList.Add([PSObject]@{Name="Server$($ServerNumber)"; RoleCount = (Get-Random -Minimum 1 -Maximum 10)})
    }
}
$PSObjectPerformance = Measure-Command -Expression $ScriptBlock

#Performance of Classes
class simpleserver {
    [string]$Name
    [int]$RoleCount
        simpleserver ([string]$Name, [int]$RoleCount) {
        $this.Name = $Name
        $this.RoleCount = $RoleCount
    }
}
$ServerNumbers = 1..100000
$ServerList = New-Object -TypeName System.Collections.ArrayList
$ScriptBlock = {
    foreach ($ServerNumber in $ServerNumbers)
    {
        $ServerList.Add([simpleserver]::new("Server$($ServerNumber)", (Get-Random -Minimum 1 -Maximum 10)))
    }
}
$ClassesPerformance = Measure-Command -Expression $ScriptBlock

Write-Host "PSObject Performance: $($PSObjectPerformance.TotalSeconds)" -ForegroundColor Green
Write-Host "Class Performance: $($ClassesPerformance.TotalSeconds)" -ForegroundColor Yellow

#Constructors
class simpleserverclass {
    [string]$Name
    [int]$RoleCount

    #Constructor
    simpleserverclass ([string]$Name) {
        $this.Name = $Name
        $this.RoleCount = 0
    }

    #Another constructor
    simpleserverclass ([string]$Name, [int]$RoleCount) {
        $this.Name = $Name
        $this.RoleCount = $RoleCount
    }
}

#Create servers using constructors
$SimpleServer1 = [simpleserverclass]::new("DC1")
$SimpleServer2 = [simpleserverclass]::new("DC2", 2)

#Methods
class standardserver {
    [string]$Name

    restart() {
        Restart-Computer -ComputerName $this.Name
    }
}

#Inheritance
class awsserver : standardserver {
    [string]$instanceID

    restart() {
        Restart-EC2Instance -InstanceID $this.InstanceID -Whatif
    }
}

#Create an instance of an inherited class, contains the members from both classes
$AWSServer = [awsserver]::new()
$AWSServer | Get-Member