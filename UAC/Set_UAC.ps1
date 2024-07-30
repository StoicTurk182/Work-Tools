	# Set the Inactivity(Lock Computer) timeout time if it already isn't set.
	# Can be set regardless if the -Force parameter is used.

	Set-ExecutionPolicy RemomteSigned
	
# Check if the script is running as an Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Error "Please run this script as an Administrator."
    exit
}

try {
    # Set UAC to "Always Notify"
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $registryName = "ConsentPromptBehaviorAdmin"
    $registryValue = 1
    Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue
    Write-Host "UAC is set to 'Always Notify'."

    # Set screen lock timeout to 5 minutes
    $timeout = 300 # 5 minutes in seconds
    powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOIDLE $timeout
    powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOIDLE $timeout
    powercfg.exe /S SCHEME_CURRENT
    Write-Host "Screen lock timeout is set to 5 minutes."
}
catch {
    Write-Error "An error occurred: $_"
}
