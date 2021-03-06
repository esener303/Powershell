#Script add multiple users, groups and groups permissions to SharePoint 2013 from *.csv file.
#by sharepointdevelopmentblog.wordpress.com
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) {
Write-Host "Connect SharePoint Cmd-Let" 
Add-PSSnapin Microsoft.SharePoint.PowerShell 
}
$Site = Get-SPSite https://swkz-tst
$Web = $Site.RootWeb

$ownerName = "CLUSTER\SpSetupUsr"
$op = New-SPClaimsPrincipal CLUSTER\SpSetupUsr -IdentityType WindowsSamAccountName
$owner = $Web | Get-SPUser $op

$csvlocation = "c:\csv\users.csv"
$values = Import-Csv $($csvlocation) -Delimiter ";" 

$values | ForEach-Object {

    #Checking this group already exist in SP   
    if(!$Web.SiteGroups[$_.group] -eq $_.group) {
        
        #Adding Group
        $Web.SiteGroups.Add($_.group, $owner, $null, $null) 
        $SPGroup = $Web.SiteGroups[$_.group]
        $assignment = New-Object Microsoft.SharePoint.SPRoleAssignment($Web.SiteGroups[$_.group])
        $role = $web.RoleDefinitions["Read"]
        $assignment.RoleDefinitionBindings.Add($role);
        $web.RoleAssignments.Add($assignment)
    }
    
    #Adding User to Group
    $SPGroup = $Web.SiteGroups[$_.group]
    $SPGroup.AddUser($_.user,"","",$_.group) 

#Added User and Group listed on console 
Write-Host "User :" $_.user "added to Group " $_.group

}

$web.Dispose()
$site.Dispose()

#https://sharepointdevelopmentblog.wordpress.com/