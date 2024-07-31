@echo off
setlocal enabledelayedexpansion

:main
:: List installed applications
echo List of installed applications:
set /a count=0

:: Example directory (adjust as needed)
for /f "tokens=*" %%i in ('dir /b "C:\Program Files"') do (
    set /a count+=1
    set "app[!count!]=%%i"
    echo !count!. %%i
)

:choose
:: User selection
set /p choice=Please enter the number of the application to add to startup (or type 'exit' to quit):

:: Check if user wants to exit
if /i "!choice!"=="exit" (
    echo Exiting...
    goto :eof
)

:: Validate choice
if !choice! gtr !count! (
    echo Invalid choice. Please try again.
    goto choose
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

:: Ask if the user wants to add another application
set /p addAnother=Do you want to add another application to startup? (yes/no): 
if /i "!addAnother!"=="yes" (
    goto main
) else (
    echo Exiting...
    goto :eof
)
