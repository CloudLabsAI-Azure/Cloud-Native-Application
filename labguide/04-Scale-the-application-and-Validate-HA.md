## Exercise 4: Scale the application and test HA

**Duration**: 40 minutes

At this point, you have deployed a single instance of the web and Products API service containers. In this exercise, you will increase the number of container instances for the web service and scale the front-end on the existing cluster.

### Task 1: Increase service instances from the Azure Portal

In this task, you will increase the number of instances for the API deployment in the AKS Azure Portal blade. While it is deploying, you will observe the changing status.

1. In the AKS blade in the Azure Portal select **Workloads** and then select the **contoso-traders-products** deployment.

   ![In the edit YAML dialog, 2 is entered in the desired number of replicas.](media/HA1.png "Setting replicas to 2")

2. Select **YAML** in the window that loads and scroll down until you find **replicas** under spec section. Change the number of replicas to **2**, and then select **Review + save**. When prompted, check **Confirm manifest change** and select **Save**.

   ![In the edit YAML dialog, 2 is entered in the desired number of replicas.](media/HA2.png "Setting replicas to 2")

   > **Note**: If the deployment completes quickly, you may not see the deployment Waiting states in the portal, as described in the following steps.

3. In Workloads tab (1), From the Replica Set view (2) for the API, you will see it is now deploying and that there is one healthy instance and one pending instance (3).

   ![Replica Sets is selected under Workloads in the navigation menu on the left, and at right, Pods status: 1 pending, 1 running is highlighted. Below that, a red arrow points at the API deployment in the Pods box.](media/HS3.png "View replica details")

4. From the navigation menu, select **Workloads**. Note that the api Deployment has an alert and shows a pod count 1 of 2 instances (shown as `1/2`).

   ![In the Deployments box, the api service is highlighted with a grey timer icon at left and a pod count of 1/2 listed at right.](media/cna30.png "View api active pods")

   > **Note**: If you receive an error about insufficient CPU that is OK. We will see how to deal with this in the next Task (Hint: you can use the **Insights** option in the AKS Azure Portal to review the **Node** status and view the Kubernetes event logs).

   At this point, here is a health overview of the environment:

   - One Deployment and one Replica Set are each healthy for the web service.

   - The api Deployment and Replica Set are in a warning state.

   - Two pods are healthy in the 'default' namespace.

5. Open the Contoso Traders web application. The application should still work without errors .

### Task 2: Resolve failed provisioning of replicas

In this task, you will resolve the failed API replicas. These failures occur due to the clusters' inability to meet the requested resources.

1. In the AKS blade in the Azure Portal select **Workloads** (1) and then select the **api** (2) deployment. 

   ![In the Workload view with the API deployment highlighted.](media/cna28.png "API deployment is now healthy")

1. Select the **YAML** navigation item.

   ![In the Workload view with the API deployment highlighted.](media/cna31.png "API deployment is now healthy")

1. In the **YAML** screen scroll down and change the following items:

   - Modify **ports** and remove the **hostPort**. Two Pods cannot map to the same host port.

      ```yaml
      ports:
        - containerPort: 3001
          protocol: TCP
      ```

   - Modify the **cpu** and set it to **100m**. CPU is divided between all Pods on a Node.

      ```yaml
      resources:
        requests:
          cpu: 100m
          memory: 128Mi
      ```

   Select **Review + save** and, when prompted, confirm the changes and select **Save**.

   ![In the edit YAML dialog, showing two changes required.](media/hostport.png "Modify deployment manifest")

1. Return to the **Workloads** main view on the AKS Azure Portal and you will now see that the Deployment is healthy with two Pods operating.

   ![In the Workload view with the API deployment highlighted.](media/HS3.png "API deployment is now healthy")
   
### Task 3: Configure Horizontal Autoscaling for AKS pods
   In this task you will be configuring the Horizontal Autoscaling for your AKS pods
   
1. Navigate back to your windows command shell

3. Run the below command to configure the Horizontal autoscalling for you apiProducts pods

   ``` kubectl autoscale deployment contoso-traders-products -n contoso-traders --cpu-percent=50 --min=1 --max=10 ```
   
   ![In the Workload view with the API deployment highlighted.](media/HS11.png "API deployment is now healthy")
   
1. Now run the below command to check the status of the newly-made HorizontalPodAutoscaler

   ``` kubectl get hpa -n contoso-traders ```
   
   ![In the Workload view with the API deployment highlighted.](media/HS12.png "API deployment is now healthy")

### Task 4: Configure Vertical Autoscaling for AKS pods
   In this Task you will be configuring the Vertical autocaling for you AKS pods
   
1. 
### Task 3: Restart containers and test HA

In this task, you will restart containers and validate that the restart does not impact the running service.

1. Open the sample web application and navigate to the "Stats" page as shown.

   ![The Stats page is visible in this screenshot of the Contoso Neuro web application.](media/image123.png "Contoso web task details")
   
1. In the AKS blade in the Azure Portal select **Workloads** (1) and then select the **api** (2) deployment. 

   ![In the Workload view with the API deployment highlighted.](media/cna28.png "API deployment is now healthy")

2. Select the **YAML** navigation item and increase the required replica count to `4`. Use the same process as Exercise 4, Task 1.

   ![In the left menu the Deployments item is selected. The API deployment is highlighted in the Deployments list box.](media/2021-03-26-17-30-28.png "API pod deployments")

3. After a few moments you will find that the API deployment is now running 4 replicas successfully.

   ![Viewing replica set in the Azure Portal.](media/cna32.png "Viewing replica set in the Azure Portal")

4. Return to the browser tab with the web application stats page loaded. Refresh the page over and over. You will not see any errors, but you will see the api host name change between the four api pod instances periodically. The task id and pid might also change between the four api pod instances.

   ![On the Stats page in the Contoso Neuro web application, two different api host name values are highlighted.](media/image126.png "View web task hostname")

5. After refreshing enough times to see that the `hostName` value is changing, and the service remains healthy, you can open the **Replica Sets** view for the API in the Azure Portal.

6. On this view you can see the hostName value shown in the web application stats page matches the pod names for the pods that are running.

   ![Viewing replica set in the Azure Portal.](media/2021-03-26-17-31-02.png "Viewing replica set in the Azure Portal")

7. Select two of the Pods at random and choose **Delete**. Select **Confirm delete**, and press **Delete** again.

   ![The context menu for a pod in the pod list is expanded with the Delete item selected.](media/2021-03-26-17-31-31.png "Delete running pod instance")

8. Kubernetes will launch new Pods to meet the required replica count. Depending on your view you may see the old instances Terminating and new instances being Created.

   ![The first row of the Pods box is highlighted, and the pod has a green check mark and is running.](media/2021-03-26-17-31-54.png "API Pods changing state")

9. Return to the API Deployment and scale it back to `1` replica. See Step 3 above for how to do this if you are unsure.

10. Return to the sample web site's stats page in the browser and refresh while Kubernetes is scaling down the number of Pods. You will notice that only one API host name shows up, even though you may still see several running pods in the API replica set view. Even though several pods are running, Kubernetes will no longer send traffic to the pods it has selected to terminate. In a few moments, only one pod will show in the API Replica Set view.

    ![Replica Sets is selected under Workloads in the navigation menu on the left. On the right are the Details and Pods boxes. Only one API host name, which has a green check mark and is listed as running, appears in the Pods box.](media/2021-03-26-17-32-24.png "View replica details")

### Task 4: Configure Cosmos DB Autoscale

In this task, you will setup Autoscale on Azure Cosmos DB.

1. In the Azure Portal, navigate to the **Contosotraders-<inject key="DeploymentID" />** Azure Cosmos DB Account.

2. Select **Data Explorer**.

    ![](media/cosmosdata.png "View replica details")

3. Within **Data Explorer**, expand the `productdb` (1) database.

    ![](media/scalecosmos.png "View replica details")

