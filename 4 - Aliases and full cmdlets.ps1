#----------------------------------------------
#Aliases
$ScriptBlock = {
    Service | ? Name -like x* | Select -l 2 -exp Name | sls xbox
}

$AliasPerformance = Measure-Command -Expression $ScriptBlock

#Full Cmdlets
$ScriptBlock = {
    Get-Service | Where-Object Name -like 'x*' | Select-Object -Last 2 -ExpandProperty Name | Select-String xbox
}

$FullSyntaxPerformance = Measure-Command -Expression $ScriptBlock

Write-Host "Alias Performance: $($AliasPerformance.TotalSeconds) Seconds" -ForegroundColor Yellow
Write-Host "Full Syntax Performance: $($FullSyntaxPerformance.TotalSeconds) Seconds" -ForegroundColor Green

#----------------------------------------------

#Aliases can be removed, including system aliases
Get-Alias | Where-Object {$_.options -notmatch 'readonly'} | Select-Object -ExpandProperty Name -First 15