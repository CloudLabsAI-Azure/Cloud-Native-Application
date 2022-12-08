Set-ExecutionPolicy -ExecutionPolicy bypass -Force
Start-Transcript -Path C:\WindowsAzure\Logs\extensionlog.txt -Append
Write-Host "Logon-task-started" 

$DeploymentID = $env:DeploymentID

Start-Process C:\Packages\extensions.bat
Write-Host "Bypass-Execution-Policy"


choco install docker-desktop --version=4.7.0
Write-Host "Docker-install"

[Environment]::SetEnvironmentVariable("Path", $env:Path+";C:\Users\demouser\AppData\Roaming\npm\node_modules\azure-functions-core-tools\bin","User")

. C:\LabFiles\AzureCreds.ps1

$user = $AzureUserName

$password = $AzurePassword

$deploymentid = $env:DeploymentID


choco install bicep
Install-Module Sqlserver -SkipPublisherCheck -Force
Import-Module Sqlserver
az config set extension.use_dynamic_install=yes_without_prompt

#Download lab files
cd C:\

#create directory and clone bicep templates

mkdir C:\Workspaces
cd C:\Workspaces
mkdir lab
cd lab

git clone --branch main https://github.com/shivashant25/aiw-devops-with-github-lab-files.git

Sleep 5

$path = "C:\Workspaces\lab\aiw-devops-with-github-lab-files\iac"
(Get-Content -Path "$path\createResources.parameters.json") | ForEach-Object {$_ -Replace "802322", "$DeploymentID"} | Set-Content -Path "$path\createResources.parameters.json"

$path = "C:\Workspaces\lab\aiw-devops-with-github-lab-files\src\ContosoTraders.Ui.Website\src\services"
(Get-Content -Path "$path\configService.js") | ForEach-Object {$_ -Replace "deploymentidvalue", "$DeploymentID"} | Set-Content -Path "$path\configService.js"

$path = "C:\Workspaces\lab\aiw-devops-with-github-lab-files\iac"
(Get-Content -Path "$path\createResources.parameters.json") | ForEach-Object {$_ -Replace "bicepsqlpass", "$password"} | Set-Content -Path "$path\createResources.parameters.json"

Sleep 5

#Az login

. C:\LabFiles\AzureCreds.ps1

$userName = $AzureUserName
$password = $AzurePassword
$subscriptionId = $AzureSubscriptionID
$TenantID = $AzureTenantID


$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $userName, $SecurePassword

Connect-AzAccount -Credential $cred | Out-Null


cd C:\Workspaces\lab\aiw-devops-with-github-lab-files\iac

$RGname = "contoso-traders-$deploymentid"

New-AzResourceGroupDeployment -Name "createresources" -TemplateFile "createResources.bicep" -TemplateParameterFile "createResources.parameters.json" -ResourceGroup $RGname

$AKS_CLUSTER_NAME = "contoso-traders-aks$deploymentid"
$AKS_NODES_RESOURCE_GROUP_NAME = "contoso-traders-aks-nodes-rg"
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







az login -u $userName -p  $password
cd C:\Workspaces\lab\aiw-devops-with-github-lab-files
  
Invoke-Sqlcmd -InputFile ./src/ContosoTraders.Api.Products/Migration/productsdb.sql -Database productsdb -Username "localadmin" -Password $password -ServerInstance $server -ErrorAction 'Stop' -Verbose -QueryTimeout 1800 # 30min


az aks get-credentials -g $RESOURCE_GROUP_NAME -n $AKS_CLUSTER_NAME

az aks update -n $AKS_CLUSTER_NAME -g $RESOURCE_GROUP_NAME --attach-acr /subscriptions/$subscriptionId/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.ContainerRegistry/registries/contosotradersacr$deploymentid


az keyvault set-policy -n $KV_NAME --key-permissions get list  --object-id $(az ad user show --id $(az account show --query "user.name" -o tsv) --query "id" -o tsv)

az keyvault set-policy -n $KV_NAME  --secret-permissions get list --object-id $(az identity show --name "$AKS_CLUSTER_NAME-agentpool" -g $AKS_NODES_RESOURCE_GROUP_NAME --query "principalId" -o tsv)

az storage blob sync --account-name $STORAGE_ACCOUNT_NAME -c $PRODUCT_DETAILS_CONTAINER_NAME -s 'src/ContosoTraders.Api.Images/product-details'

az storage blob sync --account-name $STORAGE_ACCOUNT_NAME -c $PRODUCT_LIST_CONTAINER_NAME -s 'src/ContosoTraders.Api.Images/product-list'

az cdn endpoint purge --no-wait --content-paths '/*' -n $PRODUCTS_CDN_ENDPOINT_NAME -g $RESOURCE_GROUP_NAME --profile-name $CDN_PROFILE_NAME




sleep 20

sleep 5
Unregister-ScheduledTask -TaskName "Installdocker" -Confirm:$false 
Restart-Computer -Force 
