[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceName
)

Write-Verbose "Getting the details of the VM Availability Set" 
$SelectedAvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $ResourceGroupName -Name $ResourceName

$SelectedAvailabilitySet

$VMRefs = New-Object System.Collections.Generic.List[PSCustomObject]

$AS = Get-AzureRmAvailabilitySet -ResourceGroupName $ResourceGroupName -Name $ResourceName
# TODO: Filter out by Selected availability set.
$AS.VirtualMachinesReferences | ForEach { 
    $VMResource =(Get-AzureRmResource -Id $_.id); 
    $VM= Get-AzureRMVM -Name $VMResource.Name -ResourceGroup $VMResource.ResourceGroupName -Status; 
    $VMRefs.Add([PSCustomObject]@{"Name"=$VM.Name; "FaultDomain"=$VM.PlatformFaultDomain;"UpdateDomain"=$VM.PlatformUpdateDomain;})
}

$VMRefs | Format-Table Name, UpdateDOmain, FaultDomain -AutoSize


$AzureASFailOptions1 = New-Object system.object 
$AzureASFailOptions1 | Add-Member NoteProperty -name ID -Value 1
$AzureASFailOptions1 | Add-Member NoteProperty -name Name -Value "Stop all VMs in the FaultDomain"

$AzureASFailOptions2 = New-Object system.object 
$AzureASFailOptions2 | Add-Member NoteProperty -name ID -Value 2
$AzureASFailOptions2 | Add-Member NoteProperty -name Name -Value "Restart all VMs in the FaultDomain"

$AzureASFailOptions3 = New-Object system.object 
$AzureASFailOptions3 | Add-Member NoteProperty -name ID -Value 3
$AzureASFailOptions3 | Add-Member NoteProperty -name Name -Value "Start all VMs in the FaultDomain"

$AzureASFailOptions4 = New-Object system.object 
$AzureASFailOptions4 | Add-Member NoteProperty -name ID -Value 4
$AzureASFailOptions4 | Add-Member NoteProperty -name Name -Value "Stop all VMs in the UpdateDomain"

$AzureASFailOptions5 = New-Object system.object 
$AzureASFailOptions5 | Add-Member NoteProperty -name ID -Value 5
$AzureASFailOptions5 | Add-Member NoteProperty -name Name -Value "Restart all VMs in the UpdateDomain"

$AzureASFailOptions6 = New-Object system.object 
$AzureASFailOptions6 | Add-Member NoteProperty -name ID -Value 6
$AzureASFailOptions6 | Add-Member NoteProperty -name Name -Value "Start all VMs in the UpdateDomain"

$AzureASFailOptionsArray += $AzureASFailOptions1, $AzureASFailOptions2, $AzureASFailOptions3, $AzureASFailOptions4, $AzureASFailOptions5, $AzureASFailOptions6

$AzureASFailOption = $AzureASFailOptionsArray | Out-GridView -Title "Select the action" -PassThru

Write-Host $"Action Selected: $AzureASFailOption"



switch ($AzureASFailOption.ID)
{
    1 {
        Write-Verbose "Stoping all VMs in the Scale set."
        
        Stop-AzureRmVMss -ResourceGroupName $ResourceGroupName -VMScaleSetName $ResourceName -StayProvisioned
        Write-Host "Stopped all the VMs in the Scale set"
    }
    2 {
        Write-Verbose "Restarting all VMs in the Scale set."
        Restart-AzureRmVMss -ResourceGroupName $ResourceGroupName -VMScaleSetName $ResourceName
        Write-Host "Restarted all the VMs in the Scale set"
    }    
    3 {
        Write-Verbose "Starting all VMs in the Scale set."
        Start-AzureRmVMss -ResourceGroupName $ResourceGroupName -VMScaleSetName $ResourceName
        Write-Host "Started all the VMs in the Scale set"
    }
    4 {
        Write-Verbose "Getting the VMs in the Scale Set for further action."
        $SelectedVmInstance = $VMsInScaleSet | Select-Object -Property InstanceId, ProvisioningState, Name | Out-GridView -Title "Select the VM" -PassThru
        $SelectedVmInstance
        Write-Verbose "Passing the VM name to the standalone VM actions."
        .\Resource\VM-Standalone.ps1 -ResourceGroupName $ResourceName -ResourceName $SelectedVmInstance.Name
    }
}
