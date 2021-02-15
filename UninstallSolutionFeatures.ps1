Param(
    [string]$solutionId
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$slnExists = (Get-SPSolution -identity $solutionId -ErrorAction SilentlyContinue) -ne $null
If($slnExists -eq $true){
	$solution = Get-SPSolution -Identity $solutionId
	$solutionFarmFeatures = Get-SPFeature | Where-Object { ($_.SolutionId -eq $solution.SolutionID)}
	foreach($feat in $solutionFarmFeatures){
		$featName = $feat.DisplayName
		Write-Verbose "Uninstalling $featName ..." -verbose
		Uninstall-SPFeature -identity $feat.Id -Confirm:$false -Force
	}
}
Else{
    Write-Warning "Solution with identity $solutionId does not exist!" -Verbose
}
Stop-SPAssignment -Global