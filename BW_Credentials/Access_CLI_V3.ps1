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

    # Wait for 30 seconds
    Start-Sleep -Seconds 5

    # Example command: List items (replace with actual command you want to run)
    & $bitwardenCLIPath list items --session $loginResult
    
    # Automatically log out
    & $bitwardenCLIPath logout --session $loginResult

    Write-Output "Logged out successfully."
} else {
    Write-Error "Login failed. Unable to capture session key."
}
