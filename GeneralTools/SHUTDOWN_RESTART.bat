@echo off
echo Choose an option:
echo 1. Shut down
echo 2. Restart
echo 3. Abort shutdown/restart
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto shutdown
if "%choice%"=="2" goto restart
if "%choice%"=="3" goto abort
echo Invalid choice.
goto end

:shutdown
set /p force="Force close applications? (y/n): "
if /i "%force%"=="y" set force_option=/f
set /p delay="Enter delay in seconds (default is 30): "
if "%delay%"=="" set delay=30
shutdown /s %force_option% /t %delay%
echo Shutting down in %delay% seconds...
goto end

:restart
set /p force="Force close applications? (y/n): "
if /i "%force%"=="y" set force_option=/f
set /p delay="Enter delay in seconds (default is 30): "
if "%delay%"=="" set delay=30
shutdown /r %force_option% /t %delay%
echo Restarting in %delay% seconds...
goto end

:abort
shutdown /a
echo Shutdown/restart aborted.
goto end

:end
pause
