# Create or verify existence of iplist.txt
$ipFile = "iplist.txt"
if (-not (Test-Path $ipFile)) {
    New-Item -Path $ipFile -ItemType File
}

# Function to perform nslookup
function Perform-NSLookup {
    $ipaddress = Read-Host "Enter the domain or IP for nslookup"
    if ($ipaddress) {
        Write-Host "`nPerforming nslookup for ${ipaddress}:`n" -ForegroundColor Green
        nslookup $ipaddress
        Pause
    } else {
        Write-Host "Invalid input! Please enter a valid domain or IP." -ForegroundColor Red
        Pause
    }
}

# Function to perform tracert
function Perform-Tracert {
    $ipaddress = Read-Host "Enter the domain or IP to trace the route (tracert)"
    if ($ipaddress) {
        Write-Host "`nTracing route to ${ipaddress}:`n" -ForegroundColor Green
        tracert $ipaddress
        Pause
    } else {
        Write-Host "Invalid input! Please enter a valid domain or IP." -ForegroundColor Red
        Pause
    }
}

# Function to perform ping
function Perform-Ping {
    $ipaddress = Read-Host "Enter the domain or IP to ping"
    if ($ipaddress) {
        Write-Host "`nPinging ${ipaddress}:`n" -ForegroundColor Green
        Test-Connection -ComputerName $ipaddress -Count 4
        Pause
    } else {
        Write-Host "Invalid input! Please enter a valid domain or IP." -ForegroundColor Red
        Pause
    }
}

# Function to establish a Remote Desktop Connection
function Remote-Desktop {
    if (Test-Path $ipFile) {
        Write-Host "`nPrevious IPs:" -ForegroundColor Cyan
        Get-Content $ipFile
    }

    $ipaddress = Read-Host "Enter the IP address for Remote Desktop (Example: 0.0.0.0:3389)"
    
    if ($ipaddress) {
        Add-Content -Path $ipFile -Value $ipaddress
        Write-Host "`nConnecting to ${ipaddress}...`n" -ForegroundColor Green
        Start-Process "mstsc" -ArgumentList "/v:$ipaddress"
    } else {
        Write-Host "Invalid input! Please enter a valid IP address." -ForegroundColor Red
    }
    
    Pause
}

# Main Menu Function
function Show-Menu {
    Clear-Host
    Write-Host "========================================"
    Write-Host "       Batch Script Utility Menu"
    Write-Host "========================================"
    Write-Host "1. Perform NSLookup"
    Write-Host "2. Remote Desktop Connection (MSTSC)"
    Write-Host "3. Trace Route (tracert)"
    Write-Host "4. Ping a Domain or IP"
    Write-Host "5. Exit"
    Write-Host "========================================"
    $option = Read-Host "Please choose an option (1-5)"
    
    switch ($option) {
        1 { Perform-NSLookup }
        2 { Remote-Desktop }
        3 { Perform-Tracert }
        4 { Perform-Ping }
        5 { exit }
        default {
            Write-Host "Invalid selection! Please choose a valid option." -ForegroundColor Red
            Pause
        }
    }
    Show-Menu
}

# Display the Menu
Show-Menu
