# Exercise 3: Deploy the application to the Azure Kubernetes Service

## Estimated Duration: 90 Minutes

## Overview

In this exercise, you will be deploying your containerized web application to AKS (Azure Kubernetes Service) with the help of Key Vault Secrets and ACR where you have stored your containerized web application images. Also, you will be exploring two ways to deploy the app to AKS.

## Objectives

In this exercise, you will complete the following tasks:
- Task 1: Tunnel into the Azure Kubernetes Service cluster
- Task 2: Setup Key Vault & Secrets
- Task 3: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
- Task 4: Deploy a service & workload using kubectl

### Task 1: Tunnel into the Azure Kubernetes Service cluster  

This task will gather the information you need about your Azure Kubernetes Service cluster to connect to the cluster and execute commands to connect to the Kubernetes management dashboard from the cloud shell.

> **Note**: The following tasks should be executed in the **Command Prompt**.

1. Open a new command prompt as Administrator in your jump VM and log in to Azure with the below command **(1)**. Then a popup appears for _SignIn_ then choose **Work or school account (2)** and click on **Continue (3)**.
   
    ```bash
    az login
    ```
    ![](media/E3T1S1.png)

    > **Note:** If you face any error while running the 'az' command, then run the below command to install the Azure CLI and close the command prompt. Re-perform step 1 in a new command prompt as Administrator.

    ```bash
    choco install azure-cli
    ```
    > **Note:** If you are unable to see the pop for Signin minimize the command prompt to view the popup window.

1. On the **Sign into Microsoft Azure** tab, you will see the login screen, in that enter the following email/username and then click on **Next**. 

   * Email/Username: <inject key="AzureAdUserEmail"></inject>
   
     ![](media/GS3.png "Enter Email")
     
1. Now enter the following password and click on **Sign in**.

   * Password: <inject key="AzureAdUserPassword"></inject>
   
     ![](media/pass-1411.png "Enter Password")

     >**Note**: During sign-in, you may be prompted with a screen asking: "Automatically sign in to all desktop apps and websites on this device", Click **No, this app only**.

     ![](media/E3T1S4.png)

     > **Note:** After running `az login`, if you're prompted to select a **subscription** or **tenant**, simply press **Enter** to continue with the **default subscription** and tenant associated with your account.

     ![](media/E3T1S5.png)

1. Run the below command to set up the Kubernetes cluster connection using kubectl.

   ```bash
   az aks get-credentials -a --name contoso-traders-aks<inject key="DeploymentID" enableCopy="true"/> --resource-group ContosoTraders-<inject key="DeploymentID" enableCopy="true"/>
   ```
   
   ![](media/E3T1S2.png "open cmd")

1. Run a quick kubectl command to generate a list of nodes to verify if the setup is correct.

   ```bash
   kubectl get nodes
   ```

   ![In this screenshot of the console, kubectl get nodes has been typed and run at the command prompt, which produces a list of nodes.](media/E3T1S3.png "kubectl get nodes")   

### Task 2: Setup Key Vault & Secrets 

In this task, you will be generating a secret in the Key vault and creating the connection between AKS and the Key vault.

1. Navigate to the Azure portal, search for **Key Vault (1)** in the search bar, and select **Key Vaults (2)** from the list.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/E3T2S1-1411.png "Add a Namespace")

1. Then select **contosotraderskv<inject key="DeploymentID" enableCopy="false" />** **key vault** from the list.

1. Once you are in **contosotraderskv<inject key="DeploymentID" enableCopy="false" />** Key vault page, select **secrets** under Objects from the left side menu.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/E3T2S3-1411.png "Add a Namespace")
    
1. Now click on the **Generate/Import** button to create the new secret.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/E3T2S4-1411.png "Add a Namespace")
    
1. In the **Create a secret** pane, enter the following details:

   - Name: **mongodbconnection (1)**

   - Secret Value: Paste the connection string of Azure CosmosDB for the MongoDB account which you have copied in the previous exercise. **(2)**

   - Keep other values default and click on **Create (3)**
    
      ![](media/E3T2S5.1-1411.png)
      
      ![](media/E3T2S5.2-1411.png)
     
