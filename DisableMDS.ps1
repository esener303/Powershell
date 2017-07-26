Param(
    [string]$webURL
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$mdsFeatureId = "87294C72-F260-42f3-A41B-981A2FFCE37A"
$webExists = (Get-SPWeb $webURL -ErrorAction SilentlyContinue) -ne $null

If ($webExists) {
	$featureEnabled = (Get-SPFeature -Identity $mdsFeatureId -Web $webURL -ErrorAction SilentlyContinue) -ne $null
    If ($featureEnabled) {
		Write-Verbose "Deactivating MDS ..." -verbose 
		Disable-SPFeature –Identity $mdsFeatureId –url $webURL -Confirm:$false
	}
	Else{
		Write-Warning "MDS is already disabled" -verbose 
	}
}
Else {
	Write-Warning "Web at $webURL does not exist" -verbose 
}

Stop-SPAssignment -Global