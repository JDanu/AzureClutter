<#
    This is the starting point of this app.
    This does the following actions.
    1. Checks for the pre-requisites for running this app. (Required powershell modules)
    2. Load all the required Powershell modules.
    3. Checks for the Database and table and installs the base schema if now found.
    4. Calls the Crawler code. 
#>

Start-Transcript

#Import Azure Module
Import-Module Azure
Write-Verbose "Loaded Azure Module"

#Import the Azure RM Module
Import-Module AzureRM.profile
Write-Verbose "Loaded Azure RM Module"

#Import the SQLLite Module
Import-Module PSSQLite
Write-Verbose "Loaded PS SQLite Module"

# Ask for Azure Login
#Login-AzureRmAccount
Write-Verbose "Login Successfull"

#Checks for the database existance.
.\DbProvider.ps1

#Invokes the crawler
.\Crawler.ps1