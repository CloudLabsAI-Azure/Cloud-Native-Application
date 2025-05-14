## Hands-On-Lab: Deploy the application to the Azure Kubernetes Service
   
### Estimated Duration: 90 minutes

## Overview

In this exercise, you will be deploying your containerized web application to AKS (Azure Kubernetes Service) with the help of Key Vault secrets and ACR where you have stored your containerized web application images. Also, you will be exploring two ways to deploy the app to AKS. 

## Objectives

In this Exercise, you will be able to complete the following tasks:

- Task 1: Tunnel into the Azure Kubernetes Service cluster
- Task 2: Set up Key Vault & Secrets
- Task 3: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
- Task 4: Deploy a service & workload using kubectl

### Task 1: Tunnel into the Azure Kubernetes Service cluster  

This task will gather the information you need about your Azure Kubernetes Service cluster to connect to the cluster and execute commands to connect to the Kubernetes management dashboard from the cloud shell.

> **Note:** The following tasks should be executed in the command prompt.

1. In the LabVM, search for **cmd (1)**, right click on the **Command prompt (1)** then select **Run as administrator (3)**.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn28.png "Add a Namespace")

1. Log in to Azure with the below commands after updating the values in the command.

   * Username: **<inject key="AzureAdUserEmail"></inject>**
   * Password: **<inject key="AzureAdUserPassword"></inject>**
   
      ```bash
      az login -u [username] -p [Password]
      ```

      ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn29.png "Add a Namespace")    
    
1. Verify that you are connected to the correct subscription with the following command to show your default subscription:

   ```bash
   az account show
   ```

1. Run the following command to set up the Kubernetes cluster connection using kubectl. 

   ```bash
   az aks get-credentials -a --name contoso-traders-aks<inject key="DeploymentID" enableCopy="true"/> --resource-group ContosoTraders-<inject key="DeploymentID" enableCopy="true"/>
   ```

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn30.png "Add a Namespace")

1. Run a quick kubectl command to generate a list of nodes to verify if the setup is correct.

   ```bash
   kubectl get nodes
   ```

   ![In this screenshot of the console, kubectl get nodes has been typed and run at the command prompt, which produces a list of nodes.](media/cn31.png "kubectl get nodes")   

### Task 2: Set up MongoDB Secrets with AKS 

In this task, you will be creating a secret in the Kubernetes cluster to fetch the data from MongoDB.
     
1. Run the following command to create a secret using kubectl. 

    ```sh
    kubectl create secret generic mongodbconnection --from-literal=mongodbconnection=mongodbconnection --namespace=contoso-traders
    ```

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn39.png "Add a Namespace")

1. Navigate back to **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />** resource group. Search for **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/> (1)** and select **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/> (2)** Kuberbate service. 

     ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/cn40.png "Add a Namespace")
    
1. Select **Configuration (1)** from the left side menu under **Kubernate resources** and click on **Secrets (2)** section. Under secrets, you should be able to see the newly created secret. **(3)** 

     ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/14052025(8).png "Add a Namespace")

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="c33258ca-4b95-48b4-9483-25b150719d00" />

### Task 3: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
   
In this task, you will deploy the API Carts application to the Azure Kubernetes Service cluster using the Azure Portal.
   
1. Select **Namedpace (1)** from the left side menu under **Kubernate resources**. We have already defined a new Namespace for your API deployment. Going further you will be using the **contoso-traders (2)** namespace only. 

    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/cn41.png "Add a Service")
    
3. Define a Service for your API, so that the application is accessible within the cluster. Select the **Services and ingresses (1)** blade of the **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** AKS resource detail page in the Azure Portal. In the Services tab, select **+ Create (2)** and choose **Apply a YAML (3)**. 
    
    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/cn42.png "Add a Service")

1. In the **Apply with YAML** pane, paste the below YAML code, which creates a service in AKS **(1)** and click on **Apply (2)**. Make sure to replace the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file.

    >**Info:** The below YAML script will create an AKS service inside the contoso-traders namespace that you have created in previous steps. AKS Service is an abstract way to expose an application running on a set of Pods as a network service. 

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

1. In the **Apply with YAML** pane, paste the below YAML code, which creates a workload in AKS and click on **Apply**. Make sure to replace the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file to update the LOGINSERVER name of the ACR instance.

    >**Info:** The below YAML file will create deployment pods in the namespace contoso-traders. A Kubernetes Deployment tells Kubernetes how to create or modify instances of the pods that hold a containerized application. Deployments can help to efficiently scale the number of replica pods, enable the rollout of updated code in a controlled manner, or roll back to an earlier deployment version if necessary.

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

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="9975e483-b432-47bf-99bf-eca3572721f1" />

### Task 4: Deploy a service & workload using kubectl

In this task, you will deploy the web service & its workload using kubectl.

1. Open a **File Explorer** from your JumpVM.

1. Navigate to `C:\LabFiles` **(1)** directory and select `web.deployment.yml` **(2)** file. Right-click and select **Open** **(3)** to open the file in VS Code.

   ![](media/cn47.png)

1. Make sure to update the **SUFFIX** with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file to match the name of your ACR Login Server.

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

   >**Info:** The below kubectl command will create the Deployment workload and Service in the namespace that we have defined in the YAML files. 

    ```bash
    kubectl create --save-config=true -f web.deployment.yaml -f web.service.yaml 
    ```

    ![In this screenshot of the console, kubectl apply -f kubernetes-web.yaml has been typed and run at the command prompt. Messages about web deployment and web service creation appear below.](media/cn48.png "kubectl create application")

1. Return to the AKS blade in the Azure Portal. From the navigation menu, select the **Services and ingresses (1)** under **Kubernetes resources**. You should be able to access the website via an **External endpoint (2)**.

    ![AKS services and ingresses shown with External IP highlighted](media/cn49.png "AKS services and ingresses shown with External IP highlighted")

    ![AKS services and ingresses shown with External IP highlighted](media/website2.png "AKS services and ingresses shown with External IP highlighted")

    > **Note:** This may take 1–2 minutes to load thanks for your patience!

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="d838945d-f950-452c-b5c4-9c516a60b595" />

## Review

In this exercise, you have accomplished the following:

- Task 1: Tunnelled into the Azure Kubernetes Service cluster
- Task 2: Set up Key Vault & Secrets
- Task 3: Deployed a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
- Task 4: Deployed a service & workload using kubectl

### You have successfully completed the lab.
