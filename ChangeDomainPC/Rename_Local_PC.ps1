param (
    [string]$NewHostname,        # New hostname for the computer
    [switch]$Reboot              # Optional parameter to reboot after renaming
)

# Function to rename the computer
function Rename-ComputerName {
    param (
        [string]$Current,
        [string]$New
    )

    # Rename the computer
    try {
        Rename-Computer -NewName $New -Force
        Write-Host "Hostname renamed from $Current to $New successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error renaming hostname: $_" -ForegroundColor Red
    }
}

# Fetch the current hostname automatically
$CurrentHostname = (Get-ComputerInfo).CsName

# Display the current hostname
Write-Host "Current hostname: $CurrentHostname" -ForegroundColor Cyan

# Prompt for the new hostname if not provided as a parameter
if (-not $NewHostname) {
    $NewHostname = Read-Host "Please enter the new hostname"
}

# Check if a new hostname was provided
if (-not $NewHostname) {
    Write-Host "Error: You must provide a new hostname." -ForegroundColor Yellow
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
