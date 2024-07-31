@echo off
setlocal

:: Check for administrative privileges
>nul 2>&1 "%SystemRoot%\system32\cacls.exe" "%SystemRoot%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto Elevate
) else (
    goto Start
)

:Elevate
:: Create a new batch file with the necessary commands to run with elevated privileges
set "batchPath=%temp%\tempElevate.bat"
echo @echo off > "%batchPath%"
echo setlocal >> "%batchPath%"
echo set scriptDir=%%~dp0 >> "%batchPath%"
echo cd /d %%scriptDir%% >> "%batchPath%"
echo for %%f in (*.ps1) do ( >> "%batchPath%"
echo    echo Running PowerShell script %%f >> "%batchPath%"
echo    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%%f" >> "%batchPath%"
echo ) >> "%batchPath%"
echo pause >> "%batchPath%"
echo endlocal >> "%batchPath%"

:: Run the temporary batch file with elevated privileges
PowerShell -Command "Start-Process cmd -ArgumentList '/c \"%batchPath%\"' -Verb RunAs"
exit

:Start
:: Normal script execution
set scriptDir=%~dp0
cd /d %scriptDir%

for %%f in (*.ps1) do (
    echo Running PowerShell script %%f
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%%f"
)

pause
endlocal
