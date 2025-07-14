Set-StrictMode -Version Latest

# Get list of connected ADB devices (excluding header and empty lines) and count amount.
$devices = @(adb devices | Select-String -Pattern "device$" | ForEach-Object { ($_ -replace "\s+device", "").Trim() })
$device_count = $devices.Count

# If no devices then exit or, grab any attached.
if ($device_count -eq 0) {
    Write-Host "Error: No connected devices detected. Exiting..."
    exit 1
} elseif ($device_count -gt 1) {
    Write-Host "More than one device connected, selecting one..."
    $serial = $devices[0]
} else {
    $serial = $devices
}
Write-Host "Device Selected: $serial"

# Check if an argument was passed
if ($args.Count -eq 0 -or [string]::IsNullOrWhiteSpace($args[0])) {
    $input = Read-Host "No argument passed. Please enter a Hex Key"
	$hex_key = $input.Trim()
    if ([string]::IsNullOrWhiteSpace($hex_key)) {
        Write-Host "Error: No value input. Exiting..."
        exit 1
    }
} else {
    # Get the first positional argument
    $hex_key = $args[0]
}
# Trim whitespace at start/end
$hex_key = $hex_key.Trim()
# Check if it contains only alphanumeric characters (A-Z, a-z, 0-9)
if ($hex_key -notmatch '^[a-zA-Z0-9]+$') {
    Write-Host "Error: Hex Key must be alphanumeric only with no spaces or special characters."
    Write-Host "Hex Key value: '$hex_key'"
    exit 1
}

# Get the wm size output
$size_output = adb -s $serial shell wm size

# The output is like: "Physical size: 480x800"
# Extract the dimensions using regex
if ($size_output -match "Physical size: (\d+)x(\d+)") {
    $screen_width = [int]$matches[1]
    $screen_height = [int]$matches[2]
} else {
    Write-Host "Could not parse screen size. Defaulting to 480x800"
    $screen_width = 480
    $screen_height = 800
}
Write-Host "Screen width: $screen_width"
Write-Host "Screen height: $screen_height"

$mid_x = [math]::Round($screen_width / 2)

# Check if screen is ON or OFF
$display_status = adb -s $serial shell dumpsys power | Select-String "Display Power: state="
if ($display_status -match "state=OFF") {
    Write-Host "Screen is OFF. Waking up..."
    adb -s $serial shell input keyevent 26  # Wake device
    # Start-Sleep -Milliseconds 500  # some delay maybe necessary
} else {
    Write-Host "Screen is already ON."
}

# Check if device is locked
$lockscreen_status = adb -s $serial shell dumpsys window | Select-String "mDreamingLockscreen"
if ($lockscreen_status -match "mDreamingLockscreen=true") {
    # Calculate percentages and round to integer
    $start_y = [math]::Round($screen_height * 0.90)
    $end_y   = [math]::Round($screen_height * 0.20)

    Write-Host "Device is LOCKED, Unlocking..."
    adb -s $serial shell input swipe $mid_x $start_y $mid_x $end_y 100  # Swipe up over 100ms
} else {
    Write-Host "Device is UNLOCKED."
}

# (Re)Start App
Write-Host "Start the app & Navigate"
adb -s $serial shell am start -S -n com.zebra.rfidreaderAPI.demo/com.zebra.rfidreader.demo.home.MainActivity
# Wait 500 milliseconds for app to load before navigating (should work with ~200 but have 300 for buffer)
Start-Sleep -Milliseconds 500
# Press the Locate Tag Button
adb -s $serial shell input tap 150 420  # Position specific for screen size
# Wait 0.1 second for app to switch screens before selecing input
#Start-Sleep -Milliseconds 100
# Select input
adb -s $serial shell input tap $mid_x 150  # Position specific for screen size

# Send hex-key input
Write-Host "Hex Key sending: $hex_key"
adb -s $serial shell input text "$hex_key"

# Close Open Keyboard - Visual Option
# Check if keyboard is open with 
$active_keyboard = adb -s $serial shell dumpsys input_method | Select-String "mInputShown"
if ($active_keyboard -match "mInputShown=true") {
    adb -s $serial shell input keyevent 4  # KEYCODE_BACK
    Write-Host "Soft keyboard was open - closed it."
} else {
    Write-Host "Soft keyboard not detected."
}
Write-Host "SUCCESS! Exiting..."
exit 0
