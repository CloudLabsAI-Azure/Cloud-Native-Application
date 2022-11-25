## Exercise 4: Working with services and routing application traffic

**Duration**: 120 minutes

In the previous exercise, we introduced a restriction to the scale properties of the service. In this exercise, you will configure the api deployments to create pods that use dynamic port mappings to eliminate the port resource constraint during scale activities.

Kubernetes services can discover the ports assigned to each pod, allowing you to run multiple instances of the pod on the same agent node --- something that is not possible when you configure a specific static port (such as 3001 for the API service).

### Task 1: Update an external service to support dynamic discovery with a load balancer

In this task, you will update the web service so that it supports dynamic discovery through an Azure load balancer.

1. From AKS **Kubernetes resources** menu, select **Deployments** (2) under **Workloads** (1). From the list select the **web** (3) deployment.

   ![](media_prod/cna39.png "Remove web container hostPort entry")

2. Select **YAML** (1), then select the **JSON** tab (2).

   ![](media_prod/cna40.png "Remove web container hostPort entry")

3. First locate the replicas node and update the required count to `4`.

4. Next, scroll to the web containers spec as shown in the screenshot. Remove the hostPort entry for the web container's port mapping.

   ![This is a screenshot of the Edit a Deployment dialog box with various displayed information about spec, containers, ports, and env. The ports node, containerPort: 3001 and protocol: TCP are highlighted, along with the increase to 4 replicas.](media/update-web-deployment.png "Remove web container hostPort entry")

5. Select **Review + save** and then confirm the change and **Save**.

6. Check the status of the scale out by refreshing the web deployment's view. From the navigation menu, select **Pods** from under Workloads. Select the **web** pods. From this view, you should see an error like that shown in the following screenshot.

   ![Deployments is selected under Workloads in the navigation menu on the left. On the right are the Details and New Replica Set boxes. The web deployment is highlighted in the New Replica Set box, indicating an error.](media/2021-03-26-18-23-38.png "View Pod deployment events")

Like the API deployment, the web deployment used a fixed _hostPort_, and your ability to scale was limited by the number of available agent nodes. However, after resolving this issue for the web service by removing the _hostPort_ setting, the web deployment is still unable to scale past two pods due to CPU constraints. The deployment is requesting more CPU than the web application needs, so you will fix this constraint in the next task.

### Task 2: Adjust CPU constraints to improve scale

In this task, you will modify the CPU requirements for the web service so that it can scale out to more instances.

1. Re-open the JSON view for the web deployment and then find the **cpu** resource requirements for the web container. Change this value to `125m`.

   ![This is a screenshot of the Edit a Deployment dialog box with various displayed information about ports, env, and resources. The resources node, with cpu: 125m selected, is highlighted.](media/2021-03-26-18-24-06.png "Change cpu value")

2. Select **Review + save**, confirm the change and then select **Save** to update the deployment.

3. From the navigation menu, select **Replica Sets** under **Workloads**. From the view's Replica Sets list select the web replica set.

4. When the deployment update completes, four web pods should be shown in running state.

   ![Four web pods are listed in the Pods box, and all have green check marks and are listed as Running.](media/2021-03-26-18-24-35.png "Four pods running")

### Task 3: Perform a rolling update
 
In this task, you will edit the web application source code to add Application Insights and update the Docker image used by the deployment. Then you will perform a rolling update to demonstrate how to deploy a code change.

>**Note**: Please perform this task using a new Cloudshell which should be not connected to  build agent VM.

1. Execute this command in Azure Cloud Shell to retrieve the instrumentation key for the `content-web` Application Insights resource. Replace the `SUFFIX` placeholder with **<inject key="DeploymentID" />**.

   ```bash
   az resource show -g fabmedical-[SUFFIX] -n content-web --resource-type "Microsoft.Insights/components" --query properties.InstrumentationKey -o tsv
   ```

   Copy this value. You will use it later.

   >**Note**: If you have a blank result check that the command you issued refers to the right resource.

2. From an Azure Cloud Shell terminal, Update your Fabmedical repository files by pulling the latest changes from the git repository and then updating deployment YAML files.

    ```bash
    cd ~/Fabmedical/content-web
    kubectl get deployment api -n ingress-demo -o=yaml > api.deployment.yaml
    kubectl get deployment web -n ingress-demo -o=yaml > web.deployment.yaml
    git pull
    ```

    > **Note**: The calls to `kubectl` are necessary to fetch recent changes to the port and CPU resource configurations made in previous steps for the `web` and `api` deployments.

3. Install support for Application Insights.

    ```bash
    npm install applicationinsights --force --save
    ```

    > **Note**: Make sure to include the `--save` argument. Without this, a reference to the `applicationinsights` npm package will not get added to the `package.json` file of the `content-web` nodejs project, resulting in a deployment failure in later steps.

