Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$farm = Get-SPFarm
Write-Verbose "Resetting SharePoint Timer Service ..." -verbose
$farm.TimerService.Instances | foreach { $_.Stop(); $_.Start(); }

Stop-SPAssignment -Global