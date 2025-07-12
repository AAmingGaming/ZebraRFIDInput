@echo off

set "URL=https://www.zebra.com/etc.clientlibs/zebra-web/clientlibs/clientlib-site/resources/images/favicons/favicon.ico"
set "OUTPUT=shortcut_icon.ico"

echo Downloading favicon from: %URL%
echo.

curl -s -S -L "%URL%" -o "%OUTPUT%"

if exist "%OUTPUT%" (
    echo SUCCESSFULLY downloaded the Favicon as %OUTPUT%
) else (
    echo FAILED to download the Favicon
)

pause
