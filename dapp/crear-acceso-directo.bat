@echo off
echo Creando acceso directo en el escritorio...
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\Document Registry dApp.lnk'); $Shortcut.TargetPath = 'C:\Users\jcmxo\DocumentRegistry\dapp\iniciar-dapp.bat'; $Shortcut.WorkingDirectory = 'C:\Users\jcmxo\DocumentRegistry\dapp'; $Shortcut.Description = 'Inicia la Document Registry dApp'; $Shortcut.Save(); Write-Host 'Acceso directo creado exitosamente'"
pause


