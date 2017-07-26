Param(
    [string]$featureId,
    [string]$featureScopeUrl
)

Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

Start-SPAssignment -Global

$feature = Get-SPFeature -Identity $featureId

if($feature.Scope -eq “Farm”){
    $alreadyEnabled = (Get-SPFeature -Identity $featureId -Farm -ErrorAction SilentlyContinue) -ne $null
    If($alreadyEnabled -eq $false){
        Write-Verbose "Activating farm feature: $featureId ..." -verbose 
        Enable-SPFeature –Identity $featureId
    }
    Else{
        Write-Verbose "Farm feature ( $featureId ) already enabled" -verbose 
    }
}
elseif($feature.Scope -eq “WebApplication”){
    $alreadyEnabled = (Get-SPFeature -Identity $featureId -WebApplication $featureScopeUrl -ErrorAction SilentlyContinue) -ne $null
    If($alreadyEnabled -eq $false){
        Write-Verbose "Activating web application feature: $featureId ..." -verbose
        Enable-SPFeature –Identity $featureId –url $featureScopeUrl
    }
    Else{
        Write-Verbose "Farm feature ( $featureId ) already enabled" -verbose 
    }
}
elseif($feature.Scope -eq “Site”){
    Write-Verbose "Activating site collection feature: $featureId ..." -verbose
    $alreadyEnabled = (Get-SPFeature -Identity $featureId -Site $featureScopeUrl -ErrorAction SilentlyContinue) -ne $null
    If($alreadyEnabled -eq $false){
        Enable-SPFeature –Identity $featureId –url $featureScopeUrl
    }
    Else{
        Write-Verbose "Farm feature ( $featureId ) already enabled" -verbose 
    }
}
elseif($feature.Scope -eq “Web”){
    Write-Verbose "Activating site feature: $featureId ..." -verbose
    $alreadyEnabled = (Get-SPFeature -Identity $featureId -Web $featureScopeUrl -ErrorAction SilentlyContinue) -ne $null
    If($alreadyEnabled -eq $false){
        Enable-SPFeature –Identity $featureId –url $featureScopeUrl
    }
    Else{
        Write-Verbose "Farm feature ( $featureId ) already enabled" -verbose 
    }
}

Stop-SPAssignment -Global