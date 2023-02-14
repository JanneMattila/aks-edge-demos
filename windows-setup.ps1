# Use C:\code for our installation folder
mkdir \code
Set-Location \code

# Install AKS Edge Deploy
Invoke-WebRequest -Uri "https://github.com/Azure/AKS-Edge/archive/main.zip" -OutFile aks-edge.zip
Expand-Archive aks-edge.zip -DestinationPath C:\code\edge -Force

$aideJson = (Get-ChildItem -Path "edge" -Filter aide-userconfig.json -Recurse).FullName
$aksEdgeJson = (Get-ChildItem -Path "edge" -Filter aksedge-config.json -Recurse).FullName
$aksEdgeShell = (Get-ChildItem -Path "edge" -Filter AksEdgeShell.ps1 -Recurse).FullName
$aidejson
$aksEdgeJson
$aksEdgeShell

. $aksEdgeShell
Get-Module
Get-Command -Module AksEdgeDeploy | Format-Table Name, Version

$tenant_id = "<your-tenant-id>"
$spn_name = "<your-spn-name>"
$spn_app_id = "<your-spn-app-id>"
$spn_secret = "<your-spn-secret>"
$subscription_name = "<your-subscription-name>"
$subscription_id = "<your-subscription-id>"
$resource_group_name = "rg-azure-aks-edge-essentials"
$location = "northeurope"
$cluster_name = "aksee"

# Your service principal requires at least these roles:
# - Azure Connected Machine Onboarding
# - Kubernetes Cluster - Azure Arc Onboarding

$product = "AKS Edge Essentials - K3s (Public Preview)"

$aksEdgeConfig = ConvertTo-Json @{
    "SchemaVersion"     = "1.1"
    "Version"           = "1.0"
    "AksEdgeProduct"    = $product
    "AksEdgeProductUrl" = ""
    "Azure"             = @{
        "ClusterName"          = $cluster_name
        "SubscriptionName"     = $subscription_name
        "SubscriptionId"       = $subscription_id
        "TenantId"             = $tenant_id
        "ServicePrincipalName" = $spn_name
        "ResourceGroupName"    = $resource_group_name
        "Location"             = $location
        "CustomLocationOID"    = ""
        "Auth"                 = @{
            "ServicePrincipalId" = $spn_app_id
            "Password"           = $spn_secret
        }
    }
    "User"              = @{
        "AcceptEula"              = $true
        "AcceptOptionalTelemetry" = $true
    }
    "Init"              = @{
        "ServiceIpRangeSize"      = 10
        "AcceptOptionalTelemetry" = $true
    }
    "AksEdgeConfigFile" = "$aksEdgeJson"
}

$aksEdgeConfig
$aksEdgeConfig > $aideJson
$aideJson
cat $aideJson
cat $aksEdgeJson

Start-AideWorkflow -jsonFile $aideJson

# Test "AKSEdge" module
Get-Command -Module AKSEdge | Format-Table Name, Version

kubectl get nodes

Get-AideUserConfig
Test-AideUserConfig

# Installs Azure CLI
Initialize-AideArc

# If using Azure VM, then current check prevents installing of agent automatically
# Azure VM->
Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/azcmagent-windows" -TimeoutSec 30 -OutFile "$env:TEMP\install_windows_azcmagent.ps1";
& "$env:TEMP\install_windows_azcmagent.ps1";
# <-Azure VM

Connect-AideArc

Get-AksEdgeManagedServiceToken

# Test GitOps deployed apps
kubectl get deploy -n demos

$network_app_svc_ip = $(kubectl get service webapp-network-tester-demo -n demos -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
$network_app_svc_ip

Invoke-WebRequest -UseBasicParsing -Uri http://$network_app_svc_ip

Invoke-RestMethod `
    -Body "HTTP GET https://bing.com" `
    -Method "POST" `
    -Uri http://$network_app_svc_ip/api/commands

Invoke-RestMethod `
    -Body "HTTP GET http://k8s-probe-demo" `
    -Method "POST" `
    -Uri http://$network_app_svc_ip/api/commands

# Exit PowerShell and then SSH session
exit
