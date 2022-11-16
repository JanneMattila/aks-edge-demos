# Logs

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.
Try the new cross-platform PowerShell https://aka.ms/pscore6
Loading AksLiteDeploy module..
Hyper-V is enabled
HostOS  : Microsoft Windows 10 Pro(48)
Version : 10.0.19044.2251
Lang    : en-US
Name    : akslite
Total CPUs              : 2
Free RAM / Total RAM    : 6 GB / 8 GB
Free Disk / Total Disk  : 105 GB / 126 GB
Running as a virtual machine in Azure environment (Name= akslitevmSize= Standard_D2s_v3offer= Windows-10sku= win10-21h2-pro-g2 )with Nested Hyper-V enabled
Azure Kubernetes Service on Windows IoT - K8s (Private Preview) 0.6.22298.1855 is installed.
Loading AksIot module..
AksIot version          : 0.6.22298.1855
AksLiteShell  version   : 2.0.221013.0700
AksLiteDeploy version   : 1.0.221026.1200
PS C:\aksiot\tools> Get-Command -Module AksIot

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-AksLiteNode                                    0.6.222... AksIot
Function        Get-AksLiteClusterJoinData                         0.6.222... AksIot
Function        Get-AksLiteDeploymentInfo                          0.6.222... AksIot
Function        Get-AksLiteEventLog                                0.6.222... AksIot
Function        Get-AksLiteKubeConfig                              0.6.222... AksIot
Function        Get-AksLiteLinuxNodeAddr                           0.6.222... AksIot
Function        Get-AksLiteLinuxNodeName                           0.6.222... AksIot
Function        Get-AksLiteLogs                                    0.6.222... AksIot
Function        Get-AksLiteManagedServiceToken                     0.6.222... AksIot
Function        Invoke-AksLiteLinuxNodeCommand                     0.6.222... AksIot
Function        New-AksLiteDeployment                              0.6.222... AksIot
Function        Remove-AksLiteNode                                 0.6.222... AksIot
Function        Set-AksLiteArcConnection                           0.6.222... AksIot
Function        Set-AksLiteNodeToDrain                             0.6.222... AksIot
Function        Start-AksLiteLinuxNode                             0.6.222... AksIot
Function        Stop-AksLiteLinuxNode                              0.6.222... AksIot
Function        Test-AksLiteNetworkParameters                      0.6.222... AksIot
Function        Test-AksLiteNode                                   0.6.222... AksIot


PS C:\aksiot\tools> New-AksLiteDeployment -SingleMachineCluster -AcceptEula -LinuxVmCpuCount 4 -LinuxVmMemoryInMB 4096 -ServiceIpRangeSize 10
 - Configuration does not exist. Creating a default configuration...

[11/16/2022 06:55:36] Creating configuration

 - Configuration created successfully
[11/16/2022 06:55:37] AksIot - deploying a new Linux single machine k8s cluster                                         
[11/16/2022 06:55:40] Checking host for required features

 - Checking the status of 'Microsoft-Hyper-V'
 - Checking the status of 'Microsoft-Hyper-V-Management-PowerShell'
 - Checking the status of 'Microsoft-Hyper-V-Hypervisor'
 - Checking the status of 'OpenSSH.Client*'

[11/16/2022 06:55:44] Creating single machine cluster hcs network

 - AksIot - private network carved:

Name  : ip4PrefixLength
Value : 24
Name  : LinuxVmIp4Address
Value : 192.168.0.2
Name  : ServiceIPRangeStart
Value : 192.168.0.4

Name  : ip4GatewayAddress
Value : 192.168.0.1

Name  : ip4Subnet
Value : 192.168.0.0
Name  : WindowsVmIp4Address
Value : 192.168.0.3

Name  : ServiceIPRangeEnd
Value : 192.168.0.13

[11/16/2022 06:55:50] Deploying Azure Kubernetes Service on Windows IoT - K8s (Private Preview)

 - WARNING: This is a Private Preview version of Azure Kubernetes Service on Windows IoT - K8s (Private Preview), not intended for production use.
 - WARNING: A clean install may be required for production use once the final General Availability (GA) release is available.

[11/16/2022 06:55:51] Step 1: Preparing host for Azure Kubernetes Service on Windows IoT - K8s (Private Preview)


[11/16/2022 06:55:51] Enabling Microsoft Update. This will allow Azure Kubernetes Service on Windows IoT - K8s (Private Preview) to receive updates.

 - Microsoft Update is enabled.
[11/16/2022 06:55:51] Checking for virtual switch with name 'aksiotsw-int'
- The virtual switch 'aksiotsw-int' of type 'Internal' is present

[11/16/2022 06:55:55] Associating wssdagent service with nodectl


[11/16/2022 06:55:57] Creating vnet (name: aksiotsw-int)

 - Determining DNS servers capable of resolving the endpoint 'microsoft.com' from the list of potential servers (172.17.0.1 168.63.129.16)...
 - Success, one or more eligible DNS servers found (168.63.129.16)...

[11/16/2022 06:56:07] Deploying Azure Kubernetes Service on Windows IoT - K8s (Private Preview)

 - WARNING: This is a Private Preview version of Azure Kubernetes Service on Windows IoT - K8s (Private Preview), not intended for production use.
 - WARNING: A clean install may be required for production use once the final General Availability (GA) release is available.

[11/16/2022 06:56:07] Step 1: Skipped host preparation


[11/16/2022 06:56:07] Step 2: Validating pre-requisites and deployment parameters...

 - Verifying host requirements for selected configuration (20 GB disk size, 4096 MB memory, 4 CPUs)

[11/16/2022 06:56:07] Verifying Host OS can support requested configuration


[11/16/2022 06:56:07] Verifying required storage, RAM and number of cores are available

 - Drive 'C:' has 105 GB free
 - A minimum of 20 GB disk space is required on drive 'C:'
 - Host has 5711 MB free memory
 - A minimum of 4096 MB memory is required
 - Host has 2 CPU cores
 - A minimum of 4 CPU cores is required

[11/16/2022 06:56:07] Exception caught!!!

 - Not enough CPU cores available. (L5373)
 [11/16/2022 06:56:07] In order to attempt another deployment, please uninstall Azure Kubernetes Service on Windows IoT - K8s (Private Preview) and start from fresh                                                                              - AksIot - creation of Linux node failed: Not enough CPU cores available. at line 2967                                 [11/16/2022 06:56:08] Collecting logs from deployment...                                                                

[11/16/2022 06:56:08] Collecting 'Azure Kubernetes Service on Windows IoT - K8s (Private Preview)' configuration


[11/16/2022 06:56:08] Collecting 'Azure Kubernetes Service on Windows IoT - K8s (Private Preview)' event logs

[11/16/2022 06:56:08] Collecting wssdagent configuration
[11/16/2022 06:56:08] Collecting wssdagent logs


[11/16/2022 06:56:08] Collecting node logs


[11/16/2022 06:56:09] Collecting Event Logs
 - Exporting Microsoft-Windows-Host-Network-Service-Admin...
 - Exporting Microsoft-Windows-Host-Network-Service-Operational...
 - Exporting Microsoft-Windows-Hyper-V-Compute-Admin...
 - Exporting Microsoft-Windows-Hyper-V-Compute-Operational...
 - Exporting Microsoft-Windows-Hyper-V-VMMS-Admin...

[11/16/2022 06:56:10] Collecting HCS and HNS information


[11/16/2022 06:56:10] Collecting cluster information
 - Retrieving kubectl describe output from cluster
 - Failed to get kubectl describe output from cluster
 - Error:  LinuxAndWindows configuration does not exist, deploy the missing node(s) first.
 - Retrieving kubectl get pods output from cluster
 - Failed to get kubectl describe output from cluster
 - Error:  LinuxAndWindows configuration does not exist, deploy the missing node(s) first.

[11/16/2022 06:56:11] Collecting host system and version information


[11/16/2022 06:56:16] Compressing logs


[11/16/2022 06:56:17] Zip file is located at "C:\ProgramData\AksIot\logs\aksiotlogs-221116-0656.zip"


[11/16/2022 06:56:17] Attempting to remove hcs single machine cluster network

 - Cleaning up single machine cluster HNS network 'aksiotsw-int' ...
C:\ProgramData\AksIot\logs\aksiotlogs-221116-0656.zip
OK
AksIot - failed create new deployment: AksIot - creation of Linux node failed: Not enough CPU cores available.

PS C:\aksiot\tools> New-AksLiteDeployment -SingleMachineCluster -AcceptEula -LinuxVmCpuCount 2 -LinuxVmMemoryInMB 4096 -ServiceIpRangeSize 10                                                                                                   [11/16/2022 06:57:12] AksIot - deploying a new Linux single machine k8s cluster                                         
[11/16/2022 06:57:12] Checking host for required features

 - Checking the status of 'Microsoft-Hyper-V'
 - Checking the status of 'Microsoft-Hyper-V-Management-PowerShell'
 - Checking the status of 'Microsoft-Hyper-V-Hypervisor'
 - Checking the status of 'OpenSSH.Client*'

[11/16/2022 06:57:15] Creating single machine cluster hcs network

 - AksIot - private network carved:

Name  : ip4PrefixLength
Value : 24
Name  : LinuxVmIp4Address
Value : 192.168.0.2
Name  : ServiceIPRangeStart
Value : 192.168.0.4

Name  : ip4GatewayAddress
Value : 192.168.0.1

Name  : ip4Subnet
Value : 192.168.0.0
Name  : WindowsVmIp4Address
Value : 192.168.0.3

Name  : ServiceIPRangeEnd
Value : 192.168.0.13


[11/16/2022 06:57:15] Deploying Azure Kubernetes Service on Windows IoT - K8s (Private Preview)

 - WARNING: This is a Private Preview version of Azure Kubernetes Service on Windows IoT - K8s (Private Preview), not intended for production use.
 - WARNING: A clean install may be required for production use once the final General Availability (GA) release is available.

[11/16/2022 06:57:16] Step 1: Preparing host for Azure Kubernetes Service on Windows IoT - K8s (Private Preview)


[11/16/2022 06:57:16] Enabling Microsoft Update. This will allow Azure Kubernetes Service on Windows IoT - K8s (Private Preview) to receive updates.

 - Microsoft Update is enabled.

[11/16/2022 06:57:16] Checking for virtual switch with name 'aksiotsw-int'

 - The virtual switch 'aksiotsw-int' of type 'Internal' is present
 [11/16/2022 06:57:16] Associating wssdagent service with nodectl                                                        
[11/16/2022 06:57:16] Creating vnet (name: aksiotsw-int)

 - Determining DNS servers capable of resolving the endpoint 'microsoft.com' from the list of potential servers (172.17.0.1 168.63.129.16)...
 - Success, one or more eligible DNS servers found (168.63.129.16)...

[11/16/2022 06:57:26] Deploying Azure Kubernetes Service on Windows IoT - K8s (Private Preview)

 - WARNING: This is a Private Preview version of Azure Kubernetes Service on Windows IoT - K8s (Private Preview), not intended for production use.
 - WARNING: A clean install may be required for production use once the final General Availability (GA) release is available.

[11/16/2022 06:57:26] Step 1: Skipped host preparation


[11/16/2022 06:57:26] Step 2: Validating pre-requisites and deployment parameters...

 - Verifying host requirements for selected configuration (20 GB disk size, 4096 MB memory, 2 CPUs)

[11/16/2022 06:57:26] Verifying Host OS can support requested configuration


[11/16/2022 06:57:26] Verifying required storage, RAM and number of cores are available

 - Drive 'C:' has 105 GB free
 - A minimum of 20 GB disk space is required on drive 'C:'
 - Host has 5637 MB free memory
 - A minimum of 4096 MB memory is required
 - Host has 2 CPU cores
 - A minimum of 2 CPU cores is required
 - Verifying static IP support for selected configuration
 
 [11/16/2022 06:57:26] Step 3: Verifying Azure Kubernetes Service on Windows IoT - K8s (Private Preview) installation    

[11/16/2022 06:57:26] Verifying installation

 - Verifying whether Hyper-V is enabled and functional

[11/16/2022 06:57:26] Attention: Deploying on an Azure Cloud VM, please make sure the VM supports nested virtualization.

 - Hyper-V core services are active
 - Verifying expected Windows host binaries
 - Verifying expected Linux VM image
 - Testing for ssh key
 - Generating SSH key...
 - Testing for wssdagent service
 - Testing if wssdagent is running
 - Testing if container resource is provisioned
 - Testing if vnet resource 'aksiotsw-int' is provisioned

[11/16/2022 06:57:39] Step 4: Runtime configuration complete. Creating virtual machine

[11/16/2022 06:57:39] Creating virtual machine. Verifying host requirements for selected configuration (17 GB disk size, 4096 MB memory, 2 CPUs)

[11/16/2022 06:57:39] Verifying Host OS can support requested configuration

[11/16/2022 06:57:39] Verifying required storage, RAM and number of cores are available

 - Drive 'C:' has 105 GB free
 - A minimum of 17 GB disk space is required on drive 'C:'
 - Host has 5633 MB free memory
 - A minimum of 4096 MB memory is required
 - Host has 2 CPU cores
 - A minimum of 2 CPU cores is required
[11/16/2022 06:57:40] Extracting Linux VHD
[11/16/2022 06:57:57] Setting dynamically expanding virtual hard disk maximum size to 28.66 GB

 - Creating storage vhd (file: AzureIoTEdgeForLinux-v1-linux-aksiot)
 - Creating vnic (name: akslite-linux-aksiotInterface)
 - Instantiating virtual machine (name: akslite-linux-aksiot)
 - Virtual machine successfuly instantiated

[11/16/2022 06:58:19] Virtual machine created successfully.


[11/16/2022 06:58:19] Successfully created virtual machine


[11/16/2022 06:58:19] Virtual machine hostname: akslite-linux-aksiot


[11/16/2022 06:58:56] Testing SSH connection...


[11/16/2022 06:58:57] ...successfully connected to the Linux VM

 - Please check your DNS configuration to ensure Internet connectivity.

[11/16/2022 06:58:57] Deployment successful


[11/16/2022 06:58:58] Setting DNS servers for Linux node 168.63.129.16.


[11/16/2022 06:59:00] Initializing kubernetes runtime in Linux node.


[11/16/2022 07:00:07] Waiting for Kubernetes node (akslite-linux-aksiot) to reach condition Ready, timeout = 300 seconds


[11/16/2022 07:00:29] Kubernetes node (akslite-linux-aksiot) reached condition Ready


[11/16/2022 07:00:29] AksIot - copying Kubeconfig into the host.


[11/16/2022 07:00:30] AksIot - new deployment successfully created.

OK
PS C:\aksiot\tools>
```

```powershell
PS C:\aksiot\tools> kubectl get nodes
NAME                   STATUS   ROLES                  AGE   VERSION
akslite-linux-aksiot   Ready    control-plane,master   15m   v1.22.6
PS C:\aksiot\tools> kubectl get nodes -o wide
>> kubectl get pods -A -o wide

NAME                   STATUS   ROLES                  AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE            KERNEL-VERSION    CONTAINER-RUNTIME
akslite-linux-aksiot   Ready    control-plane,master   17m   v1.22.6   192.168.0.2   <none>        CBL-Mariner/Linux   5.15.70.1-1.cm2   containerd://1.6.6

NAMESPACE     NAME                                           READY   STATUS    RESTARTS   AGE   IP            NODE                   NOMINATED NODE   READINESS GATES
kube-system   coredns-699c5f8745-lrhmc                       1/1     Running   0          16m   10.244.0.2    akslite-linux-aksiot   <none>           <none>
kube-system   coredns-699c5f8745-rppzm                       1/1     Running   0          16m   10.244.0.4    akslite-linux-aksiot   <none>           <none>
kube-system   etcd-akslite-linux-aksiot                      1/1     Running   0          17m   192.168.0.2   akslite-linux-aksiot   <none>           <none>
kube-system   kube-apiserver-akslite-linux-aksiot            1/1     Running   0          17m   192.168.0.2   akslite-linux-aksiot   <none>           <none>
kube-system   kube-controller-manager-akslite-linux-aksiot   1/1     Running   0          16m   192.168.0.2   akslite-linux-aksiot   <none>           <none>
kube-system   kube-flannel-ds-amd64-4gsls                    1/1     Running   0          16m   192.168.0.2   akslite-linux-aksiot   <none>           <none>
kube-system   kube-proxy-p2h2h                               1/1     Running   0          16m   192.168.0.2   akslite-linux-aksiot   <none>           <none>
kube-system   kube-scheduler-akslite-linux-aksiot            1/1     Running   0          16m   192.168.0.2   akslite-linux-aksiot   <none>           <none>
kube-system   kube-vip-akslite-linux-aksiot                  1/1     Running   0          16m   192.168.0.2   akslite-linux-aksiot   <none>           <none>
kube-system   kube-vip-cloud-provider-0                      1/1     Running   0          16m   10.244.0.3    akslite-linux-aksiot   <none>           <none>
PS C:\aksiot\tools>
```

`echo.yaml`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: echo
---
apiVersion: v1
kind: Service
metadata:
  name: echo-svc
  namespace: echo
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: echo
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-deployment
  namespace: echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      nodeSelector:
        kubernetes.io/os: linux
      containers:
      - image: jannemattila/echo:1.0.90
        name: echo
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
```

