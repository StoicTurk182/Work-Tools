# Get the directory of the script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Path to PsExec executable
$psexecPath = Join-Path -Path $scriptDir -ChildPath "PsExec.exe"

# Remote computer details
$remoteComputers = @("RemotePC1", "RemotePC2", "RemotePC3") # Add as many as needed

# Credentials
$username = "yourUsername"
$password = "yourPassword"
$secPassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $secPassword)

# Command to run on remote computers
$command = "cmd.exe"

# Loop through each remote computer and execute the command
foreach ($computer in $remoteComputers) {
    $process = Start-Process -FilePath $psexecPath -ArgumentList "\\$computer -u $username -p $password -n 5 -s $command" -Wait -NoNewWindow -PassThru
    if ($process.ExitCode -eq 0) {
        Write-Output "Command executed successfully on $computer"
    } else {
        Write-Output "Command execution failed on $computer with exit code $($process.ExitCode)"
    }
}
