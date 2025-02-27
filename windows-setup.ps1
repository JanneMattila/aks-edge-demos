# Test proxy

$proxyIp = "10.4.0.5"
$proxy = "http://$($proxyIp):3128"

# Should timeout
Invoke-WebRequest -UseBasicParsing -Uri https://bing.com
Invoke-WebRequest -UseBasicParsing -Uri https://echo.jannemattila.com/pages/echo

# Should work (no auth)
Invoke-WebRequest -UseBasicParsing -Uri https://bing.com -Proxy $proxy
Invoke-WebRequest -UseBasicParsing -Uri https://echo.jannemattila.com/pages/echo -Proxy $proxy

# Should work (if using auth in proxy)
$proxyPassword = ConvertTo-SecureString "proxypassword" -AsPlainText -Force
$proxyCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList "proxyuser", $proxyPassword
Invoke-WebRequest -UseBasicParsing -Uri https://bing.com -Proxy $proxy -ProxyCredential $proxyCredentials
Invoke-WebRequest -UseBasicParsing -Uri https://echo.jannemattila.com/pages/echo -Proxy $proxy -ProxyCredential $proxyCredentials

# Set proxy
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $registryPath ProxyEnable -Value 0
Set-ItemProperty -Path $registryPath ProxyEnable -Value 1
Set-ItemProperty -Path $registryPath ProxyServer -Value $proxy
Set-ItemProperty -Path $registryPath ProxyServer -Value ""
Get-ItemProperty -Path $registryPath ProxyServer

# [system.net.webrequest]::DefaultWebProxy.Credentials = $proxyCredentials
# [system.net.webrequest]::DefaultWebProxy = new-object system.net.webproxy($proxy)

netsh winhttp reset proxy
netsh winhttp set proxy proxy-server=$proxy bypass-list="localhost"
netsh winhttp show proxy
# netsh winhttp import proxy source=ie

[Environment]::SetEnvironmentVariable("HTTP_PROXY", $proxy, "Machine")
[Environment]::SetEnvironmentVariable("HTTP_PROXY", $proxy, "Process")
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", $proxy, "Machine")
[Environment]::SetEnvironmentVariable("HTTPS_PROXY", $proxy, "Process")
$env:HTTP_PROXY = $proxy
$env:HTTPS_PROXY = $proxy

$env:HTTP_PROXY
$env:HTTPS_PROXY

# Run Windows Update
wuauclt.exe /updatenow

# Use C:\code for our installation folder
mkdir \code -Force
Set-Location \code

# Install AKS Edge Deploy
Invoke-WebRequest -Uri "https://github.com/Azure/AKS-Edge/archive/refs/tags/1.3.186.0.zip" -OutFile aks-edge.zip
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

$product = "AKS Edge Essentials - K8s"

$aksEdgeConfig = @{
    "SchemaVersion"     = "1.3"
    "Version"           = "1.0"
    "AksEdgeProduct"    = $product
    "AksEdgeProductUrl" = ""
    "InstallOptions" = @{
        "InstallPath" = ""
        "VhdxPath" = ""
    }
    "VSwitch"= @{
        "Name" = ""
        "AdapterName" = ""
    }
    "Azure"             = @{
        "ConnectedMachineName" = $cluster_name
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
    "AksEdgeConfigFile" =  "aksedge-config.json"
    "AksEdgeConfig"     = @{
        "SchemaVersion"  = "1.14"
        "Version"        = "1.0"
        "DeploymentType" = "SingleMachineCluster"
        "Init"           = @{
            "ServiceIPRangeSize" = 10
        }
        "Arc"            = @{
            "ClusterName"          = $cluster_name
            "SubscriptionName"     = $subscription_name
            "SubscriptionId"       = $subscription_id
            "TenantId"             = $tenant_id
            "ServicePrincipalName" = $spn_name
            "ResourceGroupName"    = $resource_group_name
            "Location"             = $location
            "ClientId"             = $spn_app_id
            "ClientSecret"         = $spn_secret
        }
        "Network"        = @{
            "NetworkPlugin"    = "calico"
            "InternetDisabled" = $false
            "Proxy"            = @{
                "Http"  = $null
                "Https" = $null
                "No"    = $null # Auto populate: https://github.com/Azure/AKS-Edge/blob/1.0.266.0/tools/modules/AksEdgeDeploy/AksEdge-Arc.ps1#L870
            }
        }
        "User"           = @{
            "AcceptEula"              = $true
            "AcceptOptionalTelemetry" = $true
        }
        "Machines"       = @(
            @{
                "LinuxNode" = @{
                    "CpuCount"     = 4
                    "MemoryInMB"   = 7500
                    "DataSizeInGB" = 120
                    "LogSizeInGB"  = 4
                }
            }
        )
    }
}

$aksEdgeConfig.AksEdgeConfig | ConvertTo-Json -Depth 5 > $aksEdgeJson
$aksEdgeConfig.AksEdgeConfig = $null
# $aksEdge = cat $aksEdgeJson | ConvertFrom-Json
# $aksEdge.Init.ServiceIPRangeSize = 10
# $aksEdge.Network.Proxy.Http = $proxy
# $aksEdge.Network.Proxy.Https = $proxy
# $aksEdge | ConvertTo-Json -Depth 5  > $aksEdgeJson

$aksEdgeConfig
$aksEdgeConfig | ConvertTo-Json -Depth 5 > $aideJson
$aideJson
cat $aideJson
cat $aksEdgeJson

Set-AideUserConfig -jsonFile $aideJson
(Get-AideUserConfig).AksEdgeConfig.Network

Test-AideUserConfig

Start-AideWorkflow
Start-AideWorkflow -jsonFile $aideJson

# Test "AKSEdge" module
Get-Command -Module AKSEdge | Format-Table Name, Version

kubectl get nodes

# If using Azure VM, then current check prevents installing of agent automatically
# Azure VM->
Invoke-WebRequest -UseBasicParsing -Uri "https://aka.ms/azcmagent-windows" -TimeoutSec 30 -OutFile "$env:TEMP\install_windows_azcmagent.ps1"
& "$env:TEMP\install_windows_azcmagent.ps1"
# <-Azure VM

# Installs Azure CLI
Initialize-AideArc

# Write-Output "[logging]" >> %USERPROFILE%\.azure\config
# Write-Output "enable_log_file = yes" >> %USERPROFILE%\.azure\config
# Write-Output "log_dir = c:\code\az.log" >> %USERPROFILE%\.azure\config
# cat %USERPROFILE%\.azure\config

Connect-AideArc
# Connect Arc-enabled kubernetes
Connect-AksEdgeArc -JsonConfigFilePath .\aksedge-config.json

# Individual Arc connections
Connect-AideArcKubernetes

Get-AksEdgeManagedServiceToken

Invoke-AksEdgeNodeCommand -NodeType Linux -command "sudo ls /var/lib/rancher/k3s/storage"

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
