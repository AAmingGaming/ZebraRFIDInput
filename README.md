# Setup

## Download Zebra Logo
- Since the Zebra Logo is copyrighted it is not included directly in this repo. However, you should execute the script `dowload_zebra_icon.bat` to download the icon from the Zebra website. \
Note any other icon file can be used as long as its named `shortcut_icon.ico`.

## Computer Setup
1. Download SDK platform-tools for your OS from [the android developer website](https://developer.android.com/tools/releases/platform-tools).
2. Extract the downloaded zip file
3. Add the directory containing `adb.exe` to the computers PATH / Sysytem Environment Variables - [Windows 10/11 Tutorial](https://www.youtube.com/watch?v=pGRw1bgb1gU) \
Note: this cna be done for the user or the system, the most stable method is applying it to the system

## Device Setup
1. Goto Settings and enable developer options (Usually Settings->System->About Phone and press Build Number 10 times)
2. Goto Developer Options/Settings (Usually Settings->Developer Settings OR Settings->System->Developer Settings)
3. Enable USB Debugging
4. Plug Zebra Device into the Computer - there should be a popup saying 'Allow USB Debugging'
5. Tick/Enable 'Always allow from this computer' and press 'OK'

## Verify Setup
1. Open a Powershell / CMD Terminal on the Computer
2. While the Zebra Scanner/Reader is plugged in, execute `abd devices` - there should be 1 device attached
3. Remove the Zebra Scanner/Reader from the Dock/holder and re-run `abd devices` - there should be 0 devices attached
4. Re-Dock the Zebra Scanner/Reader, wait a couple seconds and, once agian, execute `abd devices` - there should be 1 device attached

### Troubleshooting
#### In the Terminal ther is the error `adb: The term 'adb' is not recognised....`
• Ensure that the platform-tools .zip file was correctly downloaded and extracted
• Ensure the platform-tools directory (containing `adb.exe`) is correctly added to the system PATH.

#### In step 2. of 'Verify Setup', 0 Devices Appear
• Check that USB Debugging is enabled
• Ensure that the Computer is allowed / permitted for USB Debugging

#### There is a popup on the Scannner/Reader 
• Ensure that the 'Always allow from this computer' tickbox is ACTIVE/ENABLED before pressing 'OK'

# Generate a Shortcut to the script
A shortcut can be generated to manually execute the script from the desktop / elsewhere. \
• Simply run / execute the `create_shortcut.ps1` or `create_shortcut.bat` script and a Shortcut 'Run RFID Tool' will be made which can be moved elsewhere.

# Running the `send_hex` tool.
```shell
send_hex.ps1 [hex_key] 
send_hex.bat [hex_key]
```

## Overview of the tool
- Check there is a device connected to the computer
- Gets commmand line argument for hex_key, if none provided, queries the user
- If the screen is off, turn it on
- If the device is locked, unlock it
- Launch the 'Zebra RFID API Mobile' App / Relaunch the app to open on the homepage (MainActivity)
- Navigate to the 'Locate Tag' section of the RFID App
- Select / Highlight the text input field
- Pass (previously obtained) hex_key into the input field
- Close the keyboard (style choice)
