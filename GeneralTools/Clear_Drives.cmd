
@echo off
:: Check for administrative rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

@echo off

:: Stop Windows Update and BITS services
net stop wuauserv
net stop bits

:: Delete contents of SoftwareDistribution folder
cd /d %windir%\SoftwareDistribution
del /f /s /q *.*

:: Start Windows Update and BITS services
net start wuauserv
net start bits

:: Pause for review before proceeding
pause

:: Reduce System Protection (System Restore) usage to a maximum of 4GB
for /D %%D in (C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z:) do (
    vssadmin list shadowstorage /for=%%D >nul 2>&1
    if not errorlevel 1 (
        echo Resizing shadow storage for drive %%D to 4GB
        vssadmin resize shadowstorage /on=%%D /for=%%D /maxsize=4GB
    )
)

:: Delete contents of Downloads folder for all users on all drives
for /D %%D in (A: B: C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: X: Y: Z:) do (
    if exist %%D\ (
        for /D %%U in (%%D\Users\*) do (
            if exist %%U\Downloads (
                echo Deleting contents of %%U\Downloads
                del /F /S /Q %%U\Downloads\*
            )
        )
    )
)

:: Run Disk Cleanup
echo Running Disk Cleanup
cleanmgr /sagerun:1

:: Pause for review after completion
pause