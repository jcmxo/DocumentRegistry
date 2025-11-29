Set WshShell = WScript.CreateObject("WScript.Shell")
Set Shortcut = WshShell.CreateShortcut(WshShell.SpecialFolders("Desktop") & "\Document Registry dApp.lnk")
Shortcut.TargetPath = "C:\Users\jcmxo\DocumentRegistry\dapp\iniciar-dapp.bat"
Shortcut.WorkingDirectory = "C:\Users\jcmxo\DocumentRegistry\dapp"
Shortcut.Description = "Inicia la Document Registry dApp"
Shortcut.Save
WScript.Echo "Acceso directo creado exitosamente en el escritorio"


