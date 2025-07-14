@echo off
:: Get the directory of the batch file
set "SCRIPT_DIR=%~dp0"

:: Arguments from batch file
:: %1 = first argument
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%send_hex.ps1" "%~1"
pause
