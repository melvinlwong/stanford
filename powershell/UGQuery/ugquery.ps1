$ErrorActionPreference = "SilentlyContinue"
cd C:\Scripts\UGQuery
Get-ADComputer -Filter 'Enabled -eq "True"' -Properties Name -SearchBase "OU=Servers,OU=SESI,DC=lbre-sesi,DC=stanford,DC=edu"`
 | Where-Object {($_.Name -ne 'LBRE-SESI-SRV2' -and $_.Name -ne 'LBRE-SESI-MLW02' -and $_.Name -ne 'LBRE-SESI-COL1')}`
 | Select -ExpandProperty Name | Out-File "C:\Scripts\UGQuery\member_servers.txt"
#
$path = "\\lbre-sesi-srv2\sesi-dropoff\Reports"
$limit = (Get-Date).AddDays(-90)
$oldfiles = (Get-ChildItem -Path $path | Where-Object { !$_.PSISContainer -and $_.CreationTime -lt $limit})
#
Function ugreport{
                  . .\GetLocalGroup.ps1
                  Get-LocalGroup | select Computername, Name, Members | Export-Csv -NoTypeInformation "$path\local-groups-$(get-date -UFormat %Y%m%d).csv"
                  .\GetDomainGroup.ps1 | select Name, Members | Export-Csv -NoTypeInformation "$path\domain-groups-$(get-date -UFormat %Y%m%d).csv"
                  .\GetLocalUser.ps1 | select Machine, Name, Disabled, LastLogin, PasswordExpires, LastPasswordChange | Export-Csv -NoTypeInformation "$path\local-users-$(get-date -UFormat %Y%m%d).csv"
                  .\GetDomainUser.ps1 | select UserName, Enabled, LastLogin, LastPasswordChange, Expired, NonExpirable | Export-Csv -NoTypeInformation "$path\domain-users-$(get-date -UFormat %Y%m%d).csv"
                               
}
#
if ($oldfiles){
                $oldfiles | Remove-Item
                ugreport
            }
            else {
                ugreport
            }