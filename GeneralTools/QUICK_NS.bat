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
echo.
goto loop
