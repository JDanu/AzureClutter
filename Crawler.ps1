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
    [string]$ResourceName,

    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
    [string]$ResourceAction
)

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

#Set the context to the selected subscription.
Write-Verbose "Setting the RM Context to the selected subscription"
Set-AzureRmContext -SubscriptionName $SelectedSubscription.Name
#Get-AzureSubscription
#Select-AzureSubscription -SubscriptionName $SelectedSubscription.Name

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

if($selectedResource -eq $null){
    Write-Host "No Resources selected"
}
else{
#Print the selected resource.
$selectedResource

Write-Verbose "Invoking action router to perform action on selected resource."
#Call the action route to perform actions on the selected resource.
.\ActionRouter.ps1 -ResourceGroupName $SelectedRG.ResourceGroupName -SelectedResource $selectedResource

}
