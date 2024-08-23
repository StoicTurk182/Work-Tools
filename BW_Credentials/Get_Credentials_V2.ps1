# Define a custom key
$key = (3..18).ForEach({ Get-Random -Maximum 256 })

# Encrypt the password
$password = ConvertTo-SecureString '$Tenakoutou$' -AsPlainText -Force
$encryptedPassword = $password | ConvertFrom-SecureString -Key $key

# Save the key and encrypted password (this is an example, store the key securely)
$credentials = @{
    Username = 'andrewmailbox.ajj@googlemail.com'
    Password = $encryptedPassword
    Key = $key
}

# Save the credentials to a file
$credentials | ConvertTo-Json | Set-Content 'C:\BW_Credentials\credentials.json'
