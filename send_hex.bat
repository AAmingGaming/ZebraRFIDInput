@echo off
:: Arguments from batch file
:: %1 = first argument
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "./send_hex.ps1" "%~1"
pause
