@echo off
setlocal enabledelayedexpansion
set LOG_FILE=%~dp0log.txt

:: Set progress bar variables
set PROGRESS_BAR_WIDTH=50
set PROGRESS_BAR_CHAR=#

:: Stop Windows Update and BITS services
echo [%date% %time%] Stopping Windows Update and BITS services >> %LOG_FILE%
net stop wuauserv >> %LOG_FILE% 2>&1
net stop bits >> %LOG_FILE% 2>&1
call :progress_bar 1 7 "Stopping services..."

:: Delete contents of SoftwareDistribution folder
echo [%date% %time%] Deleting contents of SoftwareDistribution folder >> %LOG_FILE%
cd /d %windir%\SoftwareDistribution
del /f /s /q *.* >> %LOG_FILE% 2>&1
call :progress_bar 2 7 "Deleting SoftwareDistribution folder..."

:: Start Windows Update and BITS services
echo [%date% %time%] Starting Windows Update and BITS services >> %LOG_FILE%
net start wuauserv >> %LOG_FILE% 2>&1
net start bits >> %LOG_FILE% 2>&1
call :progress_bar 3 7 "Starting services..."

:: Pause for review before proceeding
pause

:: Reduce System Protection (System Restore) usage to a maximum of 4GB
echo [%date% %time%] Reducing System Protection usage to 4GB >> %LOG_FILE%
for /D %%D in (C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z:) do (
    vssadmin list shadowstorage /for=%%D >nul 2>&1
    if not errorlevel 1 (
        echo [%date% %time%] Resizing shadow storage for drive %%D to 4GB >> %LOG_FILE%
        vssadmin resize shadowstorage /on=%%D /for=%%D /maxsize=4GB >> %LOG_FILE% 2>&1
    )
)
call :progress_bar 4 7 "Reducing System Protection..."

:: Delete contents of Downloads folder for all users on all drives
echo [%date% %time%] Deleting contents of Downloads folder for all users on all drives >> %LOG_FILE%
for /D %%D in (A: B: C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z:) do (
    if exist %%D\ (
        for /D %%U in (%%D\Users\*) do (
            if exist %%U\Downloads (
                echo [%date% %time%] Deleting contents of %%U\Downloads >> %LOG_FILE%
                del /F /S /Q %%U\Downloads\* >> %LOG_FILE% 2>&1
            )
        )
    )
)
call :progress_bar 5 7 "Deleting Downloads folder..."

:: Run Disk Cleanup
echo [%date% %time%] Running Disk Cleanup >> %LOG_FILE%
cleanmgr /sagerun:1 >> %LOG_FILE% 2>&1
call :progress_bar 6 7 "Running Disk Cleanup..."

:: Pause for review after completion
pause

:: Progress bar function
:progress_bar
set /a PROGRESS_BAR_PERCENT=%1*100/%2
set PROGRESS_BAR_FILLED=
set /a PROGRESS_BAR_EMPTY=%PROGRESS_BAR_WIDTH%-%PROGRESS_BAR_PERCENT%
for /l %%i in (1,1,%PROGRESS_BAR_PERCENT%) do set PROGRESS_BAR_FILLED=!PROGRESS_BAR_FILLED!%PROGRESS_BAR_CHAR%
for /l %%i in (1,1,%PROGRESS_BAR_EMPTY%) do set PROGRESS_BAR_FILLED=!PROGRESS_BAR_FILLED! 
echo [!PROGRESS_BAR_FILLED!] %3
goto :eof