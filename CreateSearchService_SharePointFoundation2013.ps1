Add-PSSnapin Microsoft.Sharepoint.Powershell

## Set Your Variables ##

# Set the name of the search service
$serviceAppName = "Search Service Application"

# Set the name and account of the Search Service Application Pool
$saAppPoolName = "Search Service App Pool"
$appPoolUserName = "FOUNDATION\SpSearchSvc"

# Set the names of the Databases to be used by Search
$adminDB = "SHPDEV_Search"
$propertyStoreDB = "SHPDEV_Search_PropertyStore"
$crawlStoreDB = "SHPDEV_Search_CrawlStore"
$analysticsStoreDB = "SHPDEV_Search_AnalyticsStore"
$linkStoreDB = "SHPDEV_Search_LinkStore"

## Start of Script ##

# Script to Create App Pool for use by Search Service
$saAppPool = Get-SPServiceApplicationPool -Identity $saAppPoolName -EA 0
if($saAppPool -eq $null)
{
    Write-Host "Creating Search Service Application Pool..."

    $appPoolAccount = Get-SPManagedAccount -Identity $appPoolUserName -EA 0
    if($appPoolAccount -eq $null)
    {
        Write-Host "Please supply the password for the Service Account..."
        $appPoolCred = Get-Credential $appPoolUserName
        $appPoolAccount = New-SPManagedAccount -Credential $appPoolCred -EA 0
    }

    $appPoolAccount = Get-SPManagedAccount -Identity $appPoolUserName -EA 0

    if($appPoolAccount -eq $null)
    {
        Write-Host "Cannot create or find the managed account $appPoolUserName, please ensure the account exists."
        Exit -1
    }

    New-SPServiceApplicationPool -Name $saAppPoolName -Account $appPoolAccount -EA 0 > $null

}

# Script to create Search Service Application
Start-SPEnterpriseSearchServiceInstance $env:computername
Start-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance $env:computername
$svcPool = Get-SPServiceApplicationPool "Search Service App Pool"
$adminPool = Get-SPServiceApplicationPool "Search Service App Pool"
$searchServiceInstance = Get-SPEnterpriseSearchServiceInstance –Local
$searchService = $searchServiceInstance.Service
$adminDBParameters = [Microsoft.SharePoint.Administration.SPDatabaseParameters]::CreateParameters($adminDB,"None")
$propertyDBParameters = [Microsoft.SharePoint.Administration.SPDatabaseParameters]::CreateParameters($propertyStoreDB,"None")
$crawlStoreDBParameters = [Microsoft.SharePoint.Administration.SPDatabaseParameters]::CreateParameters($crawlStoreDB,"None")
$analyticsStoreDBParameters = [Microsoft.SharePoint.Administration.SPDatabaseParameters]::CreateParameters($analysticsStoreDB,"None")
$linkStoreDBParameters = [Microsoft.SharePoint.Administration.SPDatabaseParameters]::CreateParameters($linkStoreDB,"None")
$searchServiceApp = $searchService.CreateApplication($serviceAppName,

$adminDBParameters, $propertyDBParameters, $crawlStoreDBParameters,

$analyticsStoreDBParameters, $linkStoreDBParameters, [Microsoft.SharePoint.Administration.SPIisWebServiceApplicationPool]$svcPool, [Microsoft.SharePoint.Administration.SPIisWebServiceApplicationPool]$adminPool)
$searchProxy = New-SPEnterpriseSearchServiceApplicationProxy -Name "$serviceAppName Proxy" -SearchApplication $searchServiceApp
$searchServiceApp.Provision()

# Script to configure the Search Topology and Deploy it
$searchServiceInstance = Get-SPEnterpriseSearchServiceInstance –Local
$bindings = @("InvokeMethod", "NonPublic", "Instance")
$types = @([Microsoft.Office.Server.Search.Administration.SearchServiceInstance])
$values = @([Microsoft.Office.Server.Search.Administration.SearchServiceInstance]$searchServiceInstance)
$methodInfo = $searchServiceApp.GetType().GetMethod("InitDefaultTopology", $bindings, $null, $types, $null)
$searchTopology = $methodInfo.Invoke($searchServiceApp, $values)
