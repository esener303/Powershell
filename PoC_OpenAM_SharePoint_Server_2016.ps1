Add-PSSnapin Microsoft.SharePoint.Powershell

$cert = New-Object system.security.cryptography.x509certificates.x509certificate2("C:\openam\openam.cer")

$map = New-SPClaimTypeMapping "http://schemas.xmlsoap.org/claims/EmailAddress" -IncomingClaimTypeDisplayName "EmailAddress" -LocalClaimType "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"

$realm = "https://poc.dev.pl:443/" #sharepoiont public endpoint url

$signinurl = "https://testopenam.ecm365.pl:8443/openam/WSFederationServlet/metaAlias/openam-wsfed-idp" #openam endpoint url

$idp = New-SPTrustedIdentityTokenIssuer -Name "OpenAM Federation" -Description "OpenAM 9.5.3" -Realm $realm -SignInUrl $signinurl -ImportTrustCertificate $cert -ClaimsMappings $map -IdentifierClaim $map.InputClaimType

New-SPTrustedRootAuthority -name "OpenAM" -Certificate $cert

# w przypadku błędu logowania sharepoint należy uruchpomić poniższe wiersze poleceń

#$ap = Get-SPTrustedIdentityTokenIssuer -Identity "OpenAM Federation"
#$ap.UseWReplyParameter=$false 
#$ap.Update() 

#Remove-SPTrustedRootAuthority -Identity "OpenAM"
#Remove-SPTrustedIdentityTokenIssuer -Identity "OpenAM Federation" 

