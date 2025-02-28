#!/bin/bash

echo "==================================================="
echo "        LOANER MACHINE SOFT RESET UTILITY"
echo "==================================================="
echo
echo "This script will:"
echo " 1. Clear Downloads, Documents, and Desktop folders"
echo " 2. Clear browser data (Chrome, Safari, Firefox)"
echo " 3. Sign out of Microsoft 365 applications"
echo " 4. Remove saved credentials"
echo
echo "Press Ctrl+C to cancel or Enter to continue..."
read -r

# Create log file
LOGFILE="/tmp/reset_log_$(date +%Y%m%d_%H%M%S).txt"
echo "Starting reset process at $(date)" > "$LOGFILE"

echo
echo "[*] Clearing user folders..."

# Clear common user folders
FOLDERS=("Downloads" "Desktop" "Documents" "Library/Caches")
for folder in "${FOLDERS[@]}"; do
    echo "  - Clearing $folder folder..."
    if [ -d "$HOME/$folder" ]; then
        rm -rf "$HOME/$folder/"* >> "$LOGFILE" 2>&1
        echo "    Done."
    else
        echo "    Folder not found, skipping."
    fi
done

echo
echo "[*] Clearing browser data..."

# Clear Chrome data
echo "  - Clearing Google Chrome data..."
killall "Google Chrome" 2>/dev/null
if [ -d "$HOME/Library/Application Support/Google/Chrome" ]; then
    rm -rf "$HOME/Library/Application Support/Google/Chrome/Default/Cache"* >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Application Support/Google/Chrome/Default/Cookies"* >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Application Support/Google/Chrome/Default/History"* >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Application Support/Google/Chrome/Default/Login Data"* >> "$LOGFILE" 2>&1
    echo "    Done."
else
    echo "    Chrome not installed, skipping."
fi

# Clear Safari data
echo "  - Clearing Safari data..."
killall "Safari" 2>/dev/null
if [ -d "$HOME/Library/Safari" ]; then
    rm -rf "$HOME/Library/Safari/History"* >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Safari/Downloads.plist" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Safari/LastSession.plist" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Safari/Databases" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Safari/LocalStorage" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Caches/com.apple.Safari" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Caches/com.apple.Safari.SafeBrowsing" >> "$LOGFILE" 2>&1
    defaults write com.apple.Safari HistoryAgeInDaysLimit 0 >> "$LOGFILE" 2>&1
    defaults write com.apple.Safari DownloadsClearingPolicy 1 >> "$LOGFILE" 2>&1
    echo "    Done."
else
    echo "    Safari not configured, skipping."
fi

# Clear Firefox data
echo "  - Clearing Firefox data..."
killall "firefox" 2>/dev/null
if [ -d "$HOME/Library/Application Support/Firefox/Profiles" ]; then
    find "$HOME/Library/Application Support/Firefox/Profiles" -name "cache" -type d -exec rm -rf {} \; 2>/dev/null
    find "$HOME/Library/Application Support/Firefox/Profiles" -name "cookies.sqlite" -type f -exec rm -f {} \; 2>/dev/null
    find "$HOME/Library/Application Support/Firefox/Profiles" -name "places.sqlite" -type f -exec rm -f {} \; 2>/dev/null
    echo "    Done."
else
    echo "    Firefox not installed, skipping."
fi

echo
echo "[*] Signing out of Microsoft 365 applications..."

# Kill Microsoft applications first
killall "Microsoft Outlook" 2>/dev/null
killall "Microsoft Word" 2>/dev/null
killall "Microsoft Excel" 2>/dev/null
killall "Microsoft PowerPoint" 2>/dev/null
killall "Microsoft OneNote" 2>/dev/null
killall "Microsoft Teams" 2>/dev/null

# Clear Office credentials
echo "  - Removing Office credentials..."
if [ -d "$HOME/Library/Group Containers/UBF8T346G9.Office" ]; then
    rm -rf "$HOME/Library/Group Containers/UBF8T346G9.Office/MicrosoftRegistrationDB.reg" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Group Containers/UBF8T346G9.Office/Licensing" >> "$LOGFILE" 2>&1
    echo "    Done."
else
    echo "    Office not installed, skipping."
fi

echo
echo "[*] Removing saved credentials..."

# Clear keychain entries for common services
echo "  - Clearing keychain items for common services..."
security delete-generic-password -l "Microsoft Office" all 2>/dev/null
security delete-generic-password -l "Microsoft_Office_Identities_Cache" all 2>/dev/null
security delete-generic-password -l "Microsoft_Office_Tickets_Cache" all 2>/dev/null
security delete-generic-password -l "Chrome" all 2>/dev/null
security delete-generic-password -l "Chrome Safe Storage" all 2>/dev/null
echo "    Done."

echo
echo "[*] Removing OneDrive cached data..."
killall "OneDrive" 2>/dev/null
if [ -d "$HOME/Library/Application Support/OneDrive" ]; then
    rm -rf "$HOME/Library/Application Support/OneDrive/settings" >> "$LOGFILE" 2>&1
    echo "    Done."
else
    echo "    OneDrive not configured, skipping."
fi

echo
echo "[*] Removing Teams cached data..."
if [ -d "$HOME/Library/Application Support/Microsoft/Teams" ]; then
    rm -rf "$HOME/Library/Application Support/Microsoft/Teams/Cache" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Application Support/Microsoft/Teams/blob_storage" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Application Support/Microsoft/Teams/databases" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Application Support/Microsoft/Teams/Local Storage" >> "$LOGFILE" 2>&1
    rm -rf "$HOME/Library/Application Support/Microsoft/Teams/tmp" >> "$LOGFILE" 2>&1
    echo "    Done."
else
    echo "    Teams not installed, skipping."
fi

echo
echo "==================================================="
echo "        SOFT RESET COMPLETED SUCCESSFULLY"
echo "==================================================="
echo
echo "Log file created at: $LOGFILE"
echo
echo "The machine is now ready for the next user."
echo "Please restart the computer before handing it over."
echo
echo "Press Enter to exit..."
read -r
