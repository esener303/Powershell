Add-PSSnapin "Microsoft.SharePoint.PowerShell"
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Force
Backup-SPFarm -BackupMethod Full -Directory D:\backup\