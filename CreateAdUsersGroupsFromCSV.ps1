Function Import-FromCSV {

# Turn Off the GPO
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Scope LocalMachine -Force 

# CSV sample import file
# givenName;surname;name;email;login;group;password
# WÅ‚odzimierz;TEST;WÅ‚odzimierz TEST;w.TEST@TEST.com.pl;w.TEST;Z;2017!TEST#

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
   Write-Host "New Active Directory Group :" $user.group 
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
   Write-Host "User " + $user.login
   Write-Host "został‚ dodany do grupy " +$user.group 
   }
}

$text = "Users and Groups has been created !!!" 

# Print out the summary text
Write-host $text -BackgroundColor Red

}

Function Add-SingleAdUser {

# Turn Off the GPO
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Scope LocalMachine -Force 

# CSV sample import file
# givenName;surname;name;email;login;group;password
# JAN;KOWALSKI;JAN KOWALSKI;J.KOWALSKI@com.pl;J.KOWALSKI;ECM;2017!TEST#

Function random-login ($length = 12)
{
    $digits = 48..57
    $letters = 65..90 + 97..122

    # Thanks to
    # https://blogs.technet.com/b/heyscriptingguy/archive/2012/01/07/
    $login = get-random -count $length `
        -input ($digits + $letters) |
            % -begin { $aa = $null } `
            -process {$aa += [char]$_} `
            -end {$aa}    

    return $login
}

$login = random-login

Function AdLoginCheck {

$Searcher = [ADSISearcher]"(sAMAccountName=$login)"
        
$Results = $Searcher.FindOne()

    If ($Results -eq $Null) 
    {
        Write-Host -ForegroundColor Yellow "Users does not exist in your current AD Forest"        
    }
    Else 
    {
        Write-Host -BackgroundColor Red "User found in current AD Foret and generate new sAMAccountName ;)"        
    }
}

while(AdLoginCheck($login))
{

    random-login

    $login = random-login

}

$user = @()

Add-Member -InputObject $user -MemberType NoteProperty -Name "givenName" -Value $givenName
Add-Member -InputObject $user -MemberType NoteProperty -Name "surname" -Value $surname
Add-Member -InputObject $user -MemberType NoteProperty -Name "name" -Value $name
Add-Member -InputObject $user -MemberType NoteProperty -Name "email" -Value $email
Add-Member -InputObject $user -MemberType NoteProperty -Name "login" -Value $login
Add-Member -InputObject $user -MemberType NoteProperty -Name "group" -Value $group
Add-Member -InputObject $user -MemberType NoteProperty -Name "password" -Value $password

$destination = "OU="+$ouname+","+$oupath

$displayName = $givenName+" "+$surname

# Imports AD module
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
DISM /online /enable-feature /featurename=ActiveDirectory-PowerShell

# Create Active Directory Groups

If([string]::IsNullOrEmpty($user.group))
{
    Write-Host -BackgroundColor Green "Brak grupy w pliku" 
}
else
{ 
    Try 
    {
        New-ADGroup -Name $user.group -GroupScope Global -SamAccountName $user.group -Path $destination
        Write-Host -ForegroundColor Yellow "New Active Directory Group :" $user.group 
    }
    Catch
    {
        
    }
}

# Create each of the users

    $userPrincipalName = $user.name + "@" + $UPNsuffix
    New-ADUser $user.name -AccountPassword (ConvertTo-SecureString -AsPlainText $user.Password -Force) -GivenName $user.givenName -Surname $user.surname -UserPrincipalName $userPrincipalName -EmailAddress $user.email -SamAccountName $user.login -Enabled $true -Path $destination -DisplayName $displayName -ChangePasswordAtLogon $true

# Dodawanie uzytkowników do grup AD

    If([string]::IsNullOrEmpty($user.group))
    {
        Write-Host -BackgroundColor Green "Uzytkownik : $user.login nie ma przypisanej grupy" 
    }
    else
    { 
        Add-ADGroupMember -Identity $user.group -Members $user.login 
        Write-Host -ForegroundColor Yellow "User "$user.login "został dodany do grupy "$user.group        
    }
    
    $text = "Users and Groups has been created :)" 
    # Print out the summary text
    Write-host $text -ForegroundColor Yellow

}

