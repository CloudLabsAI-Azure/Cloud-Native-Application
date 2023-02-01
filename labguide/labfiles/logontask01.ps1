Set-ExecutionPolicy -ExecutionPolicy bypass -Force
Start-Transcript -Path C:\WindowsAzure\Logs\extensionlog.txt -Append
Write-Host "Logon-task-started" 

$DeploymentID = $env:DeploymentID

Start-Process C:\Packages\extensions.bat
Write-Host "Bypass-Execution-Policy"



. C:\LabFiles\AzureCreds.ps1

$user = $AzureUserName

$password = $AzurePassword

$deploymentid = $env:DeploymentID

$AppID = $env:AppID

$AppSecret = $env:AppSecret
Set-ExecutionPolicy -ExecutionPolicy bypass -Force
Start-Transcript -Path C:\WindowsAzure\Logs\extensionlog.txt -Append
Write-Host "Logon-task-started" 

$DeploymentID = $env:DeploymentID



. C:\LabFiles\AzureCreds.ps1

$user = $AzureUserName

$password = $AzurePassword

$deploymentid = $env:DeploymentID

choco install bicep
Install-Module Sqlserver -SkipPublisherCheck -Force
Import-Module Sqlserver
choco install kubernetes-cli
choco install kubernetes-helm
az config set extension.use_dynamic_install=yes_without_prompt

#Download lab files
cd C:\

#create directory and clone bicep templates

mkdir C:\Workspaces
cd C:\Workspaces
mkdir lab
cd lab

git clone  https://github.com/CloudLabsAI-Azure/Cloud-Native-Application

Sleep 5
$path = "C:\Workspaces\lab\Cloud-Native-Application\labfiles\iac"
(Get-Content -Path "$path\createResources.parameters.json") | ForEach-Object {$_ -Replace "802322", "$DeploymentID"} | Set-Content -Path "$path\createResources.parameters.json"


(Get-Content -Path "$path\createResources.parameters.json") | ForEach-Object {$_ -Replace "bicepsqlpass", "$password"} | Set-Content -Path "$path\createResources.parameters.json"

Sleep 5

#Az login

. C:\LabFiles\AzureCreds.ps1

$userName = $AzureUserName
$password = $AzurePassword
$subscriptionId = $AzureSubscriptionID
$TenantID = $AzureTenantID


$securePassword = $AppSecret | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AppID, $SecurePassword

Login-AzAccount -ServicePrincipal -Credential $cred -Tenant $AzureTenantID | Out-Null


cd C:\Workspaces\lab\Cloud-Native-Application\labfiles\iac

$RGname = "contosotraders-$deploymentid"

New-AzResourceGroupDeployment -Name "createresources" -TemplateFile "createResources.bicep" -TemplateParameterFile "createResources.parameters.json" -ResourceGroup $RGname

$AKS_CLUSTER_NAME = "contoso-traders-aks$deploymentid"

$AKS_NODES_RESOURCE_GROUP_NAME = "contoso-traders-aks-nodes-rg-$deploymentid"

$CDN_PROFILE_NAME = "contoso-traders-cdn$deploymentid"
$SUB_DEPLOYMENT_REGION = "eastus"
$KV_NAME = "contosotraderskv$deploymentid"
$PRODUCTS_DB_NAME = "productsdb"
$PRODUCTS_DB_SERVER_NAME = "contoso-traders-products"
$PRODUCTS_DB_USER_NAME = "localadmin"
$PRODUCT_DETAILS_CONTAINER_NAME = "product-details"
$PRODUCT_IMAGES_STORAGE_ACCOUNT_NAME = "contosotradersimg"
$PRODUCT_LIST_CONTAINER_NAME = "product-list"
$PRODUCTS_CDN_ENDPOINT_NAME = "contoso-traders-images$deploymentid"
$RESOURCE_GROUP_NAME = "contosotraders-$deploymentid"
$STORAGE_ACCOUNT_NAME = "contosotradersimg$deploymentid"
$server = "contoso-traders-products$deploymentid.database.windows.net"

$USER_ASSIGNED_MANAGED_IDENTITY_NAME = "contoso-traders-mi-kv-access$deploymentID"




$userName = $AzureUserName
$password = $AzurePassword
$subscriptionId = $AzureSubscriptionID
$TenantID = $AzureTenantID


az login  -u $userName -p  $password -t $AzureTenantID



az keyvault set-policy -n $KV_NAME --key-permissions get list create --secret-permissions set get list  --object-id $(az ad user show --id $(az account show --query "user.name" -o tsv) --query "id" -o tsv)

        az logout



az login --service-principal -u $AppID -p  $AppSecret -t $AzureTenantID
cd C:\Workspaces\lab\Cloud-Native-Application\labfiles

az aks get-credentials -g $RESOURCE_GROUP_NAME -n $AKS_CLUSTER_NAME

kubectl create namespace contoso-traders

az identity create -g $RESOURCE_GROUP_NAME --name $USER_ASSIGNED_MANAGED_IDENTITY_NAME

