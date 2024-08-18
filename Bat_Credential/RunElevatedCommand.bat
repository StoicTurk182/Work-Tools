@echo off
setlocal

REM Determine the directory of the batch script
set "scriptDir=%~dp0"

REM Define the path to the PowerShell script and credentials file
set "psScript=%scriptDir%GetAndStoreCredentials.ps1"
set "credsFile=%scriptDir%encrypted_credentials.xml"

REM Run the PowerShell script to get and store credentials
powershell -ExecutionPolicy Bypass -File "%psScript%"

REM Check if the credentials file exists
if not exist "%credsFile%" (
    echo Error: Credentials file not found.
    exit /b 1
)

REM Retrieve the credentials using PowerShell
for /f "delims=" %%i in ('powershell -Command "Import-Clixml -Path \"%credsFile%\""') do set "creds=%%i"

REM Extract the username and password (XML parsing)
for /f "tokens=2 delims==" %%a in ('echo %creds% ^| findstr /i "UserName="') do set "username=%%a"
for /f "tokens=2 delims==" %%b in ('echo %creds% ^| findstr /i "Password="') do set "password=%%b"

REM Debugging: Uncomment the lines below to see the extracted values
REM echo Username: %username%
REM echo Password: %password%

REM Run the command with elevated privileges
echo Running command with elevated privileges...

REM Create a temporary PowerShell script to run the command with credentials
set "tempPsScript=%temp%\RunElevatedCommand.ps1"
echo $username = "%username%" > "%tempPsScript%"
echo $password = ConvertTo-SecureString "%password%" -AsPlainText -Force >> "%tempPsScript%"
echo $cred = New-Object PSCredential($username, $password) >> "%tempPsScript%"
echo Start-Process cmd.exe -ArgumentList '/c your_command_here' -Credential $cred -NoNewWindow -Wait >> "%tempPsScript%"

REM Execute the temporary PowerShell script with elevated privileges
powershell -ExecutionPolicy Bypass -File "%tempPsScript%"

REM Clean up
del "%tempPsScript%"
del "%credsFile%"

echo Done.
