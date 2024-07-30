Set-ExecutionPolicy -Scope Process Bypass

Start-Sleep -Seconds 2 

# Define the URL for Chrome's installer
$chromeInstallerUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$installerPath = "$env:temp\chrome_installer.exe"

# Download the Chrome installer
Invoke-WebRequest -Uri $chromeInstallerUrl -OutFile $installerPath

# Install Chrome silently
Start-Process -FilePath $installerPath -ArgumentList "/silent /install" -Wait

Start-Sleep -Seconds 1 

# Remove the installer after installation
Remove-Item -Path $installerPath

Start-Sleep -Seconds 1 

# Define the URL for Chrome Remote Desktop Host
$crdHostUrl = "https://dl.google.com/dl/edgedl/chrome-remote-desktop/chromeremotedesktophost.msi"
$crdInstallerPath = "$env:temp\chrome_remote_desktop_host.msi"

# Download the Chrome Remote Desktop Host installer
Invoke-WebRequest -Uri $crdHostUrl -OutFile $crdInstallerPath

Start-Sleep -Seconds 2 

# Install Chrome Remote Desktop Host silently
Start-Process -FilePath $crdInstallerPath -ArgumentList "/quiet" -Wait

Start-Sleep -Seconds 2 

# Remove the installer after installation
Remove-Item -Path $crdInstallerPath

Write-Output "Chrome and Chrome Remote Desktop Host have been installed. Further configuration is needed through the Chrome Remote Desktop web interface."


