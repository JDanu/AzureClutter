
[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [object]$SelectedResource
)


Write-Host $"Selected resource: $SelectedResource.ResourceName"

switch ($SelectedResource.ResourceType)
{
    "Microsoft.Compute/virtualMachines" {
        Write-Host "Resource Type: StandAlone VM."      
        .\Resource\VM-Standalone.ps1 -ResourceGroupName $ResourceGroupName -ResourceName $SelectedResource.ResourceName 
    }
    "Microsoft.Compute/virtualMachineScaleSets"{
        Write-Host "Resource Type: Virtual Machine Scale Set."
        .\Resource\VM-ScaleSet.ps1 -ResourceGroupName $ResourceGroupName -ResourceName $SelectedResource.ResourceName
    }
    "Microsoft.Compute/availabilitySets" {
        Write-Host "Resource Type: Availability Set"
        .\Resource\VM-AvailabilitySet.ps1 -ResourceGroupName $ResourceGroupName -ResourceName $SelectedResource.ResourceName
    }
}
