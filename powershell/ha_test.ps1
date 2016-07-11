$i=0
Clear-Content "Y:\Temp\helloworld.txt"
#
while ($i -lt 300){
    $i=[int]$i + 1
    Write-Host "$i"
    Get-Date -format 'M-d hh:mm:ss' | Out-File -Append "Y:\Temp\helloworld.txt"
    Start-Sleep 1
   }