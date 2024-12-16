# Count Azure resources for ServiceNow Subscription Unit licensing.
Powershell script to count resources across multiple Azure subscriptions ID's to help determine ServiceNow Subscription Unit licenses.

Run this script in an Azure Powershell terminal.

## Example output
```powershell
PS /home/azure_count_subscriptionunits-main> ./azure_resources.ps1
Current subscription is 
obfuscated
Subtotal for Virtual Machines 0
Subtotal for Platform as service 0, SUs 0
Subtotal for Function as service 0, SUs 0
Current subscription is 
obfuscated
Subtotal for Virtual Machines 0
Subtotal for Platform as service 1, SUs 0.333333333333333
Subtotal for Function as service 1, SUs 0.05
Total number of resources in all subscriptions: 0.383333333333333
PS /home/azure_count_subscriptionunits-main> 
