[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceName
)

Write-Verbose "Getting the details of the standalone VM " 
$AzureVM = Get-AzureRMVM -ResourceGroupName $ResourceGroupName -Name $ResourceName



$AzureVMFailOptions1 = New-Object system.object 
$AzureVMFailOptions1 | Add-Member NoteProperty -name ID -Value 1
$AzureVMFailOptions1 | Add-Member NoteProperty -name Name -Value "Stop VM"

$AzureVMFailOptions2 = New-Object system.object 
$AzureVMFailOptions2 | Add-Member NoteProperty -name ID -Value 2
$AzureVMFailOptions2 | Add-Member NoteProperty -name Name -Value "Restart VM"

$AzureFailOptionsArray += $AzureVMFailOptions1, $AzureVMFailOptions2

$AzureVMFailOption = $AzureFailOptionsArray | Out-GridView -Title "Select the action" -PassThru

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
}
