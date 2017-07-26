Param(
    [string]$siteURL,
    [string]$siteName,
    [string]$siteOwner
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$siteExists = (Get-SPSite $siteURL -ErrorAction SilentlyContinue) -ne $null

If ($siteExists) {
    Write-Verbose "Removing site $siteURL ..." -verbose
	Remove-SPSite -Identity $siteURL  -Confirm:$False
}

Write-Verbose "Creating site $siteURL ..." -verbose
New-SPSite $siteURL -OwnerAlias $siteOwner -Language 1045 -Name $siteName -Template "STS#0"

Stop-SPAssignment -Global