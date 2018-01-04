[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
    [string]$SubscriptionId,

    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
    [string]$TenantId,

    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
    [string]$ResourceName
)

#Import the Azure Module
Import-Module AzureRM.profile

# Ask for Azure Login.
#Login-AzureRmAccount

Write-Verbose "Login Successfull"

#Get all the active subscriptions for the login.
IF([string]::IsNullOrWhiteSpace($SubscriptionId)) {
    $ActiveSubscriptions = Get-AzureRMSubscription | Where-Object {$_.State -eq 'Enabled'}
    Write-Verbose $"Active subscriptions queried: $ActiveSubscriptions"

    #Ask the user to select the subscription.
    $SelectedSubscription = $ActiveSubscriptions | Select-Object -Property Name, Id, TenantId, Status |  Out-GridView  -Title "Select the subscription " -PassThru
    Write-Verbose $"Selected Subscription: $SelectedSubscription"
}
else {
    Write-Verbose "Getting the Subscription from input parameters"
    $ActiveSubscriptions = Get-AzureRMSubscription -SubscriptionId $SubscriptionId -TenantId $TenantId
    $SelectedSubscription = $ActiveSubscriptions
}

#Set the context to the selected resource group.
Write-Verbose "Setting the RM Context to the selected subscription"
Set-AzureRmContext -SubscriptionName $SelectedSubscription.Name

IF([string]::IsNullOrWhiteSpace($ResourceGroupName)) {
    #Get all the Resource groups in the subscription. 
    $SelectedRG = Get-AzureRmResourceGroup | Select-Object -Property ResourceGroupName, Location, ProvisioningState, ResourceId | Out-GridView -Title "Select the Resource Group " -PassThru
    Write-Verbose $"Selected ResourceGroup: $SelectedRG"
}
else {
    Write-Verbose "Getting the Resource Group from input parameters"
    $SelectedRG = Get-AzureRmResourceGroup -Name $ResourceGroupName
}

#Print the selected resource group.
$selectedRG

#Get all the resouece in the selected resource group.
IF([string]::IsNullOrWhiteSpace($ResourceName)) {
    $selectedResource = Find-AzureRmResource -ResourceGroupNameEquals $selectedRG.ResourceGroupName | Select-Object -Property ResourceName, ResourceType, Kind, Location | Out-GridView -Title "Select the resource " -PassThru
    Write-Verbose $"Selected Resource: $SelectedResource"
}
else {
    Write-Verbose "Getting the Resource Group from input parameters"
    $selectedResource = Find-AzureRmResource -ResourceGroupNameEquals $selectedRG.ResourceGroupName -ResourceNameEquals $ResourceName
}
#print the selected resource.
$selectedResource