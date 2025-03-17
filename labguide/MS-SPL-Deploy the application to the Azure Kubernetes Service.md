## Hands-On-Lab: Deploy the application to the Azure Kubernetes Service
   
**Duration**: 40 Minutes

## Overview

In this exercise, you will be deploying your containerized web application to AKS (Azure Kubernetes Service) with the help of Key Vault secrets and ACR where you have stored your containerized web application images. Also, you will be exploring two ways to deploy the app to AKS. 

## Objectives

In this Exercise, you will be able to complete the following tasks:

- Task 1: Tunnel into the Azure Kubernetes Service cluster
- Task 2: Setup Key Vault & Secrets
- Task 3: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
- Task 4: Deploy a service & workload using kubectl

### Task 1: Tunnel into the Azure Kubernetes Service cluster  

This task will gather the information you need about your Azure Kubernetes Service cluster to connect to the cluster and execute commands to connect to the Kubernetes management dashboard from the cloud shell.

> **Note**: The following tasks should be executed in the command prompt.

1. In the LabVM, search for **cmd (1)**, right click on the **Command prompt (1)** then select **Run as administrator (3)**.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn28.png "Add a Namespace")

1. Login to azure with the below commands after updating the values in the below command.

   * Username: **<inject key="AzureAdUserEmail"></inject>**
   * Password: **<inject key="AzureAdUserPassword"></inject>**
   
    ```bash
    az login -u [username] -p [Password]
    ```

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn29.png "Add a Namespace")    
    
    > **Note:** If you face any error while running the 'az' command, then run the below command to install the azure cli and close the command prompt. Re-perform the step-1 in a new command prompt as Administrator.

    ```bash
    choco install azure-cli
    ```

1. Verify that you are connected to the correct subscription with the following command to show your default subscription:

   ```bash
   az account show
   ```

   - Ensure you are connected to the correct subscription. If not, list your subscriptions and then set the subscription by its ID with the following commands:

   ```bash
   az account list
   az account set --subscription {id}
   ```

1. Run the below command to set up the Kubernetes cluster connection using kubectl. 

   ```bash
   az aks get-credentials -a --name contoso-traders-aks<inject key="DeploymentID" enableCopy="true"/> --resource-group ContosoTraders-<inject key="DeploymentID" enableCopy="true"/>
   ```

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn30.png "Add a Namespace")

1. Run a quick kubectl command to generate a list of nodes to verify if the setup is correct.

   ```bash
   kubectl get nodes
   ```

   ![In this screenshot of the console, kubectl get nodes has been typed and run at the command prompt, which produces a list of nodes.](media/cn31.png "kubectl get nodes")   

### Task 2: Setup Key Vault & Secrets 

In this task, you will be generating a secret in the Key vault and creating the connection between AKS and the Key vault.

1. Navigate to the Azure portal, search for **Key Vault (1)** in the search bar, and select **Key vaults (2)** from the list.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn32.png "Add a Namespace")

1. Then select **contosotraderskv<inject key="DeploymentID" enableCopy="false" />** **Key vaults** from the list.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn33.png "Add a Namespace")

1. Once you are in **contosotraderskv<inject key="DeploymentID" enableCopy="false" />** Key vault page, select **Secrets** under **Objects** from the left side menu.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn35.png "Add a Namespace")
    
1. Now click on the **Generate/Import** button to create the new secret.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn36.png "Add a Namespace")
    
1. In the **Create a secret** pane, enter the following details:

    - Option: **Manual (1)**
    - Name: **mongodbconnection (2)**
    - Secret Value: Paste the connection string of Azure CosmosDB for the MongoDB account which you have copied in the previous exercise **(3)**
    - Keep other values default and click on **Create (4)**
    
      ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn37.png "Add a Namespace")
     
      ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn38.png "Add a Namespace")
     
1. Open a new **Command Prompt** and run the below command to create a secret using kubectl. 

    ```sh
    kubectl create secret generic mongodbconnection --from-literal=mongodbconnection=mongodbconnection --namespace=contoso-traders
    ```
    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn39.png "Add a Namespace")

1. Navigate back to **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />** resource group. Search for **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/> (1)** and select **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/> (2)** Kuberbate service. 

     ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn40.png "Add a Namespace")
    
1. Select **Configuration (1)** from the left side menu under **Kubernate resources** and click on **Secrets (2)** section. Under secrets, you should be able to see the newly created secret. **(3)** 

     ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn50.png "Add a Namespace")

<validation step="1b891637-68ff-4196-9cf4-bda153c619e8" />

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.   
     

### Task 3: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
   
In this task, you will deploy the API Carts application to the Azure Kubernetes Service cluster using the Azure Portal.
   
1. Select **Namedpace (1)** from the left side menu under **Kubernate resources**. We have already defined a new Namespace for your API deployment. Going further you will be using the **contoso-traders (2)** namespace only. 

    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/cn41.png "Add a Service")
    
3. Define a Service for your API, so that the application is accessible within the cluster. Select the **Services and ingresses (1)** blade of the **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** AKS resource detail page in the Azure Portal. In the Services tab, select **+ Create (2)** and choose **Apply a YAML (3)**. 
    
    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/cn42.png "Add a Service")

1. In the **Apply with YAML** pane, paste the below YAML code which creates a service in AKS **(1)** and click on **Add (2)**. Make sure to replace the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file.

    >**Info**: The below YAML script will create an AKS service inside the contoso-traders namespace that you have created in previous steps. AKS Service is an abstract way to expose an application running on a set of Pods as a network service. 

    ```yaml
      #YAML Script
      apiVersion: v1
      kind: Service
      metadata:
        name: contoso-traders-products
        namespace: contoso-traders
        annotations:
          # TODO: Replace 'SUFFIX' in the next line with whatever your ENVIRONMENT GitHub secret value is
          service.beta.kubernetes.io/azure-dns-label-name: contoso-traders-productsSUFFIX
      spec:
        type: LoadBalancer
        ports:
          - port: 80
        selector:
          app: contoso-traders-products

      ```     
      ![Select workloads under Kubernetes resources.](media/cn43.png "Select workloads under Kubernetes resources") 

1. Select **Workloads (1)** under the Kubernetes resources section in the left navigation. With **Deployments** selected by default, select **+ Create (2)** and then choose **Apply a YAML (3)**.

    ![Select workloads under Kubernetes resources.](media/cn44.png "Select workloads under Kubernetes resources")

1. In the **Apply with YAML** pane, paste the below YAML code which creates a workload in AKS **(1)** and click on **Add (2)**. Make sure to replace the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file to update the LOGINSERVER name of the ACR instance.

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
             # Note: The '{ENVIRONMENT}' token will be substituted with the value of the ENVIRONMENT GitHub secret by the GitHub workflow.
             image: contosotradersacrSUFFIX.azurecr.io/contosotradersapiproducts:latest
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

   ![Selecting + Add to create a deployment.](media/cn45.png "Selecting + Add to create a deployment")

1. After a few minutes, you will see the deployment listed and it should be in a running state.

   ![Selecting + Add to create a deployment.](media/cn-46.png "Selecting + Add to create a deployment")

<validation step="2c2f2fd6-1915-41f8-967b-002771fded11" />

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.      


### Task 4: Deploy a service & workload using kubectl

In this task, you will deploy the web service & its workload using kubectl.

1. Open a **File Explorer** from your JumpVM.

1. Navigate to `C:\LabFiles` **(1)** directory and select `web.deployment.yml` **(2)** file. Right-click and select **Open** **(3)** to open the file in VS code.

   ![](media/cn47.png)

1. Make sure to Update the **SUFFIX** with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file to match the name of your ACR Login Server.

    ![In this screenshot of the Azure Cloud Shell editor window, the ... button has been selected and the Close Editor option is highlighted.](media/sfx.png "Close Azure Cloud Editor")

1. Save the changes by **CTRL + S** button to **Save**.

1. Navigate back to the Windows command prompt and run the below command to change the directory to the `~/LabFiles` folder.

    ```bash
    cd C:/LabFiles
    ```

1. Log in to Azure if not already done with the below command after updating the values in the command.

   * Username: **<inject key="AzureAdUserEmail"></inject>**
   * Password: **<inject key="AzureAdUserPassword"></inject>**

    ```
    az login -u [username] -p [Password]
    ```

1. Execute the below command to deploy the application described in the YAML files. You will receive a message indicating the item `kubectl` has created a web deployment and a web service.
   >**Info**: The below kubectl command will create the Deployment workload and Service into the namespace that we have defined in the YAML files. 

    ```bash
    kubectl create --save-config=true -f web.deployment.yaml -f web.service.yaml 
    ```

    ![In this screenshot of the console, kubectl apply -f kubernetes-web.yaml has been typed and run at the command prompt. Messages about web deployment and web service creation appear below.](media/cn48.png "kubectl create application")

1. Return to the AKS blade in the Azure Portal. From the navigation menu, select the **Services and ingresses (1)** under **Kubernetes resources**. You should be able to access the website via an **External endpoint (2)**.

    ![AKS services and ingresses shown with External IP highlighted](media/cn49.png "AKS services and ingresses shown with External IP highlighted")

    ![AKS services and ingresses shown with External IP highlighted](media/website2.png "AKS services and ingresses shown with External IP highlighted")
    

<validation step="dc9360a0-566b-4238-99c7-4ef2fbc66bd1" />

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.   

## Summary

In this exercise, you have deployed your containerized web application to AKS that contains, the namespace, service, and workload in Azure Kubernetes. Also, you have created a service to AKS and accessed the website using an external endpoint. Also, you have set up the secret of the key vault to access the MongoDB from AKS.