1. Open a new **Command Prompt** and run the below command to create a secret using kubectl. 

   ```sh
   kubectl create secret generic mongodbconnection --from-literal=mongodbconnection=mongodbconnection --namespace=contoso-traders
   ```
   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/3..1.png "Add a Namespace")
    
1. Navigate back to browser and open **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** AKS in Azure portal. Select **Configuration (1)** under **Kubernetes resources** from the left side menu and click on **Secrets (2)** section. Under **Secrets**, you should be able to see the newly created secret **(3)**. 

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/E3T2S7-1411.png "Add a Namespace")
     
#### Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="82002c3d-9752-46a4-aa50-92046ba685de" />

### Task 3: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
   
In this task, you will define a Kubernetes Service for your API to enable internal accessibility of the application within the Azure Kubernetes Service (AKS) cluster.

1. Navigate back to the **contosoTraders-<inject key="DeploymentID" />** resource group, and select the **contoso-traders-aks<inject key="DeploymentID" />** **(1)** Kubernetes service.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/E3T2S1.png "Add a Service")

1. We have already defined a new AKS **Namespaces (2)** for your API deployment. Going further, you will be using the **contoso-traders (3)** namespace only. 

    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/E3T2S2.png "Add a Service")

1. On the **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** resource page,  Select the **Services and ingresses (1)** blade then select **+ Create (2)** and click on **Apply a YAML (3)**. 
    
    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/E3T2S3.png "Add a Service")

1. In the **Apply with YAML** pane, paste the below YAML code, which creates a service in AKS. Make sure to replace the **_SUFFIX_** with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** **(1)** value in the YAML file then click on **Apply (2)**. 
    
    >**Info**: The below YAML script will create an AKS service inside the contoso-traders namespace that you have created in the previous steps. AKS Service is an abstract way to expose an application running on a set of Pods as a network service. 

    ```yaml
      #YAML Script
      apiVersion: v1
      kind: Service
      metadata:
        name: contoso-traders-products
        namespace: contoso-traders
        annotations:
          # TODO: Replace 'SUFFIX' in the next line with the DeploymentID value  
          service.beta.kubernetes.io/azure-dns-label-name: contoso-traders-productsSUFFIX
      spec:
        type: LoadBalancer
        ports:
          - port: 80
        selector:
          app: contoso-traders-products

      ```    
    ![Select workloads under Kubernetes resources.](media/E3T2S4.png "Select workloads under Kubernetes resources")

    >**Note:** While entering the YAML code, if you're prompted with suggestion **Draft with Copilot**, click the **Close** **(1)** button to dismiss it.

      ![](media/E3T2S4-N.png)

    >**Note:** Ensure that the indentation in your YAML script matches the format shown in the image to avoid errors.

1. Select **Workloads (1)** under the Kubernetes resources section, click on **+ Create (2)** and then choose **Apply a YAML (3)**.

    ![Select workloads under Kubernetes resources.](media/E3T2S5.png "Select workloads under Kubernetes resources")

1. In the **Apply with YAML** pane, paste the below YAML code, which creates a workload in AKS and click on **Apply (2)**. Make sure to replace the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/> (1)** value in the YAML file to update the LOGINSERVER name of the ACR instance.

    >**Info**: The below YAML file will create deployment pods in the namespace contoso-traders. A Kubernetes Deployment tells Kubernetes how to create or modify instances of the pods that hold a containerized application. Deployments can help to efficiently scale the number of replica pods, enable the rollout of updated code in a controlled manner, or roll back to an earlier deployment version if necessary.

   ```YAML
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: contoso-traders-products
     namespace: contoso-traders
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: contoso-traders-products
     template:
       metadata:
         labels:
           app: contoso-traders-products
       spec:
         nodeSelector:
           "kubernetes.io/os": linux
         containers:
           - name: contoso-traders-products
             # Note: The '{DeploymentID}' token will be substituted with the value of the ENVIRONMENT GitHub secret by the GitHub workflow.
             image: contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapiproducts:latest
             env:
               - name: KeyVaultEndpoint
                 valueFrom:
                   secretKeyRef:
                     name: contoso-traders-kv-endpoint
                     key: contoso-traders-kv-endpoint
               - name: ManagedIdentityClientId
                 valueFrom:
                   secretKeyRef:
                     name: contoso-traders-mi-clientid
                     key: contoso-traders-mi-clientid
             resources:
               requests:
                 cpu: 50m
                 memory: 64Mi
               limits:
                 cpu: 250m
                 memory: 256Mi
             ports:
               - containerPort: 3001
                 hostPort: 3001
                 protocol: TCP
   ```
     
    ![Selecting + Add to create a deployment.](media/E3T2S6.png "Selecting + Add to create a deployment")

1. After a few minutes, you will see the deployment listed, and it should be in a running state.

    ![Selecting + Add to create a deployment.](media/E3T2S7.png "Selecting + Add to create a deployment")
  
    > **Note:** If the deployment status shows as **0/1** or remains in a failed state (⚠️) instead of running, perform the following steps:

      ![](media/synp-an-l3-8.png)

    1. At the top of the Azure Portal, click on the **Cloud Shell (1)** icon to open the Azure Cloud Shell session.

        ![](media/synp-an-l3-4.png)
    
    1. In the **Welcome to Azure Cloud Shell** dialog, select **PowerShell** to proceed.

        ![](media/synp-an-l3-5.png)

    1. On the **Getting started** dialog:
       - Select **No storage account required (1)**.  
       - Choose your **Subscription (2)** from the drop-down list.  
       - Click **Apply (3)** to continue.  

          ![](media/synp-an-l3-6.png)

    1. In the Cloud Shell PowerShell session, run the following command to set the Deployment ID:

        ```powershell
        $deploymentId = "<inject key="DeploymentID" enableCopy="true"/>"
        ```

        ![](media/synp-an-l3-7.png)
    
    1. Run the following PowerShell commands in the Cloud Shell to configure the required resources and restart the deployment:

        ```powershell
        $RESOURCE_GROUP_NAME = "contosotraders-$deploymentId"
        $AKS_CLUSTER_NAME = "contoso-traders-aks$deploymentId"
        $KV_NAME = "contosotraderskv$deploymentId"
        $USER_ASSIGNED_MANAGED_IDENTITY_NAME = "contoso-traders-mi-kv-access$deploymentId"
        $AKS_NODES_RESOURCE_GROUP_NAME = "contoso-traders-aks-nodes-rg-$deploymentId"
      
        $vmssName = $(az vmss list -g $AKS_NODES_RESOURCE_GROUP_NAME --query "[0].name" -o tsv)
        if (-not $vmssName) { Write-Host "VMSS not found." -ForegroundColor Red; exit }
      
        $identityId = $(az identity show --name $USER_ASSIGNED_MANAGED_IDENTITY_NAME --resource-group $RESOURCE_GROUP_NAME --query "id" -o tsv)
        if (-not $identityId) { Write-Host "Managed Identity not found." -ForegroundColor Red; exit }
      
        $assignedIdentities = $(az vmss identity show -g $AKS_NODES_RESOURCE_GROUP_NAME -n $vmssName --query "userAssignedIdentities" -o json)
        if ($assignedIdentities -notlike "*$identityId*") {
            az vmss identity assign --name $vmssName --resource-group $AKS_NODES_RESOURCE_GROUP_NAME --identities $identityId
        }
      
        $principalId = $(az identity show --name $USER_ASSIGNED_MANAGED_IDENTITY_NAME --resource-group $RESOURCE_GROUP_NAME --query "principalId" -o tsv)
        $policyCheck = $(az keyvault show --name $KV_NAME --query "properties.accessPolicies[?objectId=='$principalId' && permissions.secrets[?@=='get' || @=='list']].permissions.secrets" -o json)
        if ($policyCheck -notlike "*get*" -or $policyCheck -notlike "*list*") {
            az keyvault set-policy --name $KV_NAME --secret-permissions get list --object-id $principalId
        }
      
        az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_CLUSTER_NAME --overwrite-existing
        kubectl rollout restart deployment contoso-traders-products -n contoso-traders
        ```
      1. Wait for **2–3 minutes** to allow the deployment status to update. 

#### Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="b5e74d42-1932-4a01-b1dd-65b27583fdda" />

### Task 4: Deploy a service & workload using kubectl

In this task, you will deploy the web service & its workload using kubectl.

1. Open a **File Explorer** from your JumpVM.

1. Navigate to `C:\LabFiles` **(1)** directory and select `web.deployment.yml` **(2)** file. Right-click and select **Open** **(3)** to open the file in VS code.

     ![](media/E3T3S2.png)

1. Make sure to Update the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file to match the name of your ACR Login Server.

     ![In this screenshot of the Azure Cloud Shell editor window, the ... button has been selected and the Close Editor option is highlighted.](media/cloudnative7.png "Close Azure Cloud Editor")

1. Save the changes by **CTRL + S** button to **Save**.

1. Navigate back to the Windows command prompt and run the below command to change the directory to the `~/LabFiles` folder.

      ```bash
      cd C:/LabFiles
      ```
   
1. If you are not logged into Azure, log in to Azure with the command below **(1)**.Then a popup appears for _SignIn_ then choose **Work or school account (2)** and click on **Continue (3)**.
    ```
    az login 
    ```
    ![](media/E4T4S1.png)

    > **Note:** If you are unable to see the pop for Signin minimize the command prompt to view the popup window.

1. On the **Sign into Microsoft Azure** tab, you will see the login screen, in that enter the following email/username and then click on **Next**. 

   * Email/Username: <inject key="AzureAdUserEmail"></inject>
   
     ![](media/GS3.png "Enter Email")
     
1. Now enter the following password and click on **Sign in**.

   * Password: <inject key="AzureAdUserPassword"></inject>
   
     ![](media/pass-1411.png "Enter Password")

     >**Note**: During sign-in, you may be prompted with a screen asking: "Automatically sign in to all desktop apps and websites on this device", Click **No, this app only**. 

     ![](media/E3T1S4.png)

     > **Note:** After running `az login`, if you're prompted to select a **subscription** or **tenant**, simply press **Enter** to continue with the **default subscription** and tenant associated with your account.

     ![](media/E4T1S1.png)

1. Execute the below command to deploy the application described in the YAML files. You will receive a message indicating the item `kubectl` has created a web deployment and a web service.
   
     >**Info**: The below kubectl command will create the Deployment workload and Service into the namespace that we have defined in the YAML files. 

      ```bash
      kubectl create --save-config=true -f web.deployment.yml -f web.service.yml 
      ```

     ![In this screenshot of the console, kubectl apply -f kubernetes-web.yaml has been typed and run at the command prompt. Messages about web deployment and web service creation appear below.](media/kubectlcreated.png "kubectl create application")

1. Return to the AKS blade in the Azure Portal. From the navigation menu, select the **Services and ingresses (1)** under **Kubernetes resources**. You should be able to access the website via an **External endpoint (2)**.

    ![AKS services and ingresses shown with External IP highlighted](media/E3T3S8.png "AKS services and ingresses shown with External IP highlighted")

    ![AKS services and ingresses shown with External IP highlighted](media/website2--new.png "AKS services and ingresses shown with External IP highlighted")

     > **Note:** If the website doesn't load, try refreshing the page several times as it might take a while for AKS to populate the website.

#### Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="be8d94ad-c9e2-4a96-8d29-e675fb17dbea" />

## Summary

In this exercise, you have deployed your containerized web application to AKS that contains, the namespace, service, and workload in Azure Kubernetes. Also, you have created a service to AKS and accessed the website using an external endpoint. Also, you have set up the secret of the key vault to access the MongoDB from AKS. 

### You have successfully completed the exercise. Click on the Next button.

![](./media/next-1411.png)
