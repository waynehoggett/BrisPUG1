#---------------------------------------------
#Where-Object
$ScriptBlock = {
    1..1000000 | Where-Object {$_ -gt 250000}
}

$WhereObjectPerformance = Measure-Command -Expression $ScriptBlock

#.Where{}
$ScriptBlock = {
    (1..1000000).Where{$_ -gt 250000}
}

$WherePerformance = Measure-Command -Expression $ScriptBlock

Write-Host "Where-Object Performance: $($WhereObjectPerformance.TotalSeconds)" -ForegroundColor Yellow
Write-Host ".Where() Performance: $($WherePerformance.TotalSeconds)" -ForegroundColor Green

#----------------------------------------------
#Getting the last 10 using Where-Object
$Numbers = New-Object System.Collections.ArrayList
$null = 1..1000000 | Foreach-Object {$Numbers.Add($_)}

$ScriptBlock = {
    $Numbers | Where-Object -FilterScript {$_ -lt 55000} | Select-Object -Last 10
}

$WhereObjectFilterPerformance = Measure-Command -Expression $ScriptBlock

#Getting just 10 using Where{}
$Numbers = New-Object System.Collections.ArrayList
$null = 1..100000 | Foreach-Object {$Numbers.Add($_)}


$ScriptBlock = {
    ($Numbers).Where({$_ -lt 55000}, 'Last', 10)
}

$WhereFilterPerformance = Measure-Command -Expression $ScriptBlock

Write-Host "Where-Object Filter Performance: $($WhereObjectFilterPerformance.TotalSeconds)" -ForegroundColor Yellow
Write-Host ".Where() Filter Performance: $($WhereFilterPerformance.TotalSeconds)" -ForegroundColor Green

#----------------------------------------------
#Foreach-Object
$Numbers = New-Object System.Collections.ArrayList
$null = 1..1000000 | Foreach-Object {$Numbers.Add($_)}

$ScriptBlock = {
    ($Numbers) | Foreach-Object {$_ * 2}
}

$ForeachObjectPerformance = Measure-Command -Expression $ScriptBlock

#Foreach
$Numbers = New-Object System.Collections.ArrayList
$null = 1..1000000 | Foreach-Object {$Numbers.Add($_)}

$ScriptBlock = {
    ($Numbers).Foreach({$_ * 2})
}

$ForeachPerformance = Measure-Command -Expression $ScriptBlock

Write-Host "Foreach-Object Performance: $($ForeachObjectPerformance.TotalSeconds)" -ForegroundColor Yellow
Write-Host "Foreach Performance: $($ForeachPerformance.TotalSeconds)" -ForegroundColor Green