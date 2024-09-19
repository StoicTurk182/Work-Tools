@echo off
:: Set the path to the RPD.ps1 file dynamically (assumes the script is in the same directory as the .cmd)
set scriptPath=%~dp0RPD.ps1

:: Run the RPD.ps1 PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "%scriptPath%"

pause
