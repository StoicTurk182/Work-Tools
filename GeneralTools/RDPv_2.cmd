@echo off
set ipFile=iplist.txt
if not exist %ipFile% echo. > %ipFile%

:menu
cls
echo ========================================
echo        Batch Script Utility Menu
echo ========================================
echo 1. Perform NSLookup
echo 2. Perform Ping
echo 3. Perform Tracert
echo 4. Remote Desktop Connection (MSTSC)
echo 5. Exit
echo ========================================
set /p option=Please choose an option: 

if "%option%"=="1" goto nslookup
if "%option%"=="2" goto ping
if "%option%"=="3" goto tracert
if "%option%"=="4" goto mstsc
if "%option%"=="5" goto exit
goto menu

:nslookup
cls
set /p ipaddress=Enter the domain or IP for nslookup: 
nslookup %ipaddress%
pause
goto menu

:ping
cls
set /p ipaddress=Enter the IP address to ping: 
ping %ipaddress%
pause
goto menu

:tracert
cls
set /p ipaddress=Enter the IP address to tracert: 
tracert %ipaddress%
pause
goto menu

:mstsc
cls
echo ========================================
echo Previous IPs:
type %ipFile%
echo ========================================
set /p ipaddress=Enter the IP address for Remote Desktop (Example Formate is 0.0.0.0:3389): 
if not "%ipaddress%"=="" (
    echo %ipaddress% >> %ipFile%
)
mstsc /v:%ipaddress%
pause
goto menu

:exit
exit