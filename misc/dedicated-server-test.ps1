$currentPath = Get-Location
Set-Location "C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid"
Start-Process .\ProjectZomboidServer.bat
Start-Sleep -Seconds 1
.\ProjectZomboid64.exe -debug -nosteam
Start-Sleep -Seconds 1
.\ProjectZomboid64.exe -debug -nosteam
Set-Location $currentPath