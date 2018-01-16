[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$Command
)

$databasePath = "C:\Danu\test5.db"

$AzContext = Get-AzureRmContext
$dateNow = Get-Date
$query = "INSERT INTO Termination (Account, Tenant, Subscription, ResourceGroup, Resource, Command, TerminatedOn)
          VALUES (@account , @tenantId, @subscriptionName, @resourceGrpName, @resourceName, @command, @tDate)"

Invoke-SqliteQuery -DataSource $databasePath -Query $query -SqlParameters @{
    account = $AzContext.Account.Id
    tenantId = $AzContext.Tenant.Id
    subscriptionName = $AzContext.Subscription.Name
    resourceGrpName = $ResourceGroupName
    resourceName =  $ResourceName
    command = $Command
    tDate = $dateNow
}