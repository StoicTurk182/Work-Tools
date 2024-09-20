# Define parameters
$logName = "System"
$newestCount = 5
$outputFile = "C:\temp\SystemLog.csv"  # Ensure this directory exists


Set-ExecutionPolicy -Scope Process Unrestricted


# Function to export events to CSV
function Export-EventLog {
    param (
        [string]$logName,
        [int]$newestCount,
        [string]$outputFile
    )
    
    try {
        # Get the latest events
        $events = Get-EventLog -LogName $logName -Newest $newestCount | Select-Object *
        
        # Check if there are events
        if ($events) {
            # Export events to CSV
            $events | Export-Csv -Path $outputFile -NoTypeInformation -Force
            Write-Host "Exported $newestCount events from $logName to $outputFile"
        } else {
            Write-Host "No events found in $logName log."
        }
    } catch {
        Write-Host "Error: $_"
    }
}

# Function to export full log if chosen
function Export-FullEventLog {
    param (
        [string]$logName,
        [string]$outputFile
    )
    
    try {
        # Get the full event log
        $events = Get-EventLog -LogName $logName | Select-Object *
        
        if ($events) {
            # Export full event log to CSV
            $events | Export-Csv -Path $outputFile -NoTypeInformation -Force
            Write-Host "Exported full $logName log to $outputFile"
        } else {
            Write-Host "No events found in $logName log."
        }
    } catch {
        Write-Host "Error: $_"
    }
}

# Main script
Write-Host "Do you want to download the full event log? (y/n)"
$input = Read-Host

if ($input -eq "y") {
    Export-FullEventLog -logName $logName -outputFile "C:\temp\Full_SystemLog.csv"
} else {
    Export-EventLog -logName $logName -newestCount $newestCount -outputFile $outputFile
}

Write-Host "Script completed!"
pause
