Param(
    [string]$solutionId
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$slnExists = (Get-SPSolution -identity $solutionId -ErrorAction SilentlyContinue) -ne $null
If($slnExists -eq $true){
	$solution = Get-SPSolution -Identity $solutionId
	$solutionFarmFeatures = Get-SPFeature | Where-Object { ($_.SolutionId -eq $solution.SolutionID) -and ($_.Scope -eq 'Farm') }
	foreach($feat in $solutionFarmFeatures){
        $featName = $feat.DisplayName
        $featActivated = (Get-SPFeature -Identity $feat.Id -ErrorAction SilentlyContinue -Farm) -ne $null
        If($featActivated -eq $true){
            Write-Warning "Feature $featName is already activated!" -Verbose
        }
        Else{
		    
		    Write-Verbose "Activating $featName ..." -verbose
		    Enable-SPFeature -identity $feat.Id -Confirm:$false
        }
	}
}
Else{
    Write-Warning "Solution with identity $solutionId does not exist!" -Verbose
}
Stop-SPAssignment -Global