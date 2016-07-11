$ErrorActionPreference = "SilentlyContinue"
Get-ADComputer -Filter 'Enabled -eq "True"' -Properties Name -SearchBase "OU=Servers,OU=SESI,DC=lbre-sesi,DC=stanford,DC=edu"`
 | Where-Object {($_.Name -ne 'LBRE-SESI-SRV2' -and $_.Name -ne 'LBRE-SESI-MLW02')}`
 | Select -ExpandProperty Name | Out-File "C:\Scripts\UGQuery\member_servers.txt"
$Computers = (Get-Content "C:\Scripts\UGQuery\member_servers.txt")
$datagroup='LBRE-SESI\CEF Data Collectors'

cd C:\Scripts\UGQuery

Foreach ($computer in $Computers){
                    .\Set-WmiNamespaceSecurity.ps1 root add "$datagroup" Enable,RemoteAccess -co "$computer"
                    .\Set-WmiNamespaceSecurity.ps1 root/cimv2 add "$datagroup" Enable,RemoteAccess -co "$computer"
                    }