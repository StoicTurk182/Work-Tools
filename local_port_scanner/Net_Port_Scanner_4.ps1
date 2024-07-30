# Set execution policy for the current process
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Pause for 2 seconds
Start-Sleep -Seconds 2

# Get the directory of the currently executing script
$scriptDirectory = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Get the PC/host name
$hostName = $env:COMPUTERNAME

# Define the output file path using the host name
$outputFilePath = Join-Path -Path $scriptDirectory -ChildPath "${hostName}_output.txt"

# Output diagnostic information
Write-Host "Script Directory: $scriptDirectory"
Write-Host "Output File Path: $outputFilePath"

# Capture NetTCPConnection data with specified conditions
$netTCPConnections = Get-NetTCPConnection -AppliedSetting Internet | ForEach-Object {
    $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        LocalAddress  = $_.LocalAddress
        LocalPort     = $_.LocalPort
        RemoteAddress = $_.RemoteAddress
        RemotePort    = $_.RemotePort
        State         = $_.State
        ProcessName   = if ($process) { $process.Name } else { "N/A" }
    }
} | Where-Object RemoteAddress -notLike '127.0.0.1' | Sort-Object RemoteAddress

# Prompt the user for their choice
$choice = Read-Host "Choose an option: (1) Create file, (2) View in console, (3) Both"

# Perform actions based on user choice
switch ($choice) {
    "1" {
        $netTCPConnections | Format-Table -AutoSize | Out-File -FilePath $outputFilePath
        Write-Host "Output written to $outputFilePath"
    }
    "2" {
        $netTCPConnections | Format-Table -AutoSize
    }
    "3" {
        $netTCPConnections | Format-Table -AutoSize | Out-File -FilePath $outputFilePath
        Write-Host "Output written to $outputFilePath"
        $netTCPConnections | Format-Table -AutoSize
    }
    default {
        Write-Host "Invalid choice. Exiting..."
    }
}

# Prompt to exit
Read-Host "Operation complete. Press ENTER to exit..."
