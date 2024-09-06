@echo off
:menu
cls
echo ==============================================
echo Remote System Command Menu
echo ==============================================
echo 1. Run sfc /scannow
echo 2. Run ipconfig /all
echo 3. Restart systems
echo 4. Delete a file
echo 5. Exit
echo ==============================================
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto sfc
if "%choice%"=="2" goto ipconfig
if "%choice%"=="3" goto restart
if "%choice%"=="4" goto deletefile
if "%choice%"=="5" goto exit
goto menu

:get_ips
set /p ips="Enter target IP addresses or hostnames (comma separated): "
for %%a in (%ips%) do (
    echo Running on %%a
    set "ip_list=%%a"
)

:sfc
call :get_ips
for %%a in (%ips%) do (
    psexec \\%%a cmd /c "sfc /scannow"
)
pause
goto menu

:ipconfig
call :get_ips
for %%a in (%ips%) do (
    psexec \\%%a ipconfig /all
)
pause
goto menu

:restart
call :get_ips
for %%a in (%ips%) do (
    psexec \\%%a shutdown /r /t 0
)
pause
goto menu

:deletefile
call :get_ips
set /p filepath="Enter the full path of the file to delete: "
for %%a in (%ips%) do (
    psexec \\%%a cmd /c "del /f /q %filepath%"
)
pause
goto menu

:exit
exit