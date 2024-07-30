# Set the desired execution policy
$desiredExecutionPolicy = "Bypass"

Start-sleep -seconds 5

# Get the current execution policy for the current user
$currentExecutionPolicy = Get-ExecutionPolicy -Scope Process	
# Check if the current execution policy is equal to the desired policy
if ($currentExecutionPolicy -ne $desiredExecutionPolicy) {
    # If not, set the execution policy to the desired policy
    Set-ExecutionPolicy -ExecutionPolicy $desiredExecutionPolicy -Scope Process

    # Display a warning message
    Write-Warning "The execution policy has been changed to $desiredExecutionPolicy."
}

Start-sleep -seconds 5

# Dynamically define the path to the folder containing the software packages
# Assuming the software is in a folder named 'Software' located in the same directory as this script
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$softwareFolder = Join-Path -Path $scriptPath -ChildPath "Software"

# Dynamically define the path to the log file in the script's execution directory
$logFile = Join-Path -Path $scriptPath -ChildPath "SoftwareInstallationLog.txt"

# Check if the log file exists, and create it if it doesn't
if (-not (Test-Path $logFile)) {
    New-Item -ItemType File -Path $logFile -Force
}

# Initialize an empty array to store information about finished installations
$finishedInstalls = @()

# Get the list of executable files in the software folder
$softwareFiles = Get-ChildItem -Path $softwareFolder -Filter "*.exe" -File

# Check if the software folder is empty
if ($softwareFiles.Count -eq 0) {
    # Display a warning message
    Write-Warning "The software folder is empty. No software packages will be installed."
} else {
    # Loop through each software package and install it
    foreach ($softwareFile in $softwareFiles) {
        Write-Host "Installing $($softwareFile.Name)..."

        try {
            # Start the installation process with elevated privileges and silent mode
			$installProcess = Start-Process -FilePath $softwareFile.FullName -Verb RunAs -PassThru -Wait

            # Check if the installation was successful
            if ($installProcess.ExitCode -eq 0) {
                Write-Host "Installation of $($softwareFile.Name) completed successfully."
                $logEntry = New-Object PSObject -Property @{
                    InstallationTime = Get-Date
                    SoftwareName = $softwareFile.Name
                    ExitCode = $installProcess.ExitCode
					Result = "Success"
                }
            } else {
                Write-Host "Installation of $($softwareFile.Name) failed with exit code $($installProcess.ExitCode)."
                $logEntry = New-Object PSObject -Property @{
                    InstallationTime = Get-Date
                    SoftwareName = $softwareFile.Name
                    ExitCode = $installProcess.ExitCode
					Result = "Failed"
					
                }
            }
        } catch {
            Write-Host "An error occurred during the installation of $($softwareFile.Name)."
            $logEntry = New-Object PSObject -Property @{
                InstallationTime = Get-Date
                SoftwareName = $softwareFile.Name
                ExitCode = $null
                ErrorMessage = $_.Exception.Message
            }
        } finally {
            # Append the log entry to the log file
            $logEntry | Format-Table -Property @{Name='Installation Time'; Expression={$_.InstallationTime}}, SoftwareName, ExitCode, Result -AutoSize | Out-String | Out-File -FilePath $logFile -Append

            # Clear $logEntry to avoid duplicating log entries
            $logEntry = $null
        }

        $choice = Read-Host "Do you want to continue with the next installation? (Y/N)"
        if ($choice -ne "Y" -and $choice -ne "y") {
            Write-Host "Installation process stopped."
            break
        }
    }
}