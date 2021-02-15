##################################################################################################################################################
#
# Import users and groups from CSV to Acitve Directory 
# KMBS Sp. z o.o. @ Michal Demczyszak
#
##################################################################################################################################################

Function Import {

param(

[parameter(Mandatory=$true)]
[string]$domainName = $null,
[parameter(Mandatory=$true)]
[string]$AdOUName = $null,
[parameter(Mandatory=$true)]
[string]$AdminName =$null,
[parameter(Mandatory=$true)]
[string]$ActiveDricetoryOU =$null
)

}

# Run the function
Import

# Turn Off the GPO
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Scope LocalMachine -Force 

# CSV sample import file
# givenName;surname;name;email;login;group;password
# Włodzimierz;TEST;Włodzimierz TEST;w.TEST@TEST.com.pl;w.TEST;Z;2017!TEST#

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
# Define the location path and file name of file to import (script will start looking in the script folder)
$users = Import-Csv -Path "$PSScriptRoot/users.csv" -Delimiter ";"

# Imports AD module
Import-Module ActiveDirectory
DISM /online /enable-feature /featurename=ActiveDirectory-PowerShell
 
# Create an OU for the Users
New-ADOrganizationalUnit -Name $AdOUName -ProtectedFromAccidentalDeletion $false -ManagedBy $AdminName

# Create Active Directory Groups
foreach ($user in $users)
{
   If([string]::IsNullOrEmpty($user.group))
   {
   Write-Host "Brak grupy w pliku" 
   }
   else
   { 
   New-ADGroup -Name $user.group -GroupScope Global -SamAccountName $user.group
   Write-Host "New Active Directory Group :" +$user.group 
   }
}

# Create each of the users
foreach($user in $users)
{
    $userPrincipalName = $user.login +"@" + $domainName
    New-ADUser $user.name -AccountPassword (ConvertTo-SecureString -AsPlainText $user.Password -Force) -GivenName $user.givenName -Surname $user.surname -DisplayName -UserPrincipalName $userPrincipalName $user.name -EmailAddress $user.email -SamAccountName $user.login -Group $user.group -Enabled $true -Path $AD-OU #-ChangePasswordAtLogon $true
}

# Dodawanie uzytkowników do grup AD
foreach ($user in $users) 
{
   

   If([string]::IsNullOrEmpty($user.group))
   {
   Write-Host "Uzytkownik : $user.login nie ma przypisanej grupy" 
   }
   else
   { 

   Add-ADGroupMember -Identity $user.group -Members $user.login 
   Write-Host "User " +$user.login
   Write-Host "został dodany do grupy " +$user.group 
   }
}

$text = "Users and Groups has been created !!!" 

# Print out the summary text
Write-host $text -BackgroundColor Red
