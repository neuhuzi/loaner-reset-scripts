# LOANER MACHINE SOFT RESET UTILITY

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "       LOANER MACHINE SOFT RESET UTILITY"
Write-Host "==================================================="
Write-Host ""
Write-Host "This script will:"
Write-Host "  1. Clear Downloads, Documents, and Desktop folders"
Write-Host "  2. Clear browser data (Chrome, Firefox, Edge)"
Write-Host "  3. Sign out of Microsoft 365 applications"
Write-Host "  4. Remove saved credentials"
Write-Host ""
Write-Host "Press CTRL+C to cancel or any key to continue..."
$null = Read-Host

# Create log file
$logFile = "$env:TEMP\reset_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
Write-Host "Starting reset process at $(Get-Date)" | Out-File -FilePath $logFile -Append

Write-Host ""
Write-Host "[*] Clearing user folders..."

# Clear common user folders
$folders = @("Downloads", "Desktop", "Documents", "AppData\Local\Temp")
foreach ($folder in $folders) {
    $folderPath = Join-Path -Path $env:USERPROFILE -ChildPath $folder
    Write-Host "  - Clearing $folder folder..."
    if (Test-Path $folderPath) {
        Remove-Item -Path "$folderPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "    Done."
    } else {
        Write-Host "    Folder not found, skipping."
    }
}

Write-Host ""
Write-Host "[*] Clearing browser data..."

# Clear Chrome data
Write-Host "  - Clearing Google Chrome data..."
Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
$chromePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Google\Chrome\User Data"
if (Test-Path $chromePath) {
    Remove-Item -Path "$chromePath\Default\Cache" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$chromePath\Default\Cookies" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$chromePath\Default\History" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$chromePath\Default\Login Data" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$chromePath\Default\Web Data" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    Done."
} else {
    Write-Host "    Chrome not installed, skipping."
}

# Clear Edge data
Write-Host "  - Clearing Microsoft Edge data..."
Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue
$edgePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Microsoft\Edge\User Data"
if (Test-Path $edgePath) {
    Remove-Item -Path "$edgePath\Default\Cache" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$edgePath\Default\Cookies" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$edgePath\Default\History" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$edgePath\Default\Login Data" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$edgePath\Default\Web Data" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    Done."
} else {
    Write-Host "    Edge not installed, skipping."
}

# Clear Firefox data
Write-Host "  - Clearing Firefox data..."
Stop-Process -Name "firefox" -Force -ErrorAction SilentlyContinue
$firefoxPath = Join-Path -Path $env:APPDATA -ChildPath "Mozilla\Firefox\Profiles"
if (Test-Path $firefoxPath) {
    Get-ChildItem -Path $firefoxPath -Directory | ForEach-Object {
        Remove-Item -Path "$($_.FullName)\cache" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$($_.FullName)\cookies.sqlite" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$($_.FullName)\places.sqlite" -Force -ErrorAction SilentlyContinue
    }
    Write-Host "    Done."
} else {
    Write-Host "    Firefox not installed, skipping."
}

Write-Host ""
Write-Host "[*] Signing out of Microsoft 365 applications..."

# Sign out of Microsoft Office applications
Write-Host "  - Removing Office credentials..."
Stop-Process -Name "OUTLOOK" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "WINWORD" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "EXCEL" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "POWERPNT" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "ONENOTE" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "MSTEAMS" -Force -ErrorAction SilentlyContinue

# Clear Office credentials
Remove-Item -Path "HKCU:\Software\Microsoft\Office\16.0\Common\Identity" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "    Done."

Write-Host ""
Write-Host "[*] Removing saved credentials..."

# Clear Credential Manager saved passwords
Write-Host "  - Clearing Windows Credential Manager..."
$credsList = cmdkey /list
$credsList | ForEach-Object {
    if ($_ -match "Target:\s*(.*)") {
        cmdkey /delete:$matches[1]
    }
}
Write-Host "    Done."

Write-Host ""
Write-Host "[*] Removing OneDrive cached data..."
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
$oneDrivePath = Join-Path -Path $env:USERPROFILE -ChildPath "OneDrive"
if (Test-Path $oneDrivePath) {
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive\settings" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    Done."
} else {
    Write-Host "    OneDrive not configured, skipping."
}

Write-Host ""
Write-Host "[*] Removing Teams cached data..."
$teamsPath = Join-Path -Path $env:APPDATA -ChildPath "Microsoft\Teams"
if (Test-Path $teamsPath) {
    Remove-Item -Path "$teamsPath\Cache" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$teamsPath\blob_storage" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$teamsPath\databases" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$teamsPath\Local Storage" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$teamsPath\tmp" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "    Done."
} else {
    Write-Host "    Teams not installed, skipping."
}

Write-Host ""
Write-Host "==================================================="
Write-Host "       SOFT RESET COMPLETED SUCCESSFULLY"
Write-Host "==================================================="
Write-Host ""
Write-Host "Log file created at: $logFile"
Write-Host ""
Write-Host "The machine is now ready for the next user."
Write-Host "Please restart the computer before handing it over."
Write-Host ""
Write-Host "Press any key to exit..."
$null = Read-Host
