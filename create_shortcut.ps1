$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetPath = "$ScriptDir\send_hex.bat"         # Target file or application
$ShortcutPath = "$ScriptDir\Run RFID Tool.lnk"        # Where the shortcut should be saved
$IconPath = "$ScriptDir\shortcut_icon.ico"                # Icon file path (must be .ico)

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.IconLocation = $IconPath
$Shortcut.Save()
