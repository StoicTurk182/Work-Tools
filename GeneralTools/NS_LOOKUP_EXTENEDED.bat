@echo off
:: Check for administrative rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:loop
:: Prompt for hostname and run nslookup
set /p hostname=Enter hostname: 
if "%hostname%"=="" goto :eof
nslookup %hostname%

:: Prompt for additional actions
set /p action=Do you want to ping this hostname? (y/n): 
if /i "%action%"=="y" ping %hostname%

set /p action=Do you want to run ipconfig? (y/n): 
if /i "%action%"=="y" ipconfig

set /p action=Do you want to exit? (y/n): 
if /i "%action%"=="y" exit

echo.
goto loop
