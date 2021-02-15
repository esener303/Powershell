####################################################################################################
# This is the script for changing current domain accounts passwords for selected accounts from the 
# csv file where are all accounts are listed with old and new generated passwords 
# All rights are reserved @ Michał Demczyszak - Konica Minolta Buisness Solution Sp z o.o. 2017
####################################################################################################

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$users = Import-Csv -Path "$PSScriptRoot/users.csv" -Delimiter ";"
foreach($user in $users)
{
    Write-Host "Changing password for:" $user.userName
    Set-ADAccountPassword -Identity $user.userName -OldPassword (ConvertTo-SecureString -AsPlainText $user.oldPass -Force) -NewPassword (ConvertTo-SecureString -AsPlainText $user.newPass -Force)
} 
Write-Host "Done"