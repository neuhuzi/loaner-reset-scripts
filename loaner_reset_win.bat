@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo        LOANER MACHINE SOFT RESET UTILITY
echo ===================================================
echo.
echo This script will:
echo  1. Clear Downloads, Documents, and Desktop folders
echo  2. Clear browser data (Chrome, Firefox, Edge)
echo  3. Sign out of Microsoft 365 applications
echo  4. Remove saved credentials
echo  5. Remove Chrome profiles
echo  6. Sign out of Adobe applications
echo.
echo Press CTRL+C to cancel or any key to continue...
pause > nul

:: Create log file
set LOGFILE=%TEMP%\reset_log_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt
set LOGFILE=%LOGFILE: =0%
echo Starting reset process at %date% %time% > %LOGFILE%

echo.
echo [*] Clearing user folders...

:: Clear common user folders
set FOLDERS=Downloads Desktop Documents "AppData\Local\Temp"
for %%F in (%FOLDERS%) do (
    echo   - Clearing %%F folder...
    if exist "%USERPROFILE%\%%~F" (
        del /q /f /s "%USERPROFILE%\%%~F\*" >> %LOGFILE% 2>&1
        echo     Done.
    ) else (
        echo     Folder not found, skipping.
    )
)

echo.
echo [*] Clearing browser data...

:: Clear Chrome data
echo   - Clearing Google Chrome data...
taskkill /F /IM chrome.exe >> %LOGFILE% 2>&1
if exist "%LOCALAPPDATA%\Google\Chrome\User Data" (
    echo     Removing Chrome profiles and data...
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data" >> %LOGFILE% 2>&1
    echo     Done.
) else (
    echo     Chrome not installed, skipping.
)

:: Clear Edge data
echo   - Clearing Microsoft Edge data...
taskkill /F /IM msedge.exe >> %LOGFILE% 2>&1
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" >> %LOGFILE% 2>&1
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cookies" >> %LOGFILE% 2>&1
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\History" >> %LOGFILE% 2>&1
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Login Data" >> %LOGFILE% 2>&1
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Web Data" >> %LOGFILE% 2>&1
    echo     Done.
) else (
    echo     Edge not installed, skipping.
)

:: Clear Firefox data
echo   - Clearing Firefox data...
taskkill /F /IM firefox.exe >> %LOGFILE% 2>&1
if exist "%APPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%D in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do (
        rmdir /s /q "%%D\cache" >> %LOGFILE% 2>&1
        rmdir /s /q "%%D\cookies.sqlite" >> %LOGFILE% 2>&1
        rmdir /s /q "%%D\places.sqlite" >> %LOGFILE% 2>&1
    )
    echo     Done.
) else (
    echo     Firefox not installed, skipping.
)

echo.
echo [*] Signing out of Microsoft 365 applications...

:: Sign out of Microsoft Office applications
echo   - Removing Office credentials...
taskkill /F /IM OUTLOOK.EXE >> %LOGFILE% 2>&1
taskkill /F /IM WINWORD.EXE >> %LOGFILE% 2>&1
taskkill /F /IM EXCEL.EXE >> %LOGFILE% 2>&1
taskkill /F /IM POWERPNT.EXE >> %LOGFILE% 2>&1
taskkill /F /IM ONENOTE.EXE >> %LOGFILE% 2>&1
taskkill /F /IM MSTEAMS.EXE >> %LOGFILE% 2>&1

:: Clear Office credentials
reg delete "HKCU\Software\Microsoft\Office\16.0\Common\Identity" /f >> %LOGFILE% 2>&1
echo     Done.

echo.
echo [*] Removing saved credentials...

:: Clear Credential Manager saved passwords
echo   - Clearing Windows Credential Manager...
cmdkey /list > "%TEMP%\credslist.txt"
for /F "tokens=1,2 delims= " %%G in ('%SYSTEMROOT%\System32\findstr.exe /I /C:"Target:" "%TEMP%\credslist.txt"') do (
  if "%%~H" NEQ "" cmdkey /delete:%%H >> %LOGFILE% 2>&1
)
del "%TEMP%\credslist.txt" >> %LOGFILE% 2>&1
echo     Done.

echo.
echo [*] Removing OneDrive cached data...
taskkill /F /IM OneDrive.exe >> %LOGFILE% 2>&1
if exist "%USERPROFILE%\OneDrive" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\OneDrive\settings" >> %LOGFILE% 2>&1
    echo     Done.
) else (
    echo     OneDrive not configured, skipping.
)

echo.
echo [*] Removing Teams cached data...
if exist "%APPDATA%\Microsoft\Teams" (
    rmdir /s /q "%APPDATA%\Microsoft\Teams\Cache" >> %LOGFILE% 2>&1
    rmdir /s /q "%APPDATA%\Microsoft\Teams\blob_storage" >> %LOGFILE% 2>&1
    rmdir /s /q "%APPDATA%\Microsoft\Teams\databases" >> %LOGFILE% 2>&1
    rmdir /s /q "%APPDATA%\Microsoft\Teams\Local Storage" >> %LOGFILE% 2>&1
    rmdir /s /q "%APPDATA%\Microsoft\Teams\tmp" >> %LOGFILE% 2>&1
    echo     Done.
) else (
    echo     Teams not installed, skipping.
)

echo.
echo [*] Signing out of Adobe applications...
:: Kill Adobe applications
taskkill /F /IM "Adobe Creative Cloud.exe" >> %LOGFILE% 2>&1
taskkill /F /IM "Photoshop.exe" >> %LOGFILE% 2>&1
taskkill /F /IM "Illustrator.exe" >> %LOGFILE% 2>&1
taskkill /F /IM "InDesign.exe" >> %LOGFILE% 2>&1
taskkill /F /IM "Acrobat.exe" >> %LOGFILE% 2>&1

:: Clear Adobe application data
echo   - Removing Adobe credentials and cache...
if exist "%APPDATA%\Adobe" (
    rmdir /s /q "%APPDATA%\Adobe\Common\Media Cache Files" >> %LOGFILE% 2>&1
    rmdir /s /q "%APPDATA%\Adobe\Common\Media Cache" >> %LOGFILE% 2>&1
    rmdir /s /q "%APPDATA%\Adobe\Adobe PCD" >> %LOGFILE% 2>&1
    rmdir /s /q "%APPDATA%\Adobe\CoreSync" >> %LOGFILE% 2>&1
    reg delete "HKCU\Software\Adobe" /f >> %LOGFILE% 2>&1
    echo     Done.
) else (
    echo     Adobe applications not installed, skipping.
)

echo.
echo ===================================================
echo        SOFT RESET COMPLETED SUCCESSFULLY
echo ===================================================
echo.
echo Log file created at: %LOGFILE%
echo.
echo The machine is now ready for the next user.
echo Please restart the computer before handing it over.
echo.
echo Press any key to exit...
pause > nul