4. Under the `productdb` collection, select **Scale**.

    ![](media/productdb.png "View replica details")

5. On the **Scale**, select **Autoscale** (1) for the **Throughput** setting under **Scale** and click on **Save** (2).

    ![The screenshot displays Cosmos DB Scale and Settings tab with Autoscale selected](media/autoscale.png "CosmosDB collection scale and settings")

### Task 5: Test Cosmos DB Autoscale

In this task, you will run a performance test script that will test the Autoscale feature of Azure Cosmos DB so you can see that it will now scale greater than 400 RU/s.

1. In the Azure Portal, navigate to the **fabmedical-<inject key="DeploymentID" />** Azure Cosmos DB Account.

   ![](media/cna33.png "View replica details")

2. Select **Connection String** under **Settings**.

   ![](media/cna38.png "View replica details")

3. On the **Connection String** pane, copy the **HOST**, **USERNAME**, and **PRIMARY PASSWORD** values. Save these for use later.

    ![The Cosmos DB account Connection String pane with the fields to copy highlighted.](media/cosmos-connection-string-pane.png "View CosmosDB connection string")

    >**Note**: In your Cosmos DB account, you may see that the host endpoint uses `.mongo.cosmos.azure.com`, which is for version 3.6 of Mongo DB. The endpoint shown here is `.documents.azure.com`, which is for version 3.2 of Mongo DB. You can use either endpoint for the purposes of this Task. If you are curious about the new features added to version 3.6 (that do not affect the application in this lab), consult [this](https://devblogs.microsoft.com/cosmosdb/upgrade-your-server-version-from-3-2-to-3-6-for-azure-cosmos-db-api-for-mongodb/) post.

4. Open the Command prompt, connect to build agent vm using the **Command to Connect to Build Agent VM**, which is given on lab environment details page.

5. When asked for the password, enter **Build Agent VM Password** given below.

   * build agent Password: **<inject key="Build Agent VM Password"></inject>**

6. On the **Build agent VM**, navigate to the `~/Fabmedical` directory.

    ```bash
    cd ~/Fabmedical
    ```

7. Run the following command to open the `perftest.sh` script for editing in Vim.

    ```bash
    vi perftest.sh
    ```

8. There are several variables declared at the top of the `perftest.sh` script. Modify the **host**, **username**, and **password** variables by setting their values to the corresponding Cosmos DB Connection String values that were copied previously.

    ![The screenshot shows Vim with perftest.sh file open and variables set to Cosmos DB Connection String values.](media/cosmos-perf-test-variables.png "Modify the connection information in Vim")

9. Then press **_ESC_**, write **_:wq_** to save you changes and close the file.
    
    **Note**: If **_ESC_** doesn't work press `ctrl+[` and then write **_:wq_** to save you changes and close the file.

10. Run the following command to execute the `perftest.sh` script to run a small load test against Cosmos DB. This script will consume RU's in Cosmos DB by inserting many documents into the Sessions container.

    ```bash
    bash ./perftest.sh
    ```

    > **Note:** The script will take a minute to complete executing.

11. Once the script has completed, navigate back to the **Cosmos DB account** in the Azure portal.

   ![](media/cna33.png "View replica details")

12. Scroll down on the **Overview** pane of the **Cosmos DB account** blade, and locate the **Request Charge** graph.

    > **Note:** It may take 2 - 5 minutes for the activity on the Cosmos DB collection to appear in the activity log. Wait a couple minutes and then refresh the pane if the recent Request charge doesn't show up right now.

13. Notice that the **Request charge** now shows there was activity on the **Cosmos DB account** that exceeded the 400 RU/s limit that was previously set before Autoscale was turned on.

    ![The screenshot shows the Cosmos DB request charge graph showing recent activity from performance test](media/cosmos-request-charge.png "Recent CosmosDB activity graph")
    
    >**Note**: In case if you don't see data on the graph. Please set the time range to last 1 hour.

14. Click on the **Next** button present in the bottom-right corner of this lab guide.


