# Enable auto export
set -a

# All the variables for the deployment
subscription_name="AzureDev"
resource_group_name="rg-azure-iot-edge"
location="northeurope"
workspace_name="log-iot"

iot_hub_name="iot-demo000000010"
iot_hub_sku="S1"

edge_device_id="edge1"

vnet_name="vnet-iot"
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
nsg_rule_myip_name="myip-rule"
nsg_rule_deny_name="deny-rule"

# Prepare extensions and providers
az extension add --upgrade --yes --name azure-iot

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

iot_hub_json=$(az iot hub create --resource-group $resource_group_name --name $iot_hub_name --sku $iot_hub_sku --partition-count 2 -o json)
iot_hub_id=$(echo $iot_hub_json | jq -r .id)
echo $iot_hub_json
echo $iot_hub_id

cat << EOF > logs.json
[
  {
    "categoryGroup": "allLogs",
    "enabled": true,
    "retentionPolicy": {
      "enabled": false,
      "days": 0
    }
  }
]
EOF
cat logs.json
az monitor diagnostic-settings create \
  --name "diag" --resource-group $resource_group_name \
  --resource $iot_hub_id \
  --export-to-resource-specific true \
  --logs '@logs.json' \
  --workspace $workspace_name

device_identity_json=$(az iot hub device-identity create --device-id $edge_device_id --edge-enabled --hub-name $iot_hub_name -o json)
echo $device_identity_json

device_identity_connection_string_json=$(az iot hub device-identity connection-string show --device-id $edge_device_id --hub-name $iot_hub_name -o json)
echo $device_identity_connection_string_json

device_identity_connection_string=$(echo $device_identity_connection_string_json | jq -r .connectionString)
echo $device_identity_connection_string

az iot hub device-identity list --hub-name $iot_hub_name
az iot hub device-identity list --hub-name $iot_hub_name -o table

cat deployment.template.json | envsubst '$iot_hub_id,$workspace_id,$workspace_key'  > deployment.output.json
az iot edge set-modules --device-id $edge_device_id --hub-name $iot_hub_name --content deployment.output.json

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

# Use cloud init file from:
daemon_configuration=$(cat daemon.json | jq -c)
echo $daemon_configuration
curl -s https://raw.githubusercontent.com/Azure/iotedge-vm-deploy/1.4/cloud-init.txt > cloud-init.txt
cat cloud-init.txt
awk "{sub(/{{{dcs}}}/,\"$device_identity_connection_string\"); print}" cloud-init.txt > cloud-init-updated.txt
echo "  - mkdir -p /iotedge/edgeagent" >> cloud-init-updated.txt
echo "  - mkdir -p /iotedge/edgehub" >> cloud-init-updated.txt
echo "  - echo '$daemon_configuration' > /etc/docker/daemon.json" >> cloud-init-updated.txt

jq --help
cat cloud-init-updated.txt

vm_json=$(az vm create \
  --resource-group $resource_group_name  \
  --name $vm_name \
  --image "Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest" \
  --size Standard_DS1_v2 \
  --admin-username $vm_username \
  --admin-password $vm_password \
  --custom-data cloud-init-updated.txt \
  --subnet $subnet_vm_id \
  --accelerated-networking true \
  --nsg "" \
  --public-ip-sku Standard \
  -o json)

vm_public_ip_address=$(echo $vm_json | jq -r .publicIpAddress)
echo $vm_public_ip_address

# Display variables
# Remember to enable auto export
set -a
echo vm_username=$vm_username
echo vm_password=$vm_password
echo vm_public_ip_address=$vm_public_ip_address
echo device_identity_connection_string=$device_identity_connection_string

ssh $vm_username@$vm_public_ip_address

# Or using sshpass
sshpass -p $vm_password ssh $vm_username@$vm_public_ip_address

# Setup VM (if not using cloud-init)-->
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install moby-engine -y
# sudo apt-get install docker.io -y

# https://learn.microsoft.com/en-us/azure/iot-edge/how-to-provision-single-device-linux-symmetric?view=iotedge-1.4&tabs=azure-cli%2Cubuntu
sudo apt-get install aziot-edge defender-iot-micro-agent-edge

sudo iotedge config mp --connection-string $device_identity_connection_string

sudo iotedge config apply
# <--Setup VM (if not using cloud-init)

sudo cat /etc/aziot/config.toml

sudo iotedge system status

sudo iotedge system logs
sudo iotedge system logs -- -f

sudo iotedge system logs | grep Sending

# Switch to debug logging
sudo iotedge system set-log-level debug
sudo iotedge system restart

# Switch to normal logging
sudo iotedge system set-log-level info
sudo iotedge system restart

sudo iotedge logs edgeAgent
sudo iotedge logs edgeHub

sudo iotedge check

sudo iotedge list

sudo iotedge support-bundle --since 6h

sudo docker ps -a

sudo docker logs SimulatedTemperatureSensor
sudo docker logs edgeAgent
sudo docker logs edgeHub

sudo docker logs edgeHub | grep Sending
sudo docker logs edgeHub | grep upstream -A 3 -B 3
sudo docker logs edgeHub | grep upstream -A 3 -B 3 | grep CloudEndpoint

sudo docker logs edgeHub | grep "CloudProxy]"
sudo docker logs edgeHub | grep "Sending message for " -A 3 -B 3
sudo docker logs edgeHub | grep "Error sending message batch for "

sudo docker logs edgeHub | grep "Operation SendEventAsync"
sudo docker logs edgeHub | grep "Operation SendEventBatchAsync"
sudo docker logs edgeHub | grep "Operation SendEventBatchAsync" -A 3 -B 3

# If using /iotedge
ls /iotedge
sudo ls -lF /iotedge/edgeagent/edgeAgent
sudo ls -lF /iotedge/edgehub/edgeHub

sudo du -h  /iotedge/edgeagent/edgeAgent
sudo du -h  /iotedge/edgehub/edgeHub

df -h

sudo docker ps

curl --insecure https://localhost/

# Edgehub metrics
curl -s http://localhost:9601/metrics
curl -s http://localhost:9601/metrics | grep edgehub_message_size_bytes_sum | cut -d " " -f2-
curl -s http://localhost:9601/metrics | grep edgehub_message_size_bytes_count | cut -d " " -f2-
curl -s http://localhost:9601/metrics | grep edgehub_queue_length | tail -n 1 | cut -d " " -f2-

# If using docker default overlay
sudo ls -lF /var/lib/docker/overlay2
sudo bash
cd /var/lib/docker/overlay2
ls -lF

# WARNING: These are restart commands!
sudo iotedge restart SimulatedTemperatureSensor
sudo iotedge restart edgeAgent
sudo iotedge restart edgeHub

# WARNING: Blocking network traffic commands!
# - iptables
sudo iptables --help
sudo iptables --list

# - traffic control
#   https://wiki.linuxfoundation.org/networking/netem#delaying_only_some_traffic
sudo tc - help

# Exit VM
exit

# Firewall
# https://learn.microsoft.com/en-us/azure/iot-edge/troubleshoot?view=iotedge-1.4#check-your-firewall-and-port-configuration-rules
# https://learn.microsoft.com/en-us/azure/iot-hub/iot-hub-devguide-protocols

# Disconnect solution
az network nsg rule create \
  --resource-group $resource_group_name \
  --nsg-name $nsg_name \
  --name $nsg_rule_deny_name \
  --protocol '*' \
  --direction outbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range '*' \
  --access deny \
  --priority 200

# Remove network security rule -> Resolve the connection
az network nsg rule delete \
  --resource-group $resource_group_name \
  --nsg-name $nsg_name \
  --name $nsg_rule_deny_name

# Misc
az iot hub module-identity list --device-id $edge_device_id --hub-name $iot_hub_name
az iot hub module-twin show --device-id $edge_device_id --module-id '$edgeAgent' --hub-name $iot_hub_name

# Wipe out the resources
az group delete --name $resource_group_name -y
