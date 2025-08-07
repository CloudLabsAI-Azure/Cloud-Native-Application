# Exercise 3: Deploy the application to the Azure Kubernetes Service
   
### Estimated Duration: 120 minutes

## Overview

In this exercise, you will deploy your containerized web application to Azure Kubernetes Service (AKS) using Azure Key Vault for managing secrets and Azure Container Registry (ACR) where we have the containerized web application images stored. Additionally, you will explore two different methods for deploying the application to AKS.

## Lab Objectives

You will be able to complete the following tasks:

- Task 1: Tunnel into the Azure Kubernetes Service cluster
- Task 2: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
- Task 3: Deploy a service & workload using kubectl

### Task 1: Tunnel into the Azure Kubernetes Service cluster  

In this task, you will gather the necessary information about your Azure Kubernetes Service (AKS) cluster to establish a connection and access the Kubernetes management dashboard from the Cloud Shell.

> **Note**: The following tasks should be executed in the command prompt.

1. Open a new command prompt as Administrator in your jump VM and log in to Azure with the below command.
   
    ```bash
    az login -u <inject key="AzureAdUserEmail"></inject> -p <inject key="AzureAdUserPassword"></inject>
    ```
    ![](media/E3T1S1.png)

    > **Note:** If you face any error while running the 'az' command, then run the below command to install the Azure CLI and close the command prompt. Re-perform step 1 in a new command prompt as Administrator.

    ```bash
    choco install azure-cli
    ```
    
2. Run the following command to set up the Kubernetes cluster connection using kubectl.

   ```bash
   az aks get-credentials -a --name contoso-traders-aks<inject key="DeploymentID" enableCopy="true"/> --resource-group ContosoTraders-<inject key="DeploymentID" enableCopy="true"/>
   ```
   ![](media/E3T1S2.png)

3. Run a quick kubectl command to generate a list of nodes to verify if the setup is correct.

   ```bash
   kubectl get nodes
   ```

   ![In this screenshot of the console, kubectl get nodes has been typed and run at the command prompt, which produces a list of nodes.](media/E3T1S3.png "kubectl get nodes")   


### Task 2: Deploy a namespace, service, and workload in the Azure Kubernetes Service using the Azure Portal
   
In this task, you will define a Kubernetes Service for your API to enable internal accessibility of the application within the Azure Kubernetes Service (AKS) cluster.

1. Navigate back to the **contosoTraders-<inject key="DeploymentID" />** resource group, and select the **contoso-traders-aks<inject key="DeploymentID" />** **(1)** Kubernetes service.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Service.](media/E3T2S1.png "Add a Service")
   
1. We have already defined a new AKS **Namespaces** for your API deployment. Going further, you will be using the **contoso-traders** namespace only. 

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
          # TODO: Replace 'SUFFIX' in the next line with whatever your ENVIRONMENT GitHub secret value is
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
     
   ![Selecting + Add to create a deployment.](media/E3T2S6.png "Selecting + Add to create a deployment")

1. After a few minutes, you will see the deployment listed, and it should be in a running state.

    ![Selecting + Add to create a deployment.](media/E3T2S7.png "Selecting + Add to create a deployment")


> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="8e8b8774-50eb-413f-84e0-c1861a2b10b7" />

### Task 3: Deploy a service & workload using kubectl

In this task, you will deploy the web service & its workload using kubectl.

1. Open a **File Explorer** from your JumpVM.

1. Navigate to `C:\LabFiles` **(1)** directory and select `web.deployment.yml` **(2)** file. Right-click and select **Open** **(3)** to open the file in VS Code.

   ![](media/E3T3S2.png)

1. Make sure to update the **_SUFFIX_** with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the YAML file to match the name of your ACR Login Server.

    ![In this screenshot of the Azure Cloud Shell editor window, the ... button has been selected and the Close Editor option is highlighted.](media/sfx.png "Close Azure Cloud Editor")

1. Save the changes by **CTRL + S** button to **Save**.

1. Navigate back to the Windows command prompt and run the below command to change the directory to the `~/LabFiles` folder.

    ```bash
    cd C:/LabFiles
    ```

1. Log in to Azure if not already done with the below command after updating the values in the command.

    ```
    az login -u <inject key="AzureAdUserEmail"></inject> -p <inject key="AzureAdUserPassword"></inject>
    ```
    ![](media/E3T3S6.png)

1. Execute the below command to deploy the application described in the YAML files. You will receive a message indicating the item `kubectl` has created a web deployment and a web service.
   >**Info**: The below kubectl command will create the Deployment workload and Service in the namespace that we have defined in the YAML files. 

    ```bash
    kubectl create --save-config=true -f web.deployment.yml -f web.service.yml 
    ```

    ![In this screenshot of the console, kubectl apply -f kubernetes-web.yaml has been typed and run at the command prompt. Messages about web deployment and web service creation appear below.](media/E3T3S7.png "kubectl create application")

1. Return to the AKS blade in the Azure Portal. From the navigation menu, select the **Services and ingresses (1)** under **Kubernetes resources**. You should be able to access the website via an **External endpoint (2)**.

    ![AKS services and ingresses shown with External IP highlighted](media/E3T3S8.png "AKS services and ingresses shown with External IP highlighted")

    ![AKS services and ingresses shown with External IP highlighted](media/website2--new.png "AKS services and ingresses shown with External IP highlighted")
    
1. Click the **Next** button located in the bottom right corner of this lab guide to continue with the next exercise.


> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="a9fa4d00-ae23-4b56-a3e3-ee1f2effdfb2" />

## Summary

In this exercise, you have deployed your containerized web application to AKS that contains the namespace, service, and workload in Azure Kubernetes. Also, you have created a service to AKS and accessed the website using an external endpoint.


### You have successfully completed the lab. Click on **Next >>** to proceed with next exercise.
![](media/3-n.png "Next")