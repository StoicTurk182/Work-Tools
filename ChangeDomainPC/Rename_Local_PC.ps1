# Define parameters
param (
    [string]$CurrentHostname,    # Current hostname of the computer
    [string]$NewHostname,        # New hostname for the computer
    [switch]$Reboot              # Optional parameter to reboot after renaming
)

# Function to rename the computer
function Rename-ComputerName {
    param (
        [string]$Current,
        [string]$New
    )

    # Check if the current hostname matches the provided current hostname
    $currentComputerName = (Get-ComputerInfo).CsName

    if ($currentComputerName -ne $Current) {
        Write-Host "Error: The provided current hostname does not match the actual hostname ($currentComputerName)." -ForegroundColor Red
        return
    }

    # Rename the computer
    try {
        Rename-Computer -NewName $New -Force
        Write-Host "Hostname renamed from $Current to $New successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error renaming hostname: $_" -ForegroundColor Red
    }
}

# Main script execution
if (-not $CurrentHostname -or -not $NewHostname) {
    Write-Host "Please provide both the current hostname and the new hostname." -ForegroundColor Yellow
    exit
}

# Call the rename function
Rename-ComputerName -Current $CurrentHostname -New $NewHostname

# Optionally reboot the computer if the -Reboot switch is used
if ($Reboot) {
    Write-Host "Rebooting the computer in 10 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Rename complete. No reboot initiated." -ForegroundColor Cyan
}
