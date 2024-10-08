@echo off
:: Check for administrative rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)




@echo off
:menu
cls
echo =====================================
echo        Domain User Management
echo =====================================
echo.
echo 1. Create a Domain User
echo 2. Delete a Domain User
echo 3. Add a Domain User to a Group
echo 4. Remove a Domain User from a Group
echo 5. List All Domain Users
echo 6. Search Domain User by Name
echo 7. Change Domain User Password
echo 8. Exit
echo.
set /p choice=Enter your choice (1-8):

if %choice%==1 goto create_user
if %choice%==2 goto delete_user
if %choice%==3 goto add_to_group
if %choice%==4 goto remove_from_group
if %choice%==5 goto list_users
if %choice%==6 goto search_user
if %choice%==7 goto change_password
if %choice%==8 goto end
goto menu

:create_user
cls
echo Create a New Domain User
echo ========================
set /p username=Enter the username (domain\\username or username):
set /p password=Enter the password:
net user %username% %password% /add /domain
echo Domain user %username% created.
pause
goto menu

:delete_user
cls
echo Delete a Domain User
echo ====================
set /p username=Enter the username (domain\\username or username):
net user %username% /delete /domain
echo Domain user %username% deleted.
pause
goto menu

:add_to_group
cls
echo Add Domain User to a Group
echo ==========================
set /p username=Enter the username (domain\\username or username):
set /p groupname=Enter the group name:
net group %groupname% %username% /add /domain
echo Domain user %username% added to group %groupname%.
pause
goto menu

:remove_from_group
cls
echo Remove Domain User from a Group
echo ===============================
set /p username=Enter the username (domain\\username or username):
set /p groupname=Enter the group name:
net group %groupname% %username% /delete /domain
echo Domain user %username% removed from group %groupname%.
pause
goto menu

:list_users
cls
echo List of All Domain Users
echo ========================
net user /domain
pause
goto menu

:search_user
cls
echo Search Domain User by Name
echo ==========================
set /p username=Enter the username (domain\\username or username):
net user %username% /domain >nul 2>&1
if %errorlevel%==0 (
    echo User %username% exists.
    net user %username% /domain
) else (
    echo User %username% does not exist.
)
pause
goto menu

:change_password
cls
echo Change Domain User Password
echo ===========================
set /p username=Enter the username (domain\\username or username):
set /p password=Enter the new password:
net user %username% %password% /domain
echo Password for domain user %username% changed.
pause
goto menu

:end
exit