```powershell
PS C:\aksiot> kubectl apply -f .\echo.yaml
```

```powershell
PS C:\aksiot> kubectl get all -n echo

NAME                                  READY   STATUS    RESTARTS   AGE
pod/echo-deployment-8478b6c49-2hxtt   1/1     Running   0          79s

NAME               TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/echo-svc   LoadBalancer   10.98.19.148   192.168.0.4   80:31711/TCP   24m

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/echo-deployment   1/1     1            1           24m

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/echo-deployment-8478b6c49    1         1         1       80s
```

```powershell
PS C:\aksiot> $url = "http://192.168.0.4/api/echo"
>> $data = @{
>>     firstName = "John"
>>     lastName = "Doe"
>> }
>> $body = ConvertTo-Json $data
>> Invoke-RestMethod -Body $body -ContentType "application/json" -Method "POST" -DisableKeepAlive -Uri $url
```

![echo app in action](https://user-images.githubusercontent.com/2357647/202119779-11d6fe75-6b26-4c41-b495-26793f5bac83.png)

`webapp-network-tester.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: network-tester
---
apiVersion: v1
kind: Service
metadata:
  name: network-tester-svc
  namespace: network-tester
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: network-tester
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: network-tester-deployment
  namespace: network-tester
spec:
  replicas: 1
  selector:
    matchLabels:
      app: network-tester
  template:
    metadata:
      labels:
        app: network-tester
    spec:
      nodeSelector:
        kubernetes.io/os: linux
      containers:
      - image: jannemattila/webapp-network-tester:latest
        name: network-tester
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
```


```powershell
PS C:\aksiot> kubectl apply -f .\webapp-network-tester.yaml
```

```powershell
PS C:\aksiot> kubectl get svc -A

NAMESPACE        NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default          kubernetes           ClusterIP      10.96.0.1       <none>        443/TCP                  60m
echo             echo-svc             LoadBalancer   10.98.19.148    192.168.0.4   80:31711/TCP             36m
kube-system      kube-dns             ClusterIP      10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   60m
network-tester   network-tester-svc   LoadBalancer   10.103.41.120   192.168.0.4   80:32541/TCP             4m2s
```

```powershell
PS C:\aksiot> kubectl delete -f .\echo.yaml

namespace "echo" deleted
service "echo-svc" deleted
deployment.apps "echo-deployment" deleted
```

![webapp network tester in action](https://user-images.githubusercontent.com/2357647/202121848-adca5983-a177-4a9d-99b1-88848e27353e.png)

```powershell
Invoke-RestMethod `
 -Body "HTTP GET https://api.ipify.org/" `
 -ContentType "text/plain" `
 -Method "POST" `
 -Uri "http://192.168.0.4/api/commands" `
 -DisableKeepAlive
```

```
-> Start: HTTP GET https://api.ipify.org/
20.240.142.221
<- End: HTTP GET https://api.ipify.org/ 536.73ms
```

```powershell
Invoke-RestMethod `
 -Body "NSLOOKUP bing.com" `
 -ContentType "text/plain" `
 -Method "POST" `
 -Uri "http://192.168.0.4/api/commands" `
 -DisableKeepAlive
```

```
-> Start: NSLOOKUP bing.com
NS: 10.96.0.10
AUDIT: ; (1 server found)
;; Got answer:
;; ->>HEADER<<- opcode: Query, status: No Error, id: 50769
;; flags: qr rd ra; QUERY: 1, ANSWER: 20, AUTHORITY: 0, ADDITIONAL: 11

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; UDP: 4096; code: NoError
;; QUESTION SECTION:
bing.com.                               IN      ANY

;; ANSWER SECTION:
bing.com.                               30      IN      NS      ns1-204.azure-dns.com.
bing.com.                               30      IN      NS      ns2-204.azure-dns.net.
bing.com.                               30      IN      NS      ns3-204.azure-dns.org.
bing.com.                               30      IN      NS      ns4-204.azure-dns.info.
bing.com.                               30      IN      NS      dns1.p09.nsone.net.
bing.com.                               30      IN      NS      dns2.p09.nsone.net.
bing.com.                               30      IN      NS      dns3.p09.nsone.net.
bing.com.                               30      IN      NS      dns4.p09.nsone.net.
bing.com.                               30      IN      SOA     ns1-204.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 3600
bing.com.                               30      IN      TXT     "facebook-domain-verification=09yg8uzcfnqnlqekzsbwjxyy8rdck7"
bing.com.                               30      IN      TXT     "google-site-verification=OkRY8R261shK5B8uEwvsFZp9nQ2gRoHavGlruok1azc"
bing.com.                               30      IN      TXT     "v=msv1 t=6097A7EA-53F7-4028-BA76-6869CB284C54"
bing.com.                               30      IN      TXT     "v=spf1 include:spf.protection.outlook.com -all"
bing.com.                               30      IN      CAA     0 issue "digicert.com"
bing.com.                               30      IN      CAA     0 issue "globalsign.com"
bing.com.                               30      IN      CAA     0 issue "microsoft.com"
bing.com.                               30      IN      A       204.79.197.200
bing.com.                               30      IN      AAAA    2620:1ec:c11::200
bing.com.                               30      IN      A       13.107.21.200
bing.com.                               30      IN      MX      10 bing-com.mail.protection.outlook.com.

;; ADDITIONALS SECTION:
dns3.p09.nsone.net.                     30      IN      AAAA    2620:4d:4000:6259:7:9:0:3
ns2-204.azure-dns.net.                  30      IN      A       64.4.48.204
ns1-204.azure-dns.com.                  30      IN      A       40.90.4.204
dns2.p09.nsone.net.                     30      IN      A       198.51.45.9
ns1-204.azure-dns.com.                  30      IN      AAAA    2603:1061:0:700::cc
ns2-204.azure-dns.net.                  30      IN      AAAA    2620:1ec:8ec:700::cc
dns2.p09.nsone.net.                     30      IN      AAAA    2a00:edc0:6259:7:9::2
dns3.p09.nsone.net.                     30      IN      A       198.51.44.73
dns1.p09.nsone.net.                     30      IN      A       198.51.44.9
dns1.p09.nsone.net.                     30      IN      AAAA    2620:4d:4000:6259:7:9:0:1

;; Query time: 70 msec
;; SERVER: 10.96.0.10#53
;; WHEN: Wed Nov 16 08:09:14 Z 2022
;; MSG SIZE  rcvd: 1446

RECORD: bing.com. 30 IN NS ns1-204.azure-dns.com.
RECORD: bing.com. 30 IN NS ns2-204.azure-dns.net.
RECORD: bing.com. 30 IN NS ns3-204.azure-dns.org.
RECORD: bing.com. 30 IN NS ns4-204.azure-dns.info.
RECORD: bing.com. 30 IN NS dns1.p09.nsone.net.
RECORD: bing.com. 30 IN NS dns2.p09.nsone.net.
RECORD: bing.com. 30 IN NS dns3.p09.nsone.net.
RECORD: bing.com. 30 IN NS dns4.p09.nsone.net.
RECORD: bing.com. 30 IN SOA ns1-204.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 3600
RECORD: bing.com. 30 IN TXT "facebook-domain-verification=09yg8uzcfnqnlqekzsbwjxyy8rdck7"
RECORD: bing.com. 30 IN TXT "google-site-verification=OkRY8R261shK5B8uEwvsFZp9nQ2gRoHavGlruok1azc"
RECORD: bing.com. 30 IN TXT "v=msv1 t=6097A7EA-53F7-4028-BA76-6869CB284C54"
RECORD: bing.com. 30 IN TXT "v=spf1 include:spf.protection.outlook.com -all"
RECORD: bing.com. 30 IN CAA 0 issue "digicert.com"
RECORD: bing.com. 30 IN CAA 0 issue "globalsign.com"
RECORD: bing.com. 30 IN CAA 0 issue "microsoft.com"
RECORD: bing.com. 30 IN A 204.79.197.200
RECORD: bing.com. 30 IN AAAA 2620:1ec:c11::200
RECORD: bing.com. 30 IN A 13.107.21.200
RECORD: bing.com. 30 IN MX 10 bing-com.mail.protection.outlook.com.

<- End: NSLOOKUP bing.com 128.53ms
```
