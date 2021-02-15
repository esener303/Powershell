# Turn Off the GPO
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Scope LocalMachine -Force 

# Define the name of the SharePoint servers and path of the CSV file with logins and password
$sharePointServers = @("SHPDEV")
$path = "C:\SharePointServiceUsers.csv" 
$domainName = "contoso.local"
$DomainDN = “DC=$($domainName.replace(“.”, “,DC=”))”
$OUname = "SharePoint Service Users"

# Generate a random password
# Usage: random-password <length>
Function random-password ($length = 18)
{
    $special = 33..33 + 35..37 + 63..64
    $digits = 48..57
    $letters = 65..90 + 97..122

    # Thanks to
    # https://blogs.technet.com/b/heyscriptingguy/archive/2012/01/07/
    $password = get-random -count $length `
        -input ($special + $digits + $letters) |
            % -begin { $aa = $null } `
            -process {$aa += [char]$_} `
            -end {$aa}

    return $password
}

# Define the users and passwords
$users = @(
         @{Username = "SpSetupUsr"; Password = random-password;},
         @{Username = "SpFarmSvc"; Password = random-password;},
         @{Username = "SpContentPoolSvc"; Password = random-password},
         @{Username = "SpProfilesSync"; Password = random-password;},
         @{Username = "SpWebApp"; Password = random-password;},
         @{Username = "SpSearchSvc"; Password = random-password;},
         @{Username = "SpSearchCrawlerAcc"; Password = random-password;},
         @{Username = "SpAppSvc"; Password = random-password;},
         @{Username = "SpCacheSuperUsr"; Password = random-password;},
         @{Username = "SpCacheSuperRdr"; Password = random-password;},
         @{Username = "SpUnattendedAcc"; Password = random-password;},
         @{Username = "SpAdSync"; Password = random-password;});
 
# Export to CSV file username and passwords
Write-output $users | Out-File $path -Encoding unicode -force

# Imports AD module
Import-Module ActiveDirectory
DISM /online /enable-feature /featurename=ActiveDirectory-PowerShell
 
#Create an OU for the SharePoint Service Users
New-ADOrganizationalUnit -Name $OUname -ProtectedFromAccidentalDeletion $false -ManagedBy "SpSetupUsr"
 
# Create each of the users
foreach($user in $users)
{
    $userPrincipalName = $user.UserName +"@" + $domainName
    New-ADUser $user.Username -AccountPassword (ConvertTo-SecureString -AsPlainText $user.Password -Force) -DisplayName $user.Username -Enabled $true -CannotChangePassword $true -PasswordNeverExpires $true -UserPrincipalName $userPrincipalName -Path "OU=$OUname,$DomainDN"
}
 
# Make SpSetupUsr a domain admin
Add-ADGroupMember -Identity "Domain Admins" -Members "SpSetupUsr"
 
# Make SpSetupUsr a local admin for each of the SharePoint servers
foreach( $computer in $sharePointServers){
    ([ADSI]"WinNT://$computer/Administrators,group").add(('WinNT://',"$env:userdomain",'/','SpSetupUsr' -join ''))
}
 
# Give SpProfilesSvc Replicate Changes on Active Directory
$Identity = "$env:userdomain\SpProfilesSvc"
$RootDSE = [ADSI]"LDAP://RootDSE"
$DefaultNamingContext = $RootDse.defaultNamingContext
$ConfigurationNamingContext = $RootDse.configurationNamingContext
$UserPrincipal = New-Object Security.Principal.NTAccount("$Identity")
 
DSACLS "$DefaultNamingContext" /G "$($UserPrincipal):CA;Replicating Directory Changes"
DSACLS "$ConfigurationNamingContext" /G "$($UserPrincipal):CA;Replicating Directory Changes"

$text = "Logins and Passwords are listed in the CSV file wich is located here :" +$path 

Write-host $text -BackgroundColor Yellow 