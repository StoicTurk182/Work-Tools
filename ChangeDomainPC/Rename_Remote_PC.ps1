    param (
    [string]$IPAddress,          # IP address of the remote computer (optional)
    [string]$NewHostname,        # New hostname for the remote computer (optional)
    [switch]$Reboot              # Optional parameter to reboot after renaming
)

# Function to rename the remote computer
function Rename-RemoteComputerName {
    param (
        [string]$IPAddress,
        [string]$New
    )

    # Script block to run on the remote machine
    $scriptBlock = {
        param ($NewHostname)
        $CurrentHostname = (Get-ComputerInfo).CsName
        Write-Host "Current hostname on remote machine: $CurrentHostname" -ForegroundColor Cyan
        
        try {
            Rename-Computer -NewName $NewHostname -Force
            Write-Host "Hostname renamed to $NewHostname successfully." -ForegroundColor Green
        } catch {
            Write-Host "Error renaming hostname: $_" -ForegroundColor Red
        }
    }

    # Run the script block on the remote machine
    try {
        Invoke-Command -ComputerName $IPAddress -ScriptBlock $scriptBlock -ArgumentList $New
    } catch {
        Write-Host "Error connecting to remote machine: $_" -ForegroundColor Red
    }
}

# Prompt for the IP address if not provided as a parameter
if (-not $IPAddress) {
    $IPAddress = Read-Host "Please enter the IP address of the remote computer"
}

# Prompt for the new hostname if not provided as a parameter
if (-not $NewHostname) {
    $NewHostname = Read-Host "Please enter the new hostname"
}

# Ensure both IP address and new hostname are provided
if (-not $
