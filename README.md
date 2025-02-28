# Loaner Reset Scripts

This repository contains scripts designed to reset loaner devices (Windows and macOS) to a clean state. These scripts are intended to be used by IT administrators or technicians to quickly prepare devices for the next user.

## Scripts Included

*   `loaner_reset_mac.sh`:  A shell script for macOS.
*   `loaner_reset_win.bat`: A batch script for Windows.
*   `loaner-reset-win-ps.ps1`: A PowerShell script for Windows (alternative to the batch script).

## Purpose

These scripts automate the process of:

*   Removing user accounts
*   Deleting user data
*   Clearing temporary files
*   Resetting system settings (where applicable and safe)


## Usage

### macOS (`loaner_reset_mac.sh`)

1.  **Download:** Download the `loaner_reset_mac.sh` file to the macOS device.
2.  **Make Executable:** Open Terminal and navigate to the directory where you downloaded the script.  Make the script executable by running:

    ```
    chmod +x loaner_reset_mac.sh
    ```
3.  **Run as Administrator:** Execute the script with administrator privileges using `sudo`:

    ```
    sudo ./loaner_reset_mac.sh
    ```
4.  **Follow On-Screen Instructions:** The script will guide you through the reset process.

### Windows (Batch Script - `loaner_reset_win.bat`)

1.  **Download:** Download the `loaner_reset_win.bat` file to the Windows device.
2.  **Run as Administrator:** Right-click the `loaner_reset_win.bat` file and select "Run as administrator".
3.  **Follow On-Screen Instructions:** The script will execute the commands to reset the device.

### Windows (PowerShell Script - `loaner-reset-win-ps.ps1`)

1.  **Download:** Download the `loaner-reset-win-ps.ps1` file to the Windows device.
2.  **Set Execution Policy (if needed):**  PowerShell's execution policy might prevent running scripts.  You may need to temporarily bypass the execution policy.  **Important:** Understand the implications of changing the execution policy.  A common approach is to bypass it for a single script execution:

    ```
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
    ```

    You may need to run PowerShell as an administrator to do this.  To run as administrator, search for "PowerShell", right click, and "Run as administrator."
3.  **Run as Administrator:** Open PowerShell as an administrator and navigate to the directory where you downloaded the script.  Then, execute the script:

    ```
    .\loaner-reset-win-ps.ps1
    ```

    Or, if the above doesn't work

    ```
    powershell.exe -ExecutionPolicy ByPass -File ".\loaner-reset-win-ps.ps1"
    ```
4.  **Follow On-Screen Instructions:** The script will guide you through the reset process.
5.  **Restore Execution Policy (Optional):** After running the script, you may want to revert the execution policy to its original setting for security reasons.


## Contributing

Contributions to this project are welcome!  Feel free to submit pull requests with bug fixes, improvements, or new features.

