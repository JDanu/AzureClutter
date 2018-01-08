#Check and install all th prerequsites needed to run this.

SetExecutionPolicyRemoteSigned

if (Get-Module -ListAvailable -Name AzureRM) {
    Write-Verbose "AzureRM Module exists."
} else {
    Write-Host "AzureRM Module does not exist"
    Write-Verbose "AzureRM Module does not exist. About to install it."
    Install-Module AzureRM
    Write-Verbose "AzureRM Module installed successfully."
    Write-Host "AzureRM Module installed successfully."
}

if (Get-Module -ListAvailable -Name Azure) {
    Write-Verbose "Azure Module exists."
} else {
    Write-Host "Azure Module does not exist"
    Write-Verbose "Azure Module does not exist. About to install it."
    Install-Module Azure -AllowClobber
    Write-Verbose "Azure Module installed successfully."
    Write-Host "Azure Module installed successfully."
}




function SetExecutionPolicyRemoteSigned(){
    Set-ExecutionPolicy RemoteSigned
}