## Overview

In this exercise, you will be deploying your containerized web application to AKS (Azure Kubernetes Service) with the help of Key Vault Secrets and ACR where you have stored your containerized web application images. Also, you will be exploring two ways to deploy the app to AKS.

## Exercise 3: Deploy the application to the Azure Kubernetes Service
   
**Duration**: 90 Minutes 

### Task 1: Tunnel into the Azure Kubernetes Service cluster  

This task will gather the information you need about your Azure Kubernetes Service cluster to connect to the cluster and execute commands to connect to the Kubernetes management dashboard from the cloud shell.

> **Note**: The following tasks should be executed in the **Command Prompt**.

1. Open a new command prompt as Administrator in your jump VM and login to Azure with the below commands after updating the values in the below command.

- Username: **<inject key="AzureAdUserEmail"></inject>**
- Password: **<inject key="AzureAdUserPassword"></inject>**

   ```bash
   az login -u [username] -p [Password]
   ```   
    
  > **Note:** If you face any error while running the 'az' command, then run the below command to install the azure cli and close the command prompt. Re-perform step-1 in a new command prompt as Administrator.

   ```bash
   choco install azure-cli
   ```
   
2. Verify that you are connected to the correct subscription with the following command to show your default subscription:

   ```bash
   az account show
   ```

- Ensure you are connected to the correct subscription. If not, list your subscriptions and then set the subscription by its ID with the following commands:

   ```bash
   az account list
   az account set --subscription {id}
   ```

3. Run the below command to set up the Kubernetes cluster connection using kubectl.

   ```bash
   az aks get-credentials -a --name contoso-traders-aks<inject key="DeploymentID" enableCopy="true"/> --resource-group ContosoTraders-<inject key="DeploymentID" enableCopy="true"/>
   ```
   
   ![](media/cloudnative4.png "open cmd")

4. Run a quick kubectl command to generate a list of nodes to verify if the setup is correct.

   ```bash
   kubectl get nodes
   ```

   ![In this screenshot of the console, kubectl get nodes has been typed and run at the command prompt, which produces a list of nodes.](media/cloudnative5.png "kubectl get nodes")   

### Task 2: Setup Key Vault & Secrets 

In this task, you will be generating a secret in the Key vault and creating the connection between AKS and the Key vault.

1. Navigate to the Azure portal, search for **Key Vault** in the search bar, and select **Key Vaults** from the list.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cloudnative9.png "Add a Namespace")

2. Then select **contosotraderskv<inject key="DeploymentID" enableCopy="false" />** **Key vault** from the list.

3. Once you are in **contosotraderskv<inject key="DeploymentID" enableCopy="false" />** Key vault page, select **secrets** under Objects from the left side menu.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/kv2.png "Add a Namespace")
    
4. Now click on the **Generate/Import** button to create the new secret.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/kv3.png "Add a Namespace")
    
5. In the **Create a secret** pane, enter the following details:

- Name: **mongodbconnection**

- Secret Value: Paste the connection string of Azure CosmosDB for the MongoDB account which you have copied in the previous exercise.

- Keep other values default and click on **Create**
    
   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/mongodbconnection.jpg "Add a Namespace")
      
   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/kv5.png "Add a Namespace")
     
6. Open a new **Command Prompt** and run the below command to create a secret using kubectl. 

   ```sh
   kubectl create secret generic mongodbconnection --from-literal=mongodbconnection=mongodbconnection --namespace=contoso-traders
   ```
   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/3..1.png "Add a Namespace")
    
7. Navigate back to browser and open **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** AKS in Azure portal, select **Configuration** from the left side menu and click on **Secrets** section. Under **Secrets**, you should be able to see the newly created secret. 

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/aksfinal.png "Add a Namespace")
     
#### Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="82002c3d-9752-46a4-aa50-92046ba685de" />

### Task 3: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
   
In this task, you will deploy the API Carts application to the Azure Kubernetes Service cluster using the Azure Portal.
   
1. We have already defined a new Namespace for your API deployment. Going further you will be using the **contoso-traders** namespace only. 

    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/newnamespaces.png "Add a Service")
    
2. Define a Service for your API, so that the application is accessible within the cluster. Select the **Services and ingresses** blade of the **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** AKS resource detail page in the Azure Portal. In the Services tab, select **+ Create** and choose **Apply a YAML**. 
    
    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/CNV2-E3-T3-S3new.png "Add a Service")

3. In the **Add with YAML** pane, paste the below YAML code which creates a service in AKS and click on **Add**.
   
     >**Info**: The below YAML script will create an AKS service inside the contoso-traders namespace that you have created in previous steps. AKS Service is an abstract way to expose an application running on a set of Pods as a network service. 

       ```yaml
       apiVersion: v1
       kind: Service
       metadata:
         name: contoso-traders-products
         namespace: contoso-traders
         annotations:
           #@TODO: Replace 'SUFFIX' in the next line with whatever your ENVIRONMENT GitHub secret value is
           service.beta.kubernetes.io/azure-dns-label-name: contoso-traders-productsSUFFIX
       spec:
         type: LoadBalancer
         ports:
           - port: 80
         selector:
           app: contoso-traders-products
       ```

      ![Select workloads under Kubernetes resources.](media/ex3-t3-servicecreate.png "Select workloads under Kubernetes resources") 

4. Select **Workloads** under the Kubernetes resources section in the left navigation. With **Deployments** selected by default, select **+ Create** and then choose **Apply a YAML**.

     ![Select workloads under Kubernetes resources.](media/CNV2-E3-T3-S5.png "Select workloads under Kubernetes resources")

5. In the **Add with YAML** pane, paste the below YAML code which creates a workload in AKS and click on **Add**.
   
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
             #Note: The '{ENVIRONMENT}' token will be substituted with the value of the ENVIRONMENT github secret by github workflow.
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

     ![Selecting + Add to create a deployment.](media/ex3-t3-workloadsadd.png "Selecting + Add to create a deployment")

6. After a few minutes, you will see the deployment listed, which should be running.

     ![Selecting + Add to create a deployment.](media/conrunning.png "Selecting + Add to create a deployment")

#### Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="b5e74d42-1932-4a01-b1dd-65b27583fdda" />

### Task 4: Deploy a service & workload using kubectl

In this task, you will deploy the web service & its workload using kubectl.

1. Open a **File Explorer** from your JumpVM.

2. Navigate to `C:\LabFiles` **(1)** directory and select `web.deployment.yml` **(2)** file. Right-click and select **Open** **(3)** to open the file in VS code.

     ![](media/cloudnative8.png)

3. Make sure to Update the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file to match the name of your ACR Login Server.

     ![In this screenshot of the Azure Cloud Shell editor window, the ... button has been selected and the Close Editor option is highlighted.](media/cloudnative7.png "Close Azure Cloud Editor")

4. Save the changes by **CTRL + S** button to **Save**.

5. Navigate back to the Windows command prompt and run the below command to change the directory to the `~/LabFiles` folder.

      ```bash
      cd C:/LabFiles
      ```
   
6. Log in to Azure if not already done with the below command after updating the values in the command.

- Username: **<inject key="AzureAdUserEmail"></inject>**
- Password: **<inject key="AzureAdUserPassword"></inject>**

      ```
      az login -u [username] -p [Password]
      ```

7. Execute the below command to deploy the application described in the YAML files. You will receive a message indicating the item `kubectl` has created a web deployment and a web service.
   
     >**Info**: The below kubectl command will create the Deployment workload and Service into the namespace that we have defined in the YAML files. 

      ```bash
      kubectl create --save-config=true -f web.deployment.yml -f web.service.yml 
      ```

     ![In this screenshot of the console, kubectl apply -f kubernetes-web.yaml has been typed and run at the command prompt. Messages about web deployment and web service creation appear below.](media/kubectlcreated.png "kubectl create application")

8. Return to the AKS blade in the Azure Portal. From the navigation menu, select the **Services and ingresses** under **Kubernetes resources**. You should be able to access the website via an **External endpoint**.

     ![AKS services and ingresses shown with External IP highlighted](media/website.png "AKS services and ingresses shown with External IP highlighted")

     ![AKS services and ingresses shown with External IP highlighted](media/website2.png "AKS services and ingresses shown with External IP highlighted")

     > **Note:** If the website doesn't load, try refreshing the page several times as it might take a while for AKS to populate the website.

#### Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="be8d94ad-c9e2-4a96-8d29-e675fb17dbea" />

## Summary

In this exercise, you have deployed your containerized web application to AKS that contains, the namespace, service, and workload in Azure Kubernetes. Also, you have created a service to AKS and accessed the website using an external endpoint. Also, you have set up the secret of the key vault to access the MongoDB from AKS. 

### You have successfully completed the lab. Click on the Next button.
