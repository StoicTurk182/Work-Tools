@echo off
setlocal enabledelayedexpansion

REM Temporary file to store installed applications
set "appsFile=%temp%\installed_apps.txt"
set "selectionFile=%temp%\selected_app.txt"

REM List installed applications with their product codes
echo Generating list of installed applications...
wmic product get name,identifyingnumber /format:csv > "%appsFile%"

REM Display the list of installed applications
echo Available applications for uninstallation:
type "%appsFile%"

REM Prompt user to enter the product code of the application to uninstall
echo.
set /p productCode="Enter the product code of the application to uninstall (from the list above): "

REM Validate input
if "%productCode%"=="" (
    echo No product code entered!
    exit /b 1
)

REM Check if the selected product code is in the list
findstr /i "%productCode%" "%appsFile%" > "%selectionFile%"

REM If no match is found, exit
if not exist "%selectionFile%" (
    echo The provided product code was not found in the list!
    del "%appsFile%"
    exit /b 1
)

REM Perform the uninstallation
echo Uninstalling the selected application with product code %productCode%...
msiexec /x %productCode% /qn

REM Check for errors
if !errorlevel! neq 0 (
    echo Failed to uninstall the application with product code %productCode%
) else (
    echo Successfully uninstalled the application with product code %productCode%
)

REM Clean up temporary files
del "%appsFile%"
del "%selectionFile%"

echo Uninstallation process completed.
pause
