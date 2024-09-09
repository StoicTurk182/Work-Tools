@echo off
REM Define the URLs
set "url1="
set "url2="
set "url3="

REM Display menu to select URL
echo Select the URL to open:
echo 1. EPC
echo 2. HELP DESK
echo 3. PARSEC
set /p urlChoice=Enter your choice (1-3): 

REM Set the URL variable based on the user's choice
if "%urlChoice%"=="1" (
    set "selectedURL=%url1%"
) else if "%urlChoice%"=="2" (
    set "selectedURL=%url2%"
) else if "%urlChoice%"=="3" (
    set "selectedURL=%url3%"
) else (
    echo Invalid URL choice. Please run the script again and select a valid option.
    exit /b
)

REM Display menu to select browser
echo.
echo Select the browser to open the URL:
echo 1. Google Chrome
echo 2. Mozilla Firefox
echo 3. Microsoft Edge
echo 4. Default Browser
set /p browserChoice=Enter your choice (1-4): 

REM Open the URL in the selected browser
if "%browserChoice%"=="1" (
    start chrome "%selectedURL%"
) else if "%browserChoice%"=="2" (
    start firefox "%selectedURL%"
) else if "%browserChoice%"=="3" (
    start microsoft-edge:%selectedURL%
) else if "%browserChoice%"=="4" (
    start "" "%selectedURL%"
) else (
    echo Invalid browser choice. Please run the script again and select a valid option.
)

pause

