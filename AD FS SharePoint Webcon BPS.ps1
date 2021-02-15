Add-PSSnapin Microsoft.SharePoint.Powershell

$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate("C:\Users\SpSetupUsr\Desktop\adfs_eod.cer")
New-SPTrustedRootAuthority -Name "Token Signing Cert" -Certificate $cert

$emailClaimMap = New-SPClaimTypeMapping -IncomingClaimType "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress" -IncomingClaimTypeDisplayName "EmailAddress" -SameAsIncoming
$upnClaimMap = New-SPClaimTypeMapping -IncomingClaimType "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn" -IncomingClaimTypeDisplayName "UPN" -SameAsIncoming
$roleClaimMap = New-SPClaimTypeMapping -IncomingClaimType "http://schemas.microsoft.com/ws/2008/06/identity/claims/role" -IncomingClaimTypeDisplayName "Role" -SameAsIncoming
$sidClaimMap = New-SPClaimTypeMapping -IncomingClaimType "http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid" -IncomingClaimTypeDisplayName "SID" -SameAsIncoming

$realm = "urn:sharepoint:eod"
$signInURL = "https://eod-test.grupatrakcja.com/_trust/"
$ap = New-SPTrustedIdentityTokenIssuer -Name "ADFS30" -Description "AD Federation Server" -realm $realm -ImportTrustCertificate $cert -ClaimsMappings $emailClaimMap,$upnClaimMap,$roleClaimMap,$sidClaimMap -SignInUrl $signInURL -IdentifierClaim $upnClaimMap.InputClaimType #Uwaga! W ostatnim poleceniu w części –IdentifierClaim zamieniamy zmienną $emailClaimmap na $upnClaimMap. Jest to związane z faktem, że w instalacji BPS będziemy używać UserPrincipalName do autentykacji. Po wykonaniu wszystkich kroków z podane artykułu (z uwzględnieniem poprawki z skrypcie) instalacja jest prawie gotowa.