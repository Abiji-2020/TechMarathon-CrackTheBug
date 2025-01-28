param (
    [switch]$Create
)

# Define the URL for NirCmd and paths for download and extraction in the user's directory
$URL = "https://www.nirsoft.net/utils/nircmd.zip"
$downloadsPath = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads", "nircmd.zip")
$extractPath = [System.IO.Path]::Combne($env:USERPROFILE, "Downloads", "nircmd")

# Ensure TLS 1.2 is used for secure connections
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ($Create) {
    # Download the NirCmd zip file
    Write-Host "Downloading NirCmd from: $URL" -ForegroundColor Yellow
    Invoke-WebRequest -Uri $URL -OutFile $downloadsPath -ErrorAction Stop

    # Extract the downloaded zip file
    Write-Host "Extracting $downloadsPath to $extractPath" -ForegroundColor Yellow
    Expand-Archive -LiteralPath $downloadsPath -DestinationPath $extractPath -Force

    # Create shortcuts with specific commands and hotkeys using NirCmd
    $shortcutOff = "$env:USERPROILE\Desktop\TurnOffMonitor.lnk"
    $shortcutOn = "$env:USERPROFILE\Desktop\TurnOnMonitor.lnk"

    # Command for turning off and on the monitor
    $nircmdCommandOff = "monitor off"
    $nircmdCommandOn = "monitor on"

    # Function to create a shortcut
    function Create-Shortcut {
        para (
            [string]$shortcutPath,
            [string]$targetPath,
            [string]$arguments,
            [string]$hotKey
        )
        $wshell = New-Object -ComObject WScript.Shell
        $shortcutObj = $wshell.CreateShortcut($shortcutPath)
        $shortcutObj.TargetPath = $targetPath
        $shortcutObj.Arguments = $arguments
        $shortcutObj.HotKey = $hotKey
        $shortcutObj.Save()
    }

    # Create shortcuts for turning off and on the monitor
    Create-Shortcut -shortcutPath $shortcutOff -targetPath "$extractPath\nircm.exe" -arguments $nircmdCommandOff -hotKey "CTRL+ALT+O"
    Create-Shortcut -shortcutPath $shortcutOn -targetPath "$extractPath\nircmd.exe" -arguments $nircmdCommandOn -hotKey "CTRL+ALT+I"

    Write-Host "Shortcuts created on Desktop to turn monitor off and on."

} elseif ($Remove) {
    # Define paths for the shortcuts and the extracted folder
    $shortcutOff = "$env:USRPROFILE\Desktop\TurnOffMonitor.lnk"
    $shortcutOn = "$env:USERPROFILE\Desktop\TurnOnMonitor.lnk"

    # Function to remove a shortcut if it exists
    function Remove-Shortcut {
        param (
            [string]$shortcutPath
        )
        if (Test-Path $shortcutPath) {
            Remove-Item $shortcutPath -Force
            Write-Host "Removed shortcut: $shortcutPath" -ForegroundColor Green
        } else {
            Write-Host "Shortcut not found: $shortcutPath" -ForegroundColor Red
        }
    }

    # Remove existing shortcuts
    Remove-Shortcut -shortcutath $shortcutOff
    Remove-Shortcut -shortcutPath $shortcutOn

    # Remove the extracted folder and its contents if it exists
    if (Test-Path $extractPath) {
        Remove-Item $extractPath -Recurse -Force
        Write-Host "Removed extracted folder: $extractPath" -ForegroundColor Green
    } else {
        Write-Host "Extracted folder not found: $extractPath" -ForegroundColor Red
    }

    # Remove the downloaded zip file if it exists
    if (Test-Path $downloadsPath) {
        Remove-Item $downloadsPath -Force
        Write-Hst "Removed downloaded file: $downloadsPath" -ForegroundColor Green
    } else {
        Write-Hst "Downloaded file not found: $downloadsPath" -ForegroundColor Red
    }

    Write-Host "Removal operation completed."
} else {
    Write-Host "Please specify either `-Create` or `-Remove` parameter." -ForegroundColor Red
}
