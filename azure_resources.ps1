$total_count = 0
$sub_count = 0
$su_count = 0

# Get Azure Subscriptions ID's
$GroupList = az account list --query '[].id'

# Loop for each Azure Subscription ID
foreach ($id in $GroupList) {
    if ($id.length -gt 4) {
        $sub_count = 0
        $Id_Comp = $id.substring(2,37).Trim('"', " ")
        az account set --subscription $Id_Comp
        echo "Current subscription is " $Id_Comp
        # use for loop to read all values and ID
        # echo "Microsoft.Compute/virtualmachines"
        $vm=$(az resource list --resource-type "Microsoft.Compute/virtualmachines" --query "length([?contains(id,'$Id_Comp')])")
        if ($vm -gt 0) {
            # Server resources are counted at 1:1 SU
            echo "VirtualMachine Count: $vm"
            $total_count = $total_count + $vm
            $sub_count = $sub_count + $vm
        }
        echo "Subtotal for Virtual Machines $sub_count"

        $sub_count = 0
        $su_count = 0
        foreach ($line in Get-Content .\resources.azure.list) {
            # echo "Line_ID $line for Id_Comp $Id_Comp"
            if ($line.equals("Microsoft.Web/sites")) {
                $res=$(az resource list --resource-type "$line" --query "length([?contains(id,'$Id_Comp')] && [?kind == 'app'])")
            } else {
                $res=$(az resource list --resource-type "$line" --query "length([?contains(id,'$Id_Comp')])")
            }
            
            # loop to count total PaaS resources for all ID's
            if ($res -gt 0) {
                # Sub Count is for count of PaaS resources
                $sub_count = $sub_count + $res
                # PaaS services are counted at 1:3 SU's - This script rounds the SU up to the next integer.
                $su_count = $su_count + [Math]::Round($res/3, 0)
                $total_count = $total_count + [Math]::Round($res/3, 0)
            }
        }
        echo "Subtotal for Platform as service $sub_count, SUs $su_count"

        $sub_count = 0
        $su_count = 0
        foreach ($line in Get-Content .\resources.faas.azure.list) {
            # echo "Line_ID $line for Id_Comp $Id_Comp"
            $res=$(az resource list --resource-type "$line" --query "length([?contains(id,'$Id_Comp')] && [?contains(kind,'functionapp')])")
            if ($res -gt 0) {
                $sub_count = $sub_count + $res
                # FaaS services are counted at 1:20 SU's - This script rounds the SU up to the next integer.
                $su_count = $su_count + [Math]::Round($res/20, 0)
                $total_count = $total_count + [Math]::Round($res/20, 0)
            }
        }
        echo "Subtotal for Function as service $sub_count, SUs $su_count"
    }
}

echo "Total number of resources in all subscriptions: $total_count"