4. Edit the `app.js` file using  the command ```code app.js ``` Visual Studio Code remote and and add the following lines immediately after `express` is instantiated on line 6. Replace `YOUR APPINSIGHTS KEY` placeholder with the app insights key which you had copied earlier in the task.

    ```javascript
    const appInsights = require("applicationinsights");
    appInsights.setup("[YOUR APPINSIGHTS KEY]");
    appInsights.start();
    ```

    ![A screenshot of the code editor showing updates in context of the app.js file](media/hol-2019-10-02_12-33-29.png "AppInsights updates in app.js")

5. Save changes and close the editor.

6. Paste the following commands to be in the right path. You'll be able to see `content-web.yml`, `content-api.yml`, and `content-init.yml` files.

   ```bash
   cd ~/Fabmedical
   cd .github
   cd workflows
   ls
   ```

7. Add the following entries (uncomment) to the path triggers in the `content-web.yml` workflow file using `code content-web.yml` command in the `.github/workflows` folder.

    ```yaml
    on:
      push:
        branches:
        - main
        paths:
        - 'content-web/**'
        - web.deployment.yml  # These two file
        - web.service.yml     # entries here
    ```
    
    ![](media_prod/uncomment.png "content-web")

8. Replace the commented task in the end of the file and add the following task in the `content-web.yml` workflow file in the `.github/workflows` folder. Be sure to indent the YAML formatting of the task to be consistent with the formatting of the existing file.

   >**NOTE**: To make the file to be in proper indentation. You can use the following online YAML Vaildator `https://yamlchecker.com/`.

   ```yaml 
          - name: Deploy to AKS
            uses: azure/k8s-deploy@v1
            with:
              manifests: |
                web.deployment.yml
                web.service.yml
              images: |
                ${{ env.containerRegistry }}/${{ env.imageRepository }}:${{ env.tag }}
              imagepullsecrets: |
                ingress-demo-secret
              namespace: ingress-demo
   ```
   
   ![](media_prod/contentadd.png "content-web")
    
9. Save the file and close the editor.

   ![This is a screenshot of the code editor save and close actions.](media/Ex2-Task1.17.1.png "Code editor configuration update")

10. Add the following entries (uncomment) to the path triggers in the `content-api.yml` workflow file using `code content-api.yml` command in the `.github/workflows` folder.

    ```yaml
    on:
      push:
        branches:
        - main
        paths:
        - 'content-api/**'
        - api.deployment.yml  # These two file
        - api.service.yml     # entries here
    ```
    
    ![](media_prod/uncommentapi.png "content-web")

11. Replace the commented task in the end of the file and add the following task in the `content-api.yml` workflow file in the `.github/workflows` folder. Be sure to indent the YAML formatting of the task to be consistent with the formatting of the existing file.

    >**NOTE**: To make the file to be in proper indentation. You can use the following online YAML Vaildator `https://yamlchecker.com/`.

    ```yaml
          - uses: Azure/aks-set-context@v1
            with:
              creds: '${{ secrets.AZURE_CREDENTIALS }}'
              cluster-name: '${{ env.clusterName }}'
              resource-group: '${{ env.resourceGroupName }}'
              
          - name: Deploy to AKS
            uses: azure/k8s-deploy@v1
            with:
              manifests: |
                api.deployment.yml
                api.service.yml
              images: |
                ${{ env.containerRegistry }}/${{ env.imageRepository }}:${{ env.tag }}
              imagepullsecrets: |
                ingress-demo-secret
              namespace: ingress-demo
    ```   
    ![](media_prod/contentapiadd.png "content-web")
    
12. Save the file and close the editor.

    ![This is a screenshot of the code editor save and close actions.](media/Ex2-Task1.17.1.png "Code editor configuration update")

13. Push these changes to your repository so that GitHub Actions CI will build and deploy a new Container image.

    ```bash
    cd ~/Fabmedical
    git add .
    kubectl delete deployment web -n ingress-demo
    kubectl delete deployment api -n ingress-demo
    git commit -m "Added Application Insights"
    git push
    ```
14. From **Actions** (1) tab in Github, Visit the `content-web` and `content-api` Actions (2) for your GitHub Fabmedical repository and observe the images being built and deployed into the Kubernetes cluster.

    ![On the Stats page, the hostName is highlighted.](media_prod/cna41.png "On Stats page hostName is displayed")

15. While the pipelines runs, return the Azure Portal in the browser.

16. From the navigation menu, select **Replica Sets** (2) under **Workloads** (1). From this view, you will see a new replica set for the **web** (3), which may still be in the process of deploying (as shown below) or already fully deployed.

    ![At the top of the list, a new web replica set is listed as a pending deployment in the Replica Set box.](media_prod/cna43.png "Pod deployment is in progress")

17. While the deployment is in progress, you can navigate to the web application and visit the stats page at `/stats`. Refresh the page as the rolling update executes. Observe that the service is running normally, and tasks continue to be load balanced.

    ![On the Stats page, the hostName is highlighted.](media/image145.png "On Stats page hostName is displayed")

### Task 4: Configure Kubernetes Ingress

