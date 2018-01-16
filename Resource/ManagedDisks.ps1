[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceName,

    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
    [int]$VMName

)

Write-Verbose "Getting the details of the Managed Disk " 
$AzureMD = Get-AzureRmDisk -ResourceGroupName $ResourceGroupName -DiskName $ResourceName
$AzureMD

<#
$AzureVMFailOptions1 = New-Object system.object 
$AzureVMFailOptions1 | Add-Member NoteProperty -name ID -Value 1
$AzureVMFailOptions1 | Add-Member NoteProperty -name Name -Value "Remove this Managed Disk from VM"
$AzureVMFailOptions2 = New-Object system.object 
$AzureVMFailOptions2 | Add-Member NoteProperty -name ID -Value 2
$AzureVMFailOptions2 | Add-Member NoteProperty -name Name -Value "Add this Managed Disk to the VM"



$AzureFailOptionsArray += $AzureVMFailOptions1, $AzureVMFailOptions2

if($ResourceAction -eq -1){
    $AzureVMFailOption = $AzureFailOptionsArray | Out-GridView -Title "Select the action" -PassThru
}
else{
    if($ResourceAction -eq 1){
        $AzureVMFailOption = $AzureVMFailOptions1;
    }
    else {
        $AzureVMFailOption = $AzureVMFailOptions2;
    }
}

$AzureVMFailOption
Write-Verbose $AzureVMFailOption.Name

switch ($AzureVMFailOption.ID)
{
    1 {
        Write-Verbose "Restarting VM."
        Restart-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $ResourceName
    }
    2 {
        Write-Verbose "Stoping VM."
        Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $ResourceName
    }
    3 {
        Write-Verbose "Start VM."
        Start-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $ResourceName
    }
}
#>