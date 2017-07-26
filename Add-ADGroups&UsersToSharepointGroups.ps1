###################################################################################################################################################################################################
#
# ITS / ECM @ KMBS Sp. z o.o. @ 2017- read the comments below
#
###################################################################################################################################################################################################

$Host.Runspace.ThreadOptions = "ReuseThread"

# Add Sharepoint shell access to powershell
Add-PSSnapin microsoft.sharepoint.powershell 

Write-host "Adding SharePoint Snapin"

Write-host "Importing AD module..." -ForegroundColor Green

Import-Module activedirectory -ErrorAction SilentlyContinue

# CSV file paramters schema example 

# SiteUrl,ADGroup,SPGroup
# "https://pl-poc","CN=WL-PL-MM-TAX-Assist-Central Cluster,OU=Tax,OU=DigitalMailroom,OU=Sharepoint,OU=Groups,OU=PL,DC=cee,DC=ema,DC=ad,DC=plinternal,DC=com","WL-PL-MM-TAX-Assist-Central Cluster"

try {

# The input CSV file with paramets 
$InputFile = "C:\SharePointSkrypts\Grupy\ADToSPGroups.csv"

$tblData = Import-CSV $InputFile

foreach ($Row in $tblData) 

{ 

    $ADgroupname = ""

    $SPGroupName = ""

    $spweburl = ""

    $ADGroupName = $Row.ADGroup

    $SPGroupName = $Row.SPGroup

    $spweburl = $Row.SiteUrl

    Write-Host $spweburl $ADgroupname $SPGroupName  -ForegroundColor Green

    write-host "Starting work..."  -ForegroundColor Green

    # Hard coded variables for testing, 

    # ADGroupMembers = get-adgroupmember -Identity $ADgroupname | select @{name="LoginName";expression={$_.samaccountname}}

    $ADGroupMembers = Get-ADGroupMember $ADgroupname | Select-Object samaccountname, email, name
 
    # Exception handling empty AD Group
    
    if ($ADGroupMembers -eq $null)

    {

        Write-host "The AD Group we're syncing with is empty - this is usually a problem or typo - the SP group will be left alone" -foregroundcolor red

        return;

    }


    Write-Host "exit" -ForegroundColor magenta
    
    # Get the list of users in the SharePoint Group
    $web = get-spweb $spweburl

    # $group = $web.groups[$SPGroupName]
    $group = $web.SiteGroups[$SPGroupName]


    if ($group -eq $null) {write-host "SPGroup Not found" ; return}

    $spusers = $group.users | Select-Object @{name="LoginName";expression={$_.LoginName.toupper()}}

    write-host "Debug: at this point we should have a list of user ID's from SharePoint in domain\user format, uppercase" 

    foreach($x in $spusers)
    {
        write-host $x.LoginName -foregroundcolor green
    }
        # Delate user form SharePoint group 

        if($SPGroupName -ne $null)

        {

        $site = new-object Microsoft.SharePoint.SPSite ( $spweburl ) 

        $web = $site.OpenWeb() 

        "Web is : " + $web.Title 

        $oSiteGroup = $web.SiteGroups[$SPGroupName]; 

        "Site Group is :" + $oSiteGroup.Name 

        $oUsers = $oSiteGroup.Users 

            foreach ($oUser in $oUsers) 

                { 
                    "Removing user : " + $oUser.Name 
                    $oSiteGroup.RemoveUser($oUser) 
                } 

        }
      
    # Add the AD Users from AD Groups to Sharepoint Groups  
    if($spusers -ne $null)

    {

        write-host "The SPgroup is empty" -foregroundcolor cyan

        write-host "Adding all AD group members to the SP group"

        foreach ($ADGroupMember in $ADGroupMembers)

        {

            # Add the AD group member to the SP group. 

            # Please add code to get the domain or fix it if you have only one doain

            $Domain= "cee\"

            $SamAccountName = $ADGroupMember.samaccountname

            $UserName = $Domain + $ADGroupMember.samaccountname

            $DisplayName = $ADGroupMember.name

            $Email = (Get-ADUser $SamAccountName -Properties mail).mail

            write-host "Adding $()" 

            write-host "new-spuser -useralias  $($UserName) -web $($web.url) -group $SPGroupName" -foregroundcolor green

            $SPUser = $web.EnsureUser($UserName)


            # Exception handling User already exists, User is Added.., "Done adding user from $ADgroupname to $SPGroupName. Moving to Next..."     
            try 
            
                { 
            
                    $group.AddUser($SPUser) 
            
                }

                catch

                {

                    Write-Host "User already exists..." -ForegroundColor Red

                }

            Write-Host "User is Added..." -ForegroundColor cyan      
                 
        }

        Write-Host "Done adding user from $ADgroupname to $SPGroupName. Moving to Next..." -ForegroundColor Green

        }

}

    New-EventLog -LogName Application -Source "SharePoint" -ErrorAction SilentlyContinue
    Write-EventLog -LogName Application -Source "SharePoint" -EntryType Information -EventId 1 -Message "SYNC SUCCESS Script will now exit"  
    Write-Host "SYNC SUCCESS Script will now exit" -ForegroundColor magenta

}

Catch 

{
    
    New-EventLog -LogName Application -Source "SharePoint" -ErrorAction SilentlyContinue
    Write-EventLog -LogName Application -Source "SharePoint" -EntryType Information -EventId 1 -Message "SYNC FAILED - Please check parametrs or contact us directly..."  
    Write-Host "SYNC FAILED - Please check parametrs or contact us directly..." -ForegroundColor Red
} 


# End of code