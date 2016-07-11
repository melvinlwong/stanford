$ErrorActionPreference = "SilentlyContinue"

<#Get-ADComputer -Filter 'Enabled -eq "True"' -Properties Name -SearchBase "OU=Servers,OU=SESI,DC=lbre-sesi,DC=stanford,DC=edu"`
 | Where-Object {($_.Name -ne 'LBRE-SESI-SRV2' -and $_.Name -ne 'LBRE-SESI-MLW02'-and $_.Name -ne 'LBRE-SESI-COL1' -and $_.Name -ne 'LBRE-SESI-COL3')}`
 | Select -ExpandProperty Name | Out-File "C:\Scripts\UGQuery\member_servers.txt"
#>

$ComputerName=(Get-Content C:\Scripts\UGQuery\member_servers.txt)
$PropertyCol = @(
                  "Machine", "Name", "SID", "Disabled", "LastLogin", "PasswordExpires", "Disabled", "LastPasswordChange"
            )


Foreach($Computer in $ComputerName)
{
    $AllLocalAccounts=(Get-WmiObject -Class Win32_UserAccount -Namespace "root\cimv2"`
     -Filter "LocalAccount='$True'" -ComputerName $Computer -ErrorAction Stop)
        
    Foreach($LocalAccount in $AllLocalAccounts)
    {
    # Source Get-LocalLastLoginTime.ps1 for querying last-logon time
    . .\Get-LocalLastLogonTime.ps1
    $LastLogon= ($LocalAccount | %{(Get-LocalLastLogonTime -ComputerName $Computer -UserName $LocalAccount.Name).LastLogin})
    
    # Query for PasswordAge from ADSI interface
    $PasswordAge=(([adsi]"WinNT://$Computer").Children | where-Object {($_.SchemaClassName -eq 'user' -and $_.Name -eq $LocalAccount.Name)} | select -ExpandProperty PasswordAge)
     if ($PasswordAge -ne '0')
        { 
        $LastPasswordChange=((Get-Date).AddSeconds(-($PasswordAge)))
        }
    else
        {
        $LastPasswordChange='0'
        }

    $process = $LocalAccount | select Machine, Name, SID, Disabled, LastLogin, PasswordExpires, LastPasswordChange
    $process.Machine = $Computer
    $process.Name = $LocalAccount.Name
    $process.SID = $LocalAccount.SID
    $process.Disabled = $LocalAccount.Disabled
    $process.LastLogin = $LastLogon
    $process.PasswordExpires = $LocalAccount.PasswordExpires
    $process.Disabled= $LocalAccount.Disabled
    $process.LastPasswordChange = $LastPasswordChange
    Write-Output $process
        
    } 
}
