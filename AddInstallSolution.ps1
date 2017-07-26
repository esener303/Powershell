Param(
    [string]$solutionIdentity,
    [string]$wspFolder
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$wspPath = $wspFolder + "\" + $solutionIdentity

Write-Verbose "Adding $solutionName ..." -verbose

Add-SPSolution -LiteralPath $wspPath

$sln = get-SPSolution -identity $solutionIdentity

if($sln -ne $null){

    Write-Verbose "Installing $solutionIdentity ..." -verbose

    if ($sln.ContainsWebApplicationResource){
        Install-SPSolution -AllWebApplications -identity $solutionIdentity -GACDeployment -Force
    }
    else{
        Install-SPSolution -identity $solutionIdentity -GACDeployment -Force
    }
    while($sln.JobExists) { 
        Write-Verbose "Installation in progress ..." -verbose
        start-sleep -s 5
    }
}

Stop-SPAssignment -Global