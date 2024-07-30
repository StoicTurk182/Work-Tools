@echo off
rem Get the directory of the script
set scriptDir=%~dp0

rem Path to PsExec executable
set psexecPath=%scriptDir%PsExec.exe
set psexecPath=%scriptDir%PsExec64.exe

rem Credentials
set username=""
set password=""
set command=cmd.exe

rem List of remote computers
set remoteComputers=  "hostname"

for %%i in (%remoteComputers%) do (
    echo Executing command on %%i
    %psexecPath% \\%%i -u %username% -p %password% -n 5 -s %command%
    if %errorlevel%==0 (
        echo Command executed successfully on %%i
    ) else (
        echo Command execution failed on %%i with exit code %errorlevel%
    )
)
pause