This task will set up a Kubernetes Ingress using an [Nginx proxy server](https://nginx.org/en/) to take advantage of path-based routing and TLS termination.

1. Run the following command from an Azure Cloud Shell terminal to add the Nginx stable Helm repository:

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
   helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-demo \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
   ```

4. In the Azure Portal under **Services and ingresses**, copy the IP Address for the **External IP** for the `nginx-ingress-RANDOM-nginx-ingress` service.

   ![A screenshot of the Kubernetes management dashboard showing the ingress controller settings.](media/2021-03-26-18-26-13.png "Copy ingress controller settings")

    > **Note**: It could take a few minutes to refresh, alternately, you can find the IP using the following command in Azure Cloud Shell.
    >
    > ```bash
    > kubectl get svc --namespace ingress-demo
    > ```
    >
   ![A screenshot of Azure Cloud Shell showing the command output.](media/Ex4-Task5.5a.png "View the ingress controller LoadBalancer")

5. Within the Azure Cloud Shell, create a script to update the public DNS name for the external ingress IP.

   ```bash
   cd ~/Fabmedical
   code update-ip.sh
   ```
   
   Paste the following as the contents. Be sure to replace the following placeholders in the script:

   - `[INGRESS PUBLIC IP]`: Replace this with the IP Address copied from step 5.
   - `[ KUBERNETES_NODE_RG]`: Replace the `SUFFIX` with this value **<inject key="DeploymentID" />** and `REGION` with the region of your resource group: **<inject key="Region" />**.
   - `[SUFFIX]`: Replace this with the same SUFFIX value **<inject key="DeploymentID" />** that you have used previously for this lab.

   ```bash
   #!/bin/bash

   # Public IP address
   IP="[INGRESS PUBLIC IP]"

   # Resource Group that contains AKS Node Pool
   KUBERNETES_NODE_RG="MC_fabmedical-[SUFFIX]_fabmedical-[SUFFIX]_[REGION]"

   # Name to associate with public IP address
   DNSNAME="fabmedical-[SUFFIX]-ingress"

   # Get the resource-id of the public ip
   PUBLICIPID=$(az network public-ip list --resource-group $KUBERNETES_NODE_RG --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

   # Update public ip address with dns name
   az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME
   ```

   ![A screenshot of cloud shell editor showing the updated IP and SUFFIX values.](media/cloud-native-update-ip.png "Update the IP and SUFFIX values")

6. Save changes and close the editor.

7. Run the update script.

   ```bash
   bash ./update-ip.sh
   ```

8. Verify the IP update by visiting the URL in your browser. Make sure to update these values `[SUFFIX]`: **<inject key="DeploymentID" />** and `[AZURE-REGION]`: **<inject key="Region" />** in the URL before browsing it.

    > **Note**: It is normal to receive a 404 message at this time.

    ```text
    http://fabmedical-[SUFFIX]-ingress.[AZURE-REGION].cloudapp.azure.com/
    ```

   ![A screenshot of the fabmedical browser URL.](media/Ex4-Task5.9.png "fabmedical browser URL")
   
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

10. Create a custom `ClusterIssuer` resource for the `cert-manager` service to use when handling requests for SSL certificates.

    ```bash
    cd ~/Fabmedical
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
        email: user@fabmedical.com
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
    cd ~/Fabmedical
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
    cd ~/Fabmedical
    code content.ingress.yml
    ```

    Use the following as the contents and update the `[SUFFIX]`: **<inject key="DeploymentID" />** and `[AZURE-REGION]`: **<inject key="Region" />** to match your ingress DNS name:

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: content-ingress
      namespace: ingress-demo
      annotations:
        kubernetes.io/ingress.class: nginx
        nginx.ingress.kubernetes.io/rewrite-target: /$1
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        cert-manager.io/cluster-issuer: letsencrypt-prod
    spec:
      tls:
      - hosts:
          - fabmedical-[SUFFIX]-ingress.[AZURE-REGION].cloudapp.azure.com
        secretName: tls-secret
      rules:
      - host: fabmedical-[SUFFIX]-ingress.[AZURE-REGION].cloudapp.azure.com
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

19. Refresh the ingress endpoint in your browser. You should be able to visit the speakers and sessions pages and see all the content.

20. Visit the API directly, by navigating to `/content-api/sessions` at the ingress endpoint.

    ![A screenshot showing the output of the sessions content in the browser.](media_prod/finalop.png "Content api sessions")
       >**Note**: If the URL doesn't work or you don't receive 404 error. Please run the below mentioned command and try accessing the URL again.

    ```bash
    helm upgrade nginx-ingress ingress-nginx/ingress-nginx \
     --namespace ingress-demo \
     --set controller.service.externalTrafficPolicy=Local
    ```    

21. Test TLS termination by visiting both services again using `https`.

    > **Note**: It can take between 5 and 30 minutes before the SSL site becomes available. This is due to the delay involved with provisioning a TLS cert from letsencrypt.
