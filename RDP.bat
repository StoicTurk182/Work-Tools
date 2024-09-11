@echo off
:menu
cls
echo ========================================
echo        Batch Script Utility Menu
echo ========================================
echo 1. Perform NSLookup
echo 2. Remote Desktop Connection (MSTSC)
echo 3. Exit
echo ========================================
set /p option=Please choose an option: 

if "%option%"=="1" goto nslookup
if "%option%"=="2" goto mstsc
if "%option%"=="3" goto exit
goto menu

:nslookup
cls
set /p ipaddress=Enter the domain or IP for nslookup: 
nslookup %ipaddress%
pause
goto menu

:mstsc
cls
set /p ipaddress=Enter the IP address for Remote Desktop (Example Formate is 0.0.0.0:3389): 
if "%ipaddress%"=="" set ipaddress=
mstsc /v:%ipaddress%
pause
goto menu

:exit
exit
