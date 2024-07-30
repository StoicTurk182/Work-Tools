@echo off
setlocal

:: Get the directory where the batch file is located
set "scriptDir=%~dp0"

:: Define the path to the Software folder
set "softwareDir=%scriptDir%Software"

:: Check if the Software folder exists and clear its contents
if exist "%softwareDir%" (
    echo Clearing contents of %softwareDir%
    cd /d "%softwareDir%"
    del /q * >nul 2>&1
    for /d %%d in (*) do rd /s /q "%%d" >nul 2>&1
) else (
    echo %softwareDir% does not exist.
)

pause

endlocal


