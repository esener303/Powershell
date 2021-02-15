#Script for updating user data after sAMAccountName being changed in Active Directory
#In this example login changed from akowalska001 to aiksinska001
#User profile Display Name and Email are also being updated

Add-PSSnapIn Microsoft.SharePoint.PowerShell

$user = Get-SPUser -Identity "i:0#.w|domain\akowalska001" -Web https://spsiteaddress

$user.DisplayName = "Anna Iksińska"
$user.Email = "anna.iksinska@company.com"
$user.Update()
Move-SPUser -Identity $user -NewAlias "i:0#.w|domain\aiksinska001" -IgnoreSID