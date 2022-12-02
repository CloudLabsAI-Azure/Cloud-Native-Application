## Exercise 5: Updating Apps & Managing Kubernetes Ingress

**Duration**: 40 minutes

## Overview

In the previous exercise, we introduced a restriction to the scale properties of the service. In this exercise, you will configure the api deployments to create pods that use dynamic port mappings to eliminate the port resource constraint during scale activities.

Kubernetes services can discover the ports assigned to each pod, allowing you to run multiple instances of the pod on the same agent node --- something that is not possible when you configure a specific static port (such as 3001 for the API service).

### Task 1: Perform a rolling update
 
In this task, you will edit the web application source code to update some configuration and update the Docker image used by the deployment. Then you will perform a rolling update to demonstrate how to deploy a code change. Rolling updates allow Deployments' update to take place with zero downtime by incrementally updating Pods instances with new ones. The new Pods will be scheduled on Nodes with available resources

>**Note**: Please perform this task using a new Windows command prompt which should be not connected to build agent VM but should be logged into azure.


1. First you will be making some changes in your web application source code and will be creating a new docker image based on the latest changes.

1. Navigate back to the Windows command prompt where you have connected to your linux VM, and run the below command to navigate to the directory where you'll need to make the changes in web application source code.

     ```bash
     cd  Cloud-Native-Application/labfiles/src/ContosoTraders.Ui.Website/src/pages/home/components/hero

     ```
1. Once you are in the correct directly, run the below command to make open **Corousel.js** file to make some text change in homepage of your web application.

     ```bash
     vim Corousel.js
     ```
     
   ![A screenshot of the code editor showing updates in context of the app.js file](media/updatetext.png "AppInsights updates in app.js")
   
1. Once the file is open, press "i" to enter the insert mode and update the existing value with mentioned below in **items** section and in **name** value.

     ```
     The latest, Fastest, Most Powerful Xbox Ever.
     ```
 
   ![A screenshot of the code editor showing updates in context of the app.js file](media/updatesource.png "AppInsights updates in app.js")

1. Once the changes are done, save the file pressing "ESC" and then type ":wq" and exit the editor.

1. Run the below command to change the directory to the ContosoTraders.Ui.Website folder.

     ```bash
     cd
     cd Cloud-Native-Application/labfiles/src/ContosoTraders.Ui.Website
     ```
   
1. Once you are in the correct directory, run the below command to create the new docker image that will be having all the latest changes of the web application. and push the new image to ACR. Make sure to replace the SUFFIX with the given DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** value in the below command.
  
   >**Note**: Observe that this time we are using "V1" tag for the image
  
      ```bash
      docker build . -t contosotradersacrSUFFIX.azurecr.io/contosotradersuiweb:V1 -t contosotradersacrSUFFIX.azurecr.io/contosotradersuiweb:V1

      docker push contosotradersacr[SUFFIX].azurecr.io/contosotradersuiweb:V1
      ```

1. Once the docker build and push is completed, Navigate back to the other Command prompt that is not connected to the linux VM.

1. Run the below kubectl command to get the current deployment in your AKS as now we will be updating the web api to the latest image.Copy the name of the **contoso-traders-web###** to the notepad. 

    ```bash
    kubectl get deployments -n contoso-traders
    kubectl get pods -n contoso-traders
    ```
    
   ![At the top of the list, a new web replica set is listed as a pending deployment in the Replica Set box.](media/deploymentss.png "Pod deployment is in progress")

   ![At the top of the list, a new web replica set is listed as a pending deployment in the Replica Set box.](media/describe.png "Pod deployment is in progress")

1. Now run the below command to view the current image version of the app. Make sure to update the **PODNAME** value with the value you copied in the last step.

     ```bash
     kubectl describe pods  -n contoso-traders
     ```
   
   ![At the top of the list, a new web replica set is listed as a pending deployment in the Replica Set box.](media/image.png "Pod deployment is in progress")

1. Now to set the new image on the pods, run the below command.

     ```bash
     kubectl set image deployments/contoso-traders-web -n contoso-traders contoso-traders-web=contosotradersacrSUFFIX.azurecr.io/contosotradersuiweb:V1
     ```
     
    ![At the top of the list, a new web replica set is listed as a pending deployment in the Replica Set box.](media/imageupdates.png "Pod deployment is in progress")

