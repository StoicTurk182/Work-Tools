# Define the path for the XML file
$xmlFilePath = "C:\Users\Orion\Desktop\Bat_Credential\encrypted_credentials.xml"

# Ensure the directory exists
$directory = Split-Path -Path $xmlFilePath -Parent
if (-not (Test-Path -Path $directory)) {
    New-Item -Path $directory -ItemType Directory -Force
}

# Get user credentials
$credential = Get-Credential

# Convert the credentials to XML format
$credential | Export-CliXml -Path $xmlFilePath

Write-Host "Credentials have been saved to $xmlFilePath"
