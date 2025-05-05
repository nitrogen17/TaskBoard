$currentPath = Get-Location
Set-Location "C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid"
Start-Process .\ProjectZomboidServer.bat
.\ProjectZomboid64.exe -debug -nosteam
.\ProjectZomboid64.exe -debug -nosteam
Set-Location $currentPath