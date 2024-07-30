# Set execution policy for the current session
Set-ExecutionPolicy -Scope Process Unrestricted -Force

# Stop Windows Update and BITS services
Stop-Service -Name wuauserv -Force
Stop-Service -Name bits -Force

# Delete contents of SoftwareDistribution folder
$softwareDistributionPath = "$env:windir\SoftwareDistribution"
Remove-Item -Path "$softwareDistributionPath\*" -Recurse -Force

# Start Windows Update and BITS services
Start-Service -Name wuauserv
Start-Service -Name bits

# Pause for review before proceeding
Read-Host -Prompt "Press Enter to continue"

# Reduce System Protection (System Restore) usage to a maximum of 4GB
$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }
foreach ($drive in $drives) {
    try {
        $shadowStorage = (vssadmin list shadowstorage /for=$drive.Root 2>&1)
        if ($shadowStorage -notmatch "No items found") {
            Write-Output "Resizing shadow storage for drive $($drive.Root) to 4GB"
            vssadmin resize shadowstorage /on=$drive.Root /for=$drive.Root /maxsize=4GB
        }
    } catch {
        Write-Output "Failed to resize shadow storage for drive $($drive.Root)"
    }
}

# Delete contents of Downloads folder for all users on all drives
foreach ($drive in $drives) {
    $userFolders = Get-ChildItem "$($drive.Root)Users" -Directory
    foreach ($userFolder in $userFolders) {
        $downloadsPath = "$($userFolder.FullName)\Downloads"
        if (Test-Path $downloadsPath) {
            Write-Output "Deleting contents of $downloadsPath"
            Remove-Item -Path "$downloadsPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# Run Disk Cleanup
Write-Output "Running Disk Cleanup"
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait

# Pause for review after completion
Read-Host -Prompt "Press Enter to exit"
