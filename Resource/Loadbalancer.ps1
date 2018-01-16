[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
    [string]$ResourceName,

    [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
    [int]$ResourceAction = -1
)

$AzureLB = Get-AzureRmLoadBalancer -ResourceGroupName $ResourceGroupName -Name $ResourceName

if($AzureLB.BackendAddressPools -ne $null){
    $AzureLBBackEndConfig = $AzureLB.BackendAddressPools[0].BackendIpConfigurations

    if($AzureLBBackEndConfig -ne $null){

        $AzureLBFailOptions1 = New-Object system.object 
        $AzureLBFailOptions1 | Add-Member NoteProperty -name ID -Value 1
        $AzureLBFailOptions1 | Add-Member NoteProperty -name Name -Value "Restart N/2 VM's in the load balancer back end"
        $AzureLBFailOptions2 = New-Object system.object 
        $AzureLBFailOptions2 | Add-Member NoteProperty -name ID -Value 2
        $AzureLBFailOptions2 | Add-Member NoteProperty -name Name -Value "Stop N/2 VM's in the load balancer back end"

        $AzureFailOptionsArray += $AzureLBFailOptions1, $AzureLBFailOptions2
        $AzureLBFailOption = $AzureFailOptionsArray | Out-GridView -Title "Select the action" -PassThru

        for ($i=0; $i -le $AzureLBBackEndConfig.Count/2; $i++)
        {
            $AzureNicName = $AzureLBBackEndConfig[$i].Id.Split('/')[8]
            $AzureNic = Get-AzureRmNetworkInterface -Name $AzureNicName -ResourceGroupName $ResourceGroupName
            $AzureVM = Get-AzureRmResource -ResourceId $AzureNic.VirtualMachine.Id | Get-AzureRMVM
            $AzureVM.Name
            if($AzureVM -ne $null){
                $command = .\Resource\ActionCommand.ps1 -ResourceGroupName $ResourceName -ResourceName $ResourceName -ResourceAction $AzureLBFailOption.ID 
                $command
                switch ($AzureLBFailOption.ID)
                {
                    1 {
                        .\Resource\VM-Standalone.ps1 -ResourceGroupName $ResourceGroupName -ResourceName $AzureVM.Name -ResourceAction 1 -LogCommand $true
                    }
                    2 {
                        .\Resource\VM-Standalone.ps1 -ResourceGroupName $ResourceGroupName -ResourceName $AzureVM.Name -ResourceAction 1 -LogCommand $true
                    }
                }
            }
        }
    }
}