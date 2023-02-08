# Enable auto export
set -a

# All the variables for the deployment
subscription_name="development"
resource_group_name="rg-azure-aks-edge-essentials"
location="northeurope"
workspace_name="log-edge"

vnet_name="vnet-edge"
subnet_vm_name="snet-vm"

vm_name="vm"
vm_username="azureuser"

if test -f ".env"; then
  # Password has been created so load it
  source .env
else
  # Generate password and store it
  vm_password=$(openssl rand -base64 32)
  echo "vm_password=$vm_password" > .env
fi

nsg_name="nsg-vm"
nsg_rule_ssh_name="ssh-rule"
nsg_rule_rdp_name="rdp-rule"
nsg_rule_myip_name="myip-rule"
nsg_rule_deny_name="deny-rule"

# Prepare extensions and providers
# az extension add --upgrade --yes --name azure-iot

# Login and set correct context
az login -o table
az account set --subscription $subscription_name -o table

# Create resource group
az group create -l $location -n $resource_group_name -o table

workspace_json=$(az monitor log-analytics workspace create -g $resource_group_name -n $workspace_name -o json)
workspace_id=$(echo $workspace_json | jq -r .customerId)
workspace_key=$(az monitor log-analytics workspace get-shared-keys --resource-group $resource_group_name --workspace-name $workspace_name --query primarySharedKey -o tsv)
echo $workspace_json
echo $workspace_id
echo $workspace_key

az network nsg create \
  --resource-group $resource_group_name \
  --name $nsg_name

my_ip=$(curl --no-progress-meter https://api.ipify.org)
echo $my_ip

az network nsg rule create \
  --resource-group $resource_group_name \
  --nsg-name $nsg_name \
  --name $nsg_rule_ssh_name \
  --protocol '*' \
  --direction inbound \
  --source-address-prefix $my_ip \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range '22' \
  --access allow \
  --priority 100

az network nsg rule create \
  --resource-group $resource_group_name \
  --nsg-name $nsg_name \
  --name $nsg_rule_rdp_name \
  --protocol '*' \
  --direction inbound \
  --source-address-prefix $my_ip \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range '3389' \
  --access allow \
  --priority 200

az network nsg rule create \
  --resource-group $resource_group_name \
  --nsg-name $nsg_name \
  --name $nsg_rule_myip_name \
  --protocol '*' \
  --direction outbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix $my_ip \
  --destination-port-range '*' \
  --access allow \
  --priority 100

vnet_id=$(az network vnet create -g $resource_group_name --name $vnet_name \
  --address-prefix 10.0.0.0/8 \
  --query newVNet.id -o tsv)
echo $vnet_id

subnet_vm_id=$(az network vnet subnet create -g $resource_group_name --vnet-name $vnet_name \
  --name $subnet_vm_name --address-prefixes 10.4.0.0/24 \
  --network-security-group $nsg_name \
  --query id -o tsv)
echo $subnet_vm_id

vm_json=$(az vm create \
  --resource-group $resource_group_name  \
  --name $vm_name \
  --image "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest" \
  --size Standard_D8ds_v4 \
  --admin-username $vm_username \
  --admin-password $vm_password \
  --custom-data cloud-init-updated.txt \
  --subnet $subnet_vm_id \
  --accelerated-networking true \
  --nsg "" \
  --public-ip-sku Standard \
  -o json)

az vm run-command invoke -g $resource_group_name -n $vm_name \
  --command-id RunPowerShellScript \
  --scripts "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"

az vm run-command invoke -g $resource_group_name -n $vm_name \
  --command-id RunPowerShellScript \
  --scripts "Start-Service sshd"

vm_public_ip_address=$(echo $vm_json | jq -r .publicIpAddress)
echo $vm_public_ip_address

# Display variables
echo vm_username=$vm_username
echo vm_password=$vm_password
echo vm_public_ip_address=$vm_public_ip_address

az ssh vm -g $resource_group_name -n $vm_name --local-user $vm_username

ssh $vm_username@$vm_public_ip_address

# Or using sshpass
sshpass -p $vm_password ssh $vm_username@$vm_public_ip_address

powershell.exe
mkdir \code
cd \code

iwr -o aks-edge.zip https://github.com/Azure/AKS-Edge/archive/refs/heads/main.zip
dir
Expand-Archive aks-edge.zip -DestinationPath C:\code\edge
cd edge\AKS-Edge-main\tools
dir

.\AksEdgeShell.ps1
Get-Module
Get-Command -Name AksEdgeDeploy | Format-Table Name, Version

# Exit VM
exit

# Wipe out the resources
az group delete --name $resource_group_name -y