1. Now try describing the latest pods again and see which image is mapped with the pod.

    ![At the top of the list, a new web replica set is listed as a pending deployment in the Replica Set box.](media/imageupdates2.png "Pod deployment is in progress")
    
1. Once the image update to the pod is done, navigate back to azure portal and browse/refresh the web application page again and you should be able to see the changes on the home page.

   ![At the top of the list, a new web replica set is listed as a pending deployment in the Replica Set box.](media/webupdates.png "Pod deployment is in progress")
    
### Task 2: Configure Kubernetes Ingress

This task will set up a Kubernetes Ingress using an [Nginx proxy server](https://nginx.org/en/) to take advantage of path-based routing and TLS termination.

1. Run the following command from an Windows command terminal to add the Nginx stable Helm repository:

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    ```

2. Update your helm package list.

   ```bash
   helm repo update
   ```

   > **Note**: If you get a "no repositories found." error, then run the following command. This will add back the official Helm "stable" repository.
   >
   > ```bash
   > helm repo add stable https://charts.helm.sh/stable 
   > ```

3. Install the Ingress Controller resource to handle ingress requests as they come in. The Ingress Controller will receive a public IP of its own on the Azure Load Balancer and handle requests for multiple services over ports 80 and 443.

   ```bash
   helm install nginx-ingress ingress-nginx/ingress-nginx --namespace contoso-traders --set controller.replicaCount=2 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
   ```

4. Navigate to Azure Portal, open **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** Kubernetes service. Select **Services and ingresses** under Kubernetes resources and copy the IP Address for the **External IP** for the `nginx-ingress-RANDOM-nginx-ingress` service.

    > **Note**: It could take a few minutes to refresh, alternately, you can find the IP using the following command in Azure Cloud Shell.
    >
    > ```bash
    > kubectl get svc --namespace contoso-traders
    > ```
    >
   ![A screenshot of Azure Cloud Shell showing the command output.](media/controller.png "View the ingress controller LoadBalancer")

5. Within the Windows command terminal, create a script to update the public DNS name for the external ingress IP.

   ```bash
   code update-ip.sh
   ```
   
   Paste the following as the contents. Make sure to replace the following placeholders in the script:

   - `[INGRESS PUBLIC IP]`: Replace this with the IP Address copied from step 5.
   - `[ KUBERNETES_NODE_RG]`: Replace the `SUFFIX` with this value **<inject key="DeploymentID" />** and `REGION` with the region of your resource group: **<inject key="Region" />**.
   - `[SUFFIX]`: Replace this with the same SUFFIX value **<inject key="DeploymentID" />** that you have used previously for this lab.

   ```bash
   #!/bin/bash

   # Public IP address
   IP="[INGRESS PUBLIC IP]"

   # Resource Group that contains AKS Node Pool
   KUBERNETES_NODE_RG="contoso-traders-aks-nodes-rg-SUFFIX"

   # Name to associate with public IP address
   DNSNAME="contosotrader-[SUFFIX]-ingress"

   # Get the resource-id of the public ip
   PUBLICIPID=$(az network public-ip list --resource-group $KUBERNETES_NODE_RG --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

   # Update public ip address with dns name
   az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME
   ```
6. Save changes and close the editor.

7. Run the update script.

   ```bash
   bash ./update-ip.sh
   ```
   
   ![A screenshot of cloud shell editor showing the updated IP and SUFFIX values.](media/updateip.png "Update the IP and SUFFIX values")

8. Verify the IP update by visiting the URL in your browser. Make sure to update these values `[SUFFIX]`: **<inject key="DeploymentID" />** and `[AZURE-REGION]`: **<inject key="Region" />** in the below URL before browsing it.

    > **Note**: It is normal to receive a 404 message at this time.

    ```text
    http://contosotraders-[SUFFIX]-ingress.[AZURE-REGION].cloudapp.azure.com/
    ```
   
   >**Note**: If the URL doesn't work or you don't receive 404 error. Please run the below mentioned command and try accessing the URL again.

   ```bash
   helm upgrade nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-demo \
    --set controller.service.externalTrafficPolicy=Local
   ```

9. Use helm to install `cert-manager`, a tool that can provision SSL certificates automatically from letsencrypt.org.

    ```bash
    kubectl create namespace cert-manager
    kubectl label namespace cert-manager cert-manager.io/disable-validation=true
    kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
    ```

10. To create a custom `ClusterIssuer` resource for the `cert-manager` service to use when handling requests for SSL certificates. Run the below command in Windows command prompt.

    ```bash
    cd C:\lab-files
    code clusterissuer.yml
    ```

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
    spec:
      acme:
        # The ACME server URL
        server: https://acme-v02.api.letsencrypt.org/directory
        # Email address used for ACME registration
        email: user@contosotraders.com
        # Name of a secret used to store the ACME account private key
        privateKeySecretRef:
          name: letsencrypt-prod
        # Enable HTTP01 validations
        solvers:
        - http01:
            ingress:
              class: nginx
    ```

11. Save changes and close the editor.

12. Create the issuer using `kubectl`.

    ```bash
    kubectl create --save-config=true -f clusterissuer.yml
    ```

13. Now you can create a certificate object.

    > **Note**:
    >
    > Cert-manager might have already created a certificate object for you using ingress-shim.
    >
    > To verify that the certificate was created successfully, use the `kubectl describe certificate tls-secret` command.
    >
    > If a certificate is already available, skip to step 16.

    ```bash
    code certificate.yml
    ```

    Use the following as the contents and update the `[SUFFIX]`: **<inject key="DeploymentID" />** and `[AZURE-REGION]`: **<inject key="Region" />** to match your ingress DNS name.

    ```yaml
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: tls-secret
    spec:
      secretName: tls-secret
      dnsNames:
        - fabmedical-[SUFFIX]-ingress.[AZURE-REGION].cloudapp.azure.com
      issuerRef:
        name: letsencrypt-prod
        kind: ClusterIssuer
    ```

14. Save changes and close the editor.

15. Create the certificate using `kubectl`.

    ```bash
    kubectl create --save-config=true -f certificate.yml
    ```

    > **Note**: To check the status of the certificate issuance, use the `kubectl describe certificate tls-secret` command and look for an _Events_ output similar to the following:
    >
    > ```text
    > Type    Reason         Age   From          Message
    > ----    ------         ----  ----          -------
    > Normal  Generated           38s   cert-manager  Generated new private key
    > Normal  GenerateSelfSigned  38s   cert-manager  Generated temporary self signed certificate
    > Normal  OrderCreated        38s   cert-manager  Created Order resource "tls-secret-3254248695"
    > Normal  OrderComplete       12s   cert-manager  Order "tls-secret-3254248695" completed successfully
    > Normal  CertIssued          12s   cert-manager  Certificate issued successfully
    > ```

    It can take between 5 and 30 minutes before the tls-secret becomes available. This is due to the delay involved with provisioning a TLS cert from letsencrypt.

16. Now you can create an ingress resource for the content applications.

    ```bash
    code content.ingress.yml
    ```

    Use the following as the contents and update the `[SUFFIX]`: **<inject key="DeploymentID" />** and `[AZURE-REGION]`: **<inject key="Region" />** to match your ingress DNS name:

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: contoso-ingress
      namespace: contoso-traders
      annotations:
        kubernetes.io/ingress.class: nginx
        nginx.ingress.kubernetes.io/rewrite-target: /$1
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        cert-manager.io/cluster-issuer: letsencrypt-prod
    spec:
      tls:
      - hosts:
          - contosotrader-[SUFFIX]-ingress.[AZURE-REGION].cloudapp.azure.com
        secretName: tls-secret
      rules:
      - host: contosotrader-[SUFFIX]-ingress.[AZURE-REGION].cloudapp.azure.com
        http:
          paths:
          - path: /(.*)
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 80
          - path: /content-api/(.*)
            pathType: Prefix
            backend:
              service:
                 name: api
                 port:
                   number: 3001
    ```

17. Save changes and close the editor.

18. Create the ingress using `kubectl`.

    ```bash
    kubectl create --save-config=true -f content.ingress.yml
    ```

19. Refresh the ingress endpoint in your browser. You should be able to visit the website and see all the content.

21. Test TLS termination by visiting services again using `https`.

    > **Note**: It can take between 5 and 30 minutes before the SSL site becomes available. This is due to the delay involved with provisioning a TLS cert from letsencrypt.

22. Click the **Next** button located in the bottom right corner of this lab guide to continue with the next exercise.

## Summary

In this exercise, you have performed a rolling update and configured Kubernetes Ingress.
