# Allow script execution temporarily for this session
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install the PSWindowsUpdate module, allowing it to overwrite any existing module
Install-Module -Name PSWindowsUpdate -AllowClobber -Force -Scope CurrentUser

# Import the PSWindowsUpdate module into the current session
Import-Module PSWindowsUpdate

# Get and install Windows updates (including optional updates), accepting all updates and ignoring reboot prompts
Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot
