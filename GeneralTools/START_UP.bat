@echo off
setlocal enabledelayedexpansion

:: List installed applications
echo List of installed applications:
set /a count=0

:: Example directory (adjust as needed)
for /f "tokens=*" %%i in ('dir /b "C:\Program Files"') do (
    set /a count+=1
    set "app[!count!]=%%i"
    echo !count!. %%i
)

:: User selection
set /p choice=Please enter the number of the application to add to startup:

:: Validate choice
if !choice! gtr !count! (
    echo Invalid choice. Exiting...
    goto :eof
)

:: Add to Startup
set "selectedApp=!app[%choice%]!"
set "shortcutName=%selectedApp%"

:: Set path to startup folder
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Create a shortcut
echo Creating shortcut for %selectedApp% in Startup folder...
powershell.exe -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%startupFolder%\%shortcutName%.lnk');$s.TargetPath='C:\Program Files\%selectedApp%\%selectedApp%.exe';$s.Save()"

echo %selectedApp% has been added to startup.
pause
