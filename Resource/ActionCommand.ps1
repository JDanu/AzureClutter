[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceAction
)

$AzContext = Get-AzureRmContext

$Command = ".\Crawler.ps1 -SubscriptionId " + $AzContext.Subscription.Id + " -TenantId " + $AzContext.Tenant.Id + " -ResourceGroupName " + $ResourceGroupName + " -ResourceName " + $ResourceName + " -ResourceAction " + $ResourceAction 

$Command