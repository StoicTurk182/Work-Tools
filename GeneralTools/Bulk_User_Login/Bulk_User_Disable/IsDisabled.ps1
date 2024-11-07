# Path to the file containing the usernames
$userListPath = "C:\Users\andrew.jones\Desktop\Bulk_User_Login\Bulk_User_Disable\UserList.txt"

# Check if the file exists
if (Test-Path -Path $userListPath) {
    # Import usernames from file
    $usernames = Get-Content -Path $userListPath
    
    # Loop through each username and check if the account is disabled
    foreach ($username in $usernames) {
        $user = Get-ADUser -Identity $username -Properties Enabled -ErrorAction SilentlyContinue
        
        if ($user) {
            $status = if ($user.Enabled -eq $false) { "Disabled" } else { "Enabled" }
            Write-Output "$username is $status."
        }
        else {
            Write-Output "$username not found in AD."
        }
    }
} else {
    Write-Output "User list file not found at path: $userListPath"
}

#Pause Script to Exit
read-host -prompt "Press Enter to Exit"