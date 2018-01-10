[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceName
)

Write-Verbose "Getting the details of the VM ScaleSet" 
$SelectedVMSS = Get-AzureRMVmss -ResourceGroupName $ResourceGroupName -VMScaleSetName $ResourceName

$SelectedVMSS

Write-Verbose "Getting the details of the VM ScaleSet" 
$VMsInScaleSet = Get-AzureRmVmssVM -ResourceGroupName $ResourceGroupName -VMScaleSetName $ResourceName

Write-Host "VMs in the scale set:"
$VMsInScaleSet | Select-Object -Property InstanceId, ProvisioningState, Name

$AzureVMFailOptions1 = New-Object system.object 
$AzureVMFailOptions1 | Add-Member NoteProperty -name ID -Value 1
$AzureVMFailOptions1 | Add-Member NoteProperty -name Name -Value "Stop all VMs in the ScaleSet"

$AzureVMFailOptions2 = New-Object system.object 
$AzureVMFailOptions2 | Add-Member NoteProperty -name ID -Value 2
$AzureVMFailOptions2 | Add-Member NoteProperty -name Name -Value "Restart all VMs in the ScaleSet"

$AzureVMFailOptions3 = New-Object system.object 
$AzureVMFailOptions3 | Add-Member NoteProperty -name ID -Value 3
$AzureVMFailOptions3 | Add-Member NoteProperty -name Name -Value "Start all VMs in the ScaleSet"

$AzureVMFailOptions4 = New-Object system.object 
$AzureVMFailOptions4 | Add-Member NoteProperty -name ID -Value 4
$AzureVMFailOptions4 | Add-Member NoteProperty -name Name -Value "Select individual VM to do further action"

$AzureVMSSFailOptionsArray += $AzureVMFailOptions1, $AzureVMFailOptions2, $AzureVMFailOptions3, $AzureVMFailOptions4

$AzureVMssFailOption = $AzureVMSSFailOptionsArray | Out-GridView -Title "Select the action" -PassThru

Write-Host $"Action Selected: $AzureVMssFailOption"

switch ($AzureVMssFailOption.ID)
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
