#Create Azure VPN Root Cert 

$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "CN=AzureVPNRoot" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign

#Create Azure VPN Client Cert that you have to export as *.pfx file and share it with end users

New-SelfSignedCertificate -Type Custom -DnsName AzureVPNClient -KeySpec Signature `
-Subject "CN=AzureVPNClient" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")