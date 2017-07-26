Param(
    [string]$solutionIdentity
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$slnExists = (Get-SPSolution -identity $solutionIdentity -ErrorAction SilentlyContinue) -ne $null
If($slnExists -eq $true){

    $sln = Get-SPSolution -identity $solutionIdentity

    If($sln.Deployed -eq $true){
        if ($sln.ContainsWebApplicationResource){
            Uninstall-SPSolution -Identity $solutionIdentity -AllWebApplications -Confirm:$false
        }
        else{
            Uninstall-SPSolution -Identity $solutionIdentity -Confirm:$false
        }
        
        Write-Verbose "Uninstalling $solutionIdentity ..." -verbose
        while($sln.JobExists) { 
            Write-Verbose "Uninstallation in progress..." -verbose
            start-sleep -s 10
        }
    }
    Write-Verbose "Removing $solutionIdentity ..." -verbose
    Remove-SPSolution -Identity $solutionIdentity -Confirm:$false
}
Else{
    Write-Warning "Solution with identity $solutionIdentity does not exist!" -Verbose
}

Stop-SPAssignment -Global