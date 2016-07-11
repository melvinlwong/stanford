$ErrorActionPreference = "SilentlyContinue"
$Groups = Get-ADGroup -Filter * -Properties *
$PropertyCol = @(
                 "Name", "Members", "SID"
                    )

Foreach ($group in $Groups){
                    $process = $group | select Name, Members, SID
                    $process.Name = $group.name
                    $username = (($group | %{(Get-ADGroupMember -identity $group.Name).SamAccountName})-join ',')
                    $process.Members = $username
                    $process.SID = $group.SID
                    Write-Output $process
}