$ErrorActionPreference = "SilentlyContinue"
$Users = Get-ADUser -Filter * -Properties *
$PropertyCol = @(
                 "Domain", "UserName", "FullName", "Enabled", "LastLogin", "LastPasswordChange", "Expired",
                 "NonExpirable", "SID"
                    )

Foreach ($user in $Users){
                    $process = $user | select Domain, UserName, FullName, Disabled, LastLogin, LastPasswordChange,`
                               Expired, NonExpirable, SID
                    $process.Domain = 'LBRE-SESI'
                    $process.UserName = $user.SamAccountName
                    $process.FullName = $user.Name
                    $process.Enabled = $user.Enabled
                    $process.LastLogin = $user.LastLogonDate
                    $process.LastPasswordChange = $user.PasswordLastSet
                    $process.Expired = $user.PasswordExpired
                    $process.NonExpirable = $user.PasswordNeverExpires
                    $process.SID = $user.SID
                    Write-Output $process
}