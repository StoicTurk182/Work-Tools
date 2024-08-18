# Define the path for the XML file
$xmlFilePath = "C:\Users\Orion\Desktop\Bat_Credential\encrypted_credentials.xml"

# Import the XML file to get the credentials object
$credential = Import-CliXml -Path $xmlFilePath

# Use the credentials (example)
Write-Host "Username: $($credential.UserName)"
