
# Logout
& $bitwardenCLIPath logout --session $loginResult

# Define the path to the credentials file and session file
$credentialsFile = 'C:\BW_Credentials\credentials.json'
$sessionFile = 'C:\BW_Credentials\session.txt'

# Path to Bitwarden CLI
$bitwardenCLIPath = "C:\ProgramData\chocolatey\bin\bw.exe"

# Read and parse the JSON file
$credentials = Get-Content $credentialsFile | ConvertFrom-Json

# Extract the username, encrypted password, and custom key
$username = $credentials.Username
$encryptedPassword = $credentials.Password
$key = $credentials.Key

# Decrypt the password using the custom key
$securePassword = $encryptedPassword | ConvertTo-SecureString -Key $key
$password = [System.Net.NetworkCredential]::new("", $securePassword).Password

# Log in and capture session key
$loginResult = & $bitwardenCLIPath login $username $password --raw

# Check if login was successful and capture the session key
if ($loginResult) {
    # Save the session key to a file
    $loginResult | Set-Content -Path $sessionFile
    Write-Output "Login successful. Session key has been saved to $sessionFile."
    Start-Sleep -Seconds 5

    function ShowMenu {
        Clear-Host
        Write-Host "Choose a Bitwarden CLI command:"
        Write-Host "1: List items"
        Write-Host "2: List folders"
        Write-Host "3: List collections"
        Write-Host "4: Get item details by ID"
        Write-Host "5: Get folder details by ID"
        Write-Host "6: Create an item"
        Write-Host "7: Delete an item by ID"
        Write-Host "8: Sync your vault"
        Write-Host "9: Show Bitwarden CLI Help"
        Write-Host "10: Log out"
        Write-Host "11: Exit"

        $choice = Read-Host "Enter your choice (1-11)"
        return $choice
    }

    do {
        $choice = ShowMenu

        switch ($choice) {
            1 {
                # List items
                & $bitwardenCLIPath list items --session $loginResult
            }
            2 {
                # List folders
                & $bitwardenCLIPath list folders --session $loginResult
            }
            3 {
                # List collections
                & $bitwardenCLIPath list collections --session $loginResult
            }
            4 {
                # Get item details by ID
                $itemId = Read-Host "Enter the item ID"
                & $bitwardenCLIPath get item $itemId --session $loginResult
            }
            5 {
                # Get folder details by ID
                $folderId = Read-Host "Enter the folder ID"
                & $bitwardenCLIPath get folder $folderId --session $loginResult
            }
            6 {
                # Create an item (this is a simplified example)
                $itemData = Read-Host "Enter the item data in JSON format"
                & $bitwardenCLIPath create item $itemData --session $loginResult
            }
            7 {
                # Delete an item by ID
                $itemId = Read-Host "Enter the item ID to delete"
                & $bitwardenCLIPath delete item $itemId --session $loginResult
                Write-Output "Item deleted successfully."
            }
            8 {
                # Sync your vault
                & $bitwardenCLIPath sync --session $loginResult
                Write-Output "Vault synced successfully."
            }
            9 {
                # Show Bitwarden CLI Help
                & $bitwardenCLIPath --help
            }
            10 {
                # Log out
                & $bitwardenCLIPath logout --session $loginResult
                Write-Output "Logged out successfully."
                break
            }
            11 {
                # Exit the script
                Write-Host "Exiting..."
                break
            }
            default {
                Write-Host "Invalid choice. Please choose an option from 1 to 11."
            }
        }

        Write-Host "`nPress Enter to continue..."
        [void][System.Console]::ReadLine()

    } while ($choice -ne 10 -and $choice -ne 11)

} else {
    Write-Error "Login failed. Unable to capture session key."
}

pause