$objectID = "$(az identity show -g $RESOURCE_GROUP_NAME --name $USER_ASSIGNED_MANAGED_IDENTITY_NAME --query "clientId" -o tsv)"
      $obj2 = "$(az identity show -g $RESOURCE_GROUP_NAME --name $USER_ASSIGNED_MANAGED_IDENTITY_NAME --query "principalId" -o tsv)"
      az vmss identity assign --identities $(az identity show -g $RESOURCE_GROUP_NAME  --name $USER_ASSIGNED_MANAGED_IDENTITY_NAME  --query "id" -o tsv) --ids $(az vmss list -g $AKS_NODES_RESOURCE_GROUP_NAME  --query "[0].id" -o tsv) 
      az keyvault set-policy -n $KV_NAME  --secret-permissions get list --object-id $objectID 
            az keyvault set-policy -n $KV_NAME  --secret-permissions get list --object-id $obj2 

kubectl create secret generic contoso-traders-kv-endpoint --from-literal=contoso-traders-kv-endpoint="https://$KV_NAME.vault.azure.net/" -n contoso-traders





kubectl create secret generic contoso-traders-mi-clientid --from-literal=contoso-traders-mi-clientid=$objectID -n contoso-traders






az aks update -n $AKS_CLUSTER_NAME -g $RESOURCE_GROUP_NAME --attach-acr /subscriptions/$subscriptionId/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.ContainerRegistry/registries/contosotradersacr$deploymentid


az keyvault set-policy -n $KV_NAME --key-permissions get list  --object-id $(az ad user show --id $(az account show --query "user.name" -o tsv) --query "id" -o tsv)

az keyvault set-policy -n $KV_NAME  --secret-permissions get list --object-id $(az identity show --name "$AKS_CLUSTER_NAME-agentpool" -g $AKS_NODES_RESOURCE_GROUP_NAME --query "principalId" -o tsv)

az storage blob sync --account-name $STORAGE_ACCOUNT_NAME -c $PRODUCT_DETAILS_CONTAINER_NAME -s 'src/ContosoTraders.Api.Images/product-details'

az storage blob sync --account-name $STORAGE_ACCOUNT_NAME -c $PRODUCT_LIST_CONTAINER_NAME -s 'src/ContosoTraders.Api.Images/product-list'

#az cdn endpoint purge --no-wait --content-paths '/*' -n $PRODUCTS_CDN_ENDPOINT_NAME -g $RESOURCE_GROUP_NAME --profile-name $CDN_PROFILE_NAME



  
Invoke-Sqlcmd -InputFile ./src/ContosoTraders.Api.Products/Migration/productsdb.sql -Database productsdb -Username "localadmin" -Password $password -ServerInstance $server -ErrorAction 'Stop' -Verbose -QueryTimeout 1800 # 30min


sleep 20

sleep 5


$commonscriptpath = "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.14\Downloads\0\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath

. C:\LabFiles\AzureCreds.ps1
$TenantID = $AzureTenantID

$securePassword = $AppSecret | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AppID, $SecurePassword

Login-AzAccount -ServicePrincipal -Credential $cred -Tenant $AzureTenantID | Out-Null


$RGname = "contosotraders-$deploymentid"

$RG1 = Get-AzResourceGroupDeployment -Name "createresources" -ResourceGroupName $RGname

$cluster = Get-AzAksCluster

$cluster.ProvisioningState

$RG1 = $cluster.ProvisioningState
$deploymentstatus = $RG1

if($deploymentstatus -eq 'Succeeded')
{
    Write-Information "Validation Passed"
    
    $validstatus = "Successfull"
}
else {
    Write-Warning "Validation Failed - see log output"
    $validstatus = "Failed"
      }

Function SetDeploymentStatus($ManualStepStatus, $ManualStepMessage)
{

    (Get-Content -Path "C:\WindowsAzure\Logs\status-sample.txt") | ForEach-Object {$_ -Replace "ReplaceStatus", "$ManualStepStatus"} | Set-Content -Path "C:\WindowsAzure\Logs\validationstatus.txt"
    (Get-Content -Path "C:\WindowsAzure\Logs\validationstatus.txt") | ForEach-Object {$_ -Replace "ReplaceMessage", "$ManualStepMessage"} | Set-Content -Path "C:\WindowsAzure\Logs\validationstatus.txt"
}
 if ($validstatus -eq "Successfull") {
    $ValidStatus="Succeeded"
    $ValidMessage="Environment is validated and the deployment is successful"


      }
else {
    Write-Warning "Validation Failed - see log output"
    $ValidStatus="Failed"
    $ValidMessage="Environment Validation Failed and the deployment is Failed"
      } 
 SetDeploymentStatus $ValidStatus $ValidMessage
#Start the cloudlabs agent service 
CloudlabsManualAgent Start     

Unregister-ScheduledTask -TaskName "Installdocker" -Confirm:$false 

Restart-Computer -Force 
