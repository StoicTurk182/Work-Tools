@echo off
:: Elevate PowerShell and run another command

:: Start an elevated PowerShell session
powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command ""Start-Sleep -Seconds 1; irm https://christitus.com/win | iex""'"

:: Pause to keep the command prompt open after execution
pause
