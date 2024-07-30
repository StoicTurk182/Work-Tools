@echo off
:: Set the path to the PowerShell script using the current drive and the script's relative path
set "scriptPath=%~dp0Install_script.ps1"

:: Start a new PowerShell process to execute the script
powershell.exe -File "%scriptPath%"
