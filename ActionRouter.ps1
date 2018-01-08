
[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [object]$SelectedResource
)


Write-Host $SelectedResource.ResourceName

switch ($SelectedResource.ResourceType)
{
    "Microsoft.Compute/virtualMachines" {
        Write-Host "Resource: StandAlone VM."      
        .\Resource\VM-Standalone.ps1 -ResourceGroupName $ResourceGroupName -ResourceName $SelectedResource.ResourceName 
    }
}