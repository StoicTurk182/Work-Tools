# Define parameters
param (
    [string]$RemoteComputer,      # Remote computer's current hostname or IP
    [string]$NewHostname,         # New hostname for the remote computer
    [switch]$Reboot,              # Optional parameter to reboot after renaming
    [string]$CredentialUser,      # Username for credential (optional)
    [string]$CredentialPass       # Password for credential (optional)
)

# Convert credentials into PSCredential object if provided
if ($CredentialUser -and $CredentialPass) {
    $SecurePassword = ConvertTo-SecureString $CredentialPass -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($CredentialUser, $SecurePassword)
} else {
    $Credential = $null
}

# Function to rename the computer
function Rename-RemoteComputer {
    param (
        [string]$Remote,
        [string]$New,
        [PSCredential]$Cred
    )

    try {
        # Rename the remote computer
        Rename-Computer -ComputerName $Remote -NewName $New -Force -Credential $Cred
        Write-Host "Hostname on $Remote renamed to $New successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error renaming hostname on ${Remote}: $_" -ForegroundColor Red
    }
}

# Function to reboot the computer
function Reboot-RemoteComputer {
    param (
        [string]$Remote,
        [PSCredential]$Cred
    )

    try {
        # Reboot the remote computer
        Restart-Computer -ComputerName $Remote -Force -Credential $Cred
        Write-Host "${Remote} is being rebooted." -ForegroundColor Yellow
    } catch {
        Write-Host "Error rebooting ${Remote}: $_" -ForegroundColor Red
    }
}

# Main script execution
if (-not $RemoteComputer -or -not $NewHostname) {
    Write-Host "Please provide both the remote computer's hostname/IP and the new hostname." -ForegroundColor Yellow
    exit
}

# Call the rename function
Rename-RemoteComputer -Remote $RemoteComputer -New $NewHostname -Cred $Credential

# Optionally reboot the remote computer if the -Reboot switch is used
if ($Reboot) {
    Write-Host "Rebooting the remote computer $RemoteComputer in 10 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Reboot-RemoteComputer -Remote $RemoteComputer -Cred $Credential
} else {
    Write-Host "Rename complete. No reboot initiated." -ForegroundColor Cyan
}
