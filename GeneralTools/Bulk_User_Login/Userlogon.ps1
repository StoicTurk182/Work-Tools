Set-ExecutionPolicy -Scope process Unrestricted

# Import CSV file
$users = Import-Csv -Path "C:\Users\andrew.jones\Desktop\Bulk_User_Login\users.txt"

# Loop through each user and get the last logon date
foreach ($user in $users) {
    $result = Get-ADUser -Identity $user.Username -Properties LastLogonDate | 
              Select-Object Name, LastLogonDate
    # Output result
    Write-Output $result
}