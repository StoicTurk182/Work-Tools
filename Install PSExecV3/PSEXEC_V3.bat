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
echo 5. Transfer files
echo 6. Create directory in C:\
echo 7. Exit
echo ==============================================
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto sfc
if "%choice%"=="2" goto ipconfig
if "%choice%"=="3" goto restart
if "%choice%"=="4" goto deletefile
if "%choice%"=="5" goto transferfiles
if "%choice%"=="6" goto createdir
if "%choice%"=="7" goto exit
goto menu

:get_credentials
set /p username="Enter username: "
set /p password="Enter password: "

:get_ips
set /p ips="Enter target IP addresses or hostnames (comma separated): "
for %%a in (%ips%) do (
    echo Running on %%a
    set "ip_list=%%a"
)

:sfc
call :get_credentials
call :get_ips
for %%a in (%ips%) do (
    psexec \\%%a -u %username% -p %password% cmd /c "sfc /scannow"
)
pause
goto menu

:ipconfig
call :get_credentials
call :get_ips
for %%a in (%ips%) do (
    psexec \\%%a -u %username% -p %password% ipconfig /all
)
pause
goto menu

:restart
call :get_credentials
call :get_ips
for %%a in (%ips%) do (
    psexec \\%%a -u %username% -p %password% shutdown /r /t 0
)
pause
goto menu

:deletefile
call :get_credentials
call :get_ips
set /p filepath="Enter the full path of the file to delete: "
for %%a in (%ips%) do (
    psexec \\%%a -u %username% -p %password% cmd /c "del /f /q %filepath%"
)
pause
goto menu

:transferfiles
call :get_credentials
call :get_ips
set /p sourcedir="Enter the full path of the source directory: "
set /p destdir="Enter the full path of the destination directory on the remote system: "
for %%a in (%ips%) do (
    robocopy %sourcedir% \\%%a\%destdir% /E /Z /R:2 /W:5
    echo Files transferred to %%a
)
pause
goto menu

:createdir
call :get_credentials
call :get_ips
set /p foldername="Enter the folder name to create in C:\: "
for %%a in (%ips%) do (
    psexec \\%%a -u %username% -p %password% cmd /c "mkdir C:\%foldername%"
    echo Created folder C:\%foldername% on %%a
)
pause
goto menu

:exit
exit
