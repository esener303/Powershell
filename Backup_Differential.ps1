Add-PSSnapin "Microsoft.SharePoint.PowerShell"
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Force
Backup-SPFarm -BackupMethod Differential -Directory D:\backup\