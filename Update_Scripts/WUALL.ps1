Set-ExecutionPolicy bypass -Scope process
Install-Module -Name PSWindowsUpdate -AllowClobber -Force

Import-Module PSWindowsUpdate

# Get updates (including optional)
Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot
