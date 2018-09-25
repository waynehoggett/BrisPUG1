#Arrays are a fixed Size
#Create an Array
$Array = @()

#Try to add something, it fails
$Array.Add("a")

#Force it to work, destroys the array and recreates it
$Array += "a"

#----------------------------------------------

#Use a list
$List = New-Object -TypeName System.Collections.ArrayList

#Add an item
$List.Add("a")

#----------------------------------------------
#Measure the performance difference
#Array
$Array = @()
$Numbers = 0..20000
$ScriptBlock = {
    Foreach ($Number in $Numbers)
    {
        $Array += $Number
    }
}
$ArrayPerformance = Measure-Command -Expression $ScriptBlock

#Collection
$Collection = New-Object -TypeName System.Collections.ArrayList
$Numbers = 0..20000
$ScriptBlock = {
    Foreach ($Number in $Numbers)
    {
        $Collection.Add($Number)
    }
}
$ListPerformance = Measure-Command -Expression $ScriptBlock

#How much faster is using a list?
Write-Host "Array Performance: $($ArrayPerformance.TotalSeconds) Seconds" -ForegroundColor Yellow
Write-Host "List Performance: $($ListPerformance.TotalSeconds) Seconds" -ForegroundColor Green

#----------------------------------------------
#Even faster list creation
$Collection = New-Object -TypeName System.Collections.ArrayList
$Numbers = 0..20000
$ScriptBlock = {
    $Collection.AddRange($Numbers)
}
$ListPerformance = Measure-Command -Expression $ScriptBlock

#How much faster is using a list with AddRange?
Write-Host "Array Performance: $($ArrayPerformance.TotalSeconds) Seconds" -ForegroundColor Yellow
Write-Host "List Performance: $($ListPerformance.TotalSeconds) Seconds" -ForegroundColor Green

#----------------------------------------------
#Making List Creation more PowerShell-like with a function
function New-List {
    return New-Object -TypeName System.Collections.ArrayList
}

#Use it
$List = New-List
$List.Add("a")
$null = $List.Add("b")
$List

#----------------------------------------------

#Clean the output with $null
function Add-ListItem ($List, $Item) {
    $null = $List.Add($Item)
}

Add-ListItem -List $List -Item "c"
$List
#----------------------------------------------
#Side Note: Generic List is also available an can be used instead of an ArrayList
New-Object -TypeName System.Collections.Generic.List[int]