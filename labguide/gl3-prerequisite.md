## Pre-requisites 

Before you move to the next exercise, please make sure to complete the pre-requisite exercises as upcoming exercises are dependent on it.

### Overview

In this exercise, you will learn how to Containerize the Contoso Traders application using Docker images. Containerized applications are applications that run in isolated runtime environments called containers. A Docker image is a file used to execute code in a Docker container. Docker images act as a set of instructions to build a Docker container, like a template. Also, you will be pushing the created Docker images to the Azure Container Registry.

### Exercise 1: Build Docker Images for the Application 
  
**Duration**: 60 Minutes
   
### Task 1: Set up a local infrastructure with the Linux VM

In this task, you will be connecting to the Build agent VM using the Command prompt and will be cloning the Contoso trader website GitHub repo.  

1. Once you log into the VM, search for **cmd** **(1)** in the Windows search bar and click on **Command Prompt** **(2)** to open.

   ![](media/latest-ex1-opencmd.png "open cmd")
    
1. Run the given command **<inject key="Command to Connect to Build Agent VM" enableCopy="true" />** to connect to the Linux VM using ssh.
   
   >**Note**: In the command prompt, type **yes** and press **Enter** for `Are you sure you want to continue connecting (yes/no/[fingerprint])?`
   
1. Once the SSH is connected to the VM, please enter the VM password given below:
   
   * Password: **<inject key="Build Agent VM Password" enableCopy="true" />**

   ![](media/EX1-T1-S3.png "open cmd")
   
   >**Note**: Please note that while typing the password you won’t be able to see it due to security concerns.
    
1. Once the VM is connected, run the below command to clone the GitHub repository that we are going to use for the lab.

   ``` 
   git clone https://github.com/CloudLabsAI-Azure/Cloud-Native-Application
   ```
    
   ![](media/EX1-T1-S4.png)
    
   > **Note:** If you receive an output message stating - the destination path 'Cloud-Native-Application' already exists and is not an empty directory. Please run the following commands and then reperform step - 4 of the task.

   ```
   sudo su
   rm -rf Cloud-Native-Application
   exit
   ```   
   ![](media/EX1-T1-S4-1.png)
    
1. After the GitHub cloning is completed, run the below command to change the directory to the lab files.
    
   ```
   cd Cloud-Native-Application/labfiles/ 
   ```
    
   ![](media/EX1-T1-S5.png)
    
### Task 2: Build Docker images to containerize the application and push them to the container registry

In this task, you will be building the docker images to containerize the application and will be pushing them to the ACR (Azure Container Registry) to later use in AKS.

1. Run the below command to log in to Azure, navigate to the device login URL `https://microsoft.com/devicelogin` in the browser and copy the authentication code.

   ``` 
   az login
   ```
    
   ![](media/EX1-T2-S1.png)
    
1. Enter the copied authentication code **(1)** and click on **Next** **(2)**.

   ![](media/ex1-codelogin.png)
   
1. On the **Sign in to your account** tab you will see a login screen, in that enter the following email/username and then click on **Next**.

   * Email/Username: **<inject key="AzureAdUserEmail"></inject>**

   > **Note:** If you get a **Pick an account** popup, select the above Email ID.

1. Now enter the following password and click on **Sign in**.

   * Password: **<inject key="AzureAdUserPassword"></inject>**

   > **Note:** You will not get the popup to enter the password if you had got the **Pick an account** popup where you had chosen the account.

1. In a pop-up to confirm the sign-into Microsoft Azure CLI, click on **Continue**.

   ![](media/ex1-logincontinue.png)

1. After signing-in, you will see a confirmation popup **You have signed in to the Microsoft Azure Cross-platform Command Line Interface application on your device**. Close the browser tab and open the previous Command Prompt session.   

   ![](media/ex1-t2-step6-signin-confirm.png)

1. Once you log in to Azure, you are going to build the Docker images in the next steps and will be pushing them to ACR.

   ![](media/EX1-T2-S6.png)

1. Please make sure that you are in the **labfiles** directory before running the next steps as the docker build needs to find the DockerFile to create the image.

   ```
   cd Cloud-Native-Application/labfiles/
   ```
    
1. Now build the **contosotraders-carts** docker image using the Dockerfile in the directory. Take note of how the deployed Azure Container Registry is referenced.

   ```
   docker build src -f ./src/ContosoTraders.Api.Carts/Dockerfile -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapicarts:latest -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapicarts:latest
   ```
    
   ![](media/EX1-T2-S8.png)
    
1. Repeat the steps to create the **contosotraders-Products** docker image with the below command.

   ```
   docker build src -f ./src/ContosoTraders.Api.Products/Dockerfile -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapiproducts:latest -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapiproducts:latest
   ```

   ![](media/EX1-T2-S9.png)

1. Run the below command to change the directory to `services` and open the `configService.js` file.

   ```
   cd src/ContosoTraders.Ui.Website/src/services
   sudo chmod 777 configService.js
   vi configService.js
   ```
    
   ![](media/EX1-T2-S10.png)
    
1. In the `vi` editor, press **_i_** to get into the `insert` mode. In the APIUrl and APIUrlShoppingCart, replace **deploymentid** with **<inject key="DeploymentID" enableCopy="true"/>** value and **REGION** with **<inject key="Region" enableCopy="true"/>** value. Then press **_ESC_**, write **_:wq_** to save your changes, and close the file. We need to update the API URL here so that the Contoso Traders application can connect to product API once it's pushed to AKS containers.
    
   >**Note**: If **_ESC_** doesn't work press `ctrl + [` and then write **_:wq_** to save you changes and close the file.
    

   ```
   const APIUrl = 'http://contoso-traders-productsdeploymentid.REGION.cloudapp.azure.com/v1';
   const APIUrlShoppingCart = 'https://contoso-traders-cartsdeploymentid.orangeflower-95b09b9d.REGION.azurecontainerapps.io/v1';
   ```

   ![](media/cdnfix1.png)

1. Run the below command to change the directory to the `ContosoTraders.Ui.Website` folder.

   ```
   cd
   cd Cloud-Native-Application/labfiles/src/ContosoTraders.Ui.Website
   ```

1. Now build the **contosotraders-UI-Website** docker image with the below command.

   ```
   docker build . -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersuiweb:latest -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersuiweb:latest
   ```    
    
   ![](media/EX1-T2-S13.png)
    
    
   >**Note**: Please be aware that the above command may take up to 5 minutes to finish the build. Before taking any further action, make sure it runs successfully. Also, you many notice few warnings related to npm version update which is expected and doesn't affect the lab's functionality.
    
1. Redirect to the **labfiles** directory before running the next steps.

   ```
   cd
   cd Cloud-Native-Application/labfiles/
   ```

1. Observe the built Docker images by running the command `docker image ls`. The images are tagged with the latest, also it is possible to use other tag values for versioning.

   ```
   docker image ls
   ```

   ![](media/EX1-T2-S15.png)

1. Navigate to Azure portal, open **contosotradersacr<inject key="DeploymentID" enableCopy="false" />** Container registry from **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />** resource group.

   ![](media/ex1-acr1.png)
   
1. From **contosotradersacr<inject key="DeploymentID" enableCopy="false" />** **(1)** Container registry, select **Access keys** **(2)** under Settings from left side menu. **Copy** **(3)** the Password and paste it into a text file for later use.

   ![](media/ex1-acr2.png)    

1. Now switch back to **Command Prompt** and login to ACR using the below command, please update the ACR password value in the below command. You should be able to see that output below in the screenshot. Make sure to replace the password with the copied container registry password which you have copied in the previous step in the below command.

   ```
   docker login contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io -u contosotradersacr<inject key="DeploymentID" enableCopy="false"/> -p [password]
   ```

   ![](media/EX1-T2-S18.png "open cmd")

1. Once you log in to the ACR, please run the below commands to push the Docker images to the Azure container registry.

   ```
   docker push contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapicarts:latest 
   ```
   
   ```
   docker push contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapiproducts:latest
   ```
   
   ```
   docker push contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersuiweb:latest
   ```
   
1. You should be able to see the docker image getting pushed to ACR as shown in the below screenshot. 
    
   ![](media/cloudnative2.png "open cmd")
    

## Summary

In this exercise, you have deployed your containerized web application to AKS that contains, the namespace, service, and workload in Azure Kubernetes. Also, you have created a service to AKS and accessed the website using an external endpoint. Also, you have set up the secret of the key vault to access the MongoDB from AKS.

### Exercise 2: Migrate MongoDB to Cosmos DB using Azure Database Migration
  
**Duration**: 60 Minutes

### Overview

In this exercise, you will be migrating your on-premises MongoDB database hosted over Azure Linux VM to Azure CosmosDB using Azure database migration. Azure Database Migration Service is a tool that helps you simplify, guide, and automate your database migration to Azure.

### Task 1: Explore the databases and collections in MongoDB

In this task, you will be connecting to a Mongo database hosted over an Azure Linux VM and exploring the databases and collections in it.

1. While connected to your Linux VM, run the below command for connecting to Mongo shell to display the databases and collections in it using the Mongo shell.

   ```
   mongo
   ```
   
   >**Note**: If you face an issue while connecting to the source DB with an error connection is refused. Run the **<inject key="Command to Connect to Build Agent VM" enableCopy="true" />** command and enter the VM password **<inject key="Build Agent VM Password" enableCopy="true" />** to connect to the Linux VM using ssh. Please run the following commands and reperform step - 1 of the task.

   ```
   sudo apt install mongodb-server
   cd /etc
   sudo sed -i 's/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/g' /etc/mongodb.conf
   sudo sed -i 's/#port = 27017/port = 27017/g' /etc/mongodb.conf
   sudo service mongodb stop
   sudo service mongodb start
   ```
   
   ![](media/EX2-T1-S1.png)
   
1. Run the following commands to verify the database in the Mongo shell. You should be able to see the **contentdb** available and **item & products** collections inside **contentdb**.

   ```
   show dbs
   use contentdb
   show collections
   ```
   
   ![](media/mongo.png) 

   >**Note**: In case you don't see the data inside the Mongo. Please follow the steps mentioned below.

   - Enter `exit` to exit from Mongo.

   - Please run the below-mentioned commands in the command prompt and perform steps 1 and 2 again.

   ```
   cd ~/Cloud-Native-Application/labfiles/src/developer/content-init
   sudo npm ci
   nodejs server.js
   ```     

### Task 2: Create a Migration Project and migrate data to Azure CosmosDB

In this task, you will create a Migration project within Azure Database Migration Service, and then migrate the data from MongoDB to Azure Cosmos DB. In the later exercises, you will be using the Azure CosmosDB to fetch the data for the products page. 

1. In the Azure Portal, navigate to your **contosotraders** virtual machine in the **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />** resource group. Copy the **Private IP address** and paste it on the notepad for later use.

   ![](media/privateip.png)

1. Navigate to **ContosoTraders<inject key="DeploymentID" enableCopy="false" />(1)** resource group and open **contosotraders-<inject key="DeploymentID" enableCopy="false" />(2)** CosmosDB resource and click on **Data Explorer(3)**. Now click on drop down arrow, adjacent to **New Collection(4)** and then select **New Database(5)**.

   ![](media/Ex2T2S2.png)

   > **Note:** If you get **Welcome! What is Cosmos DB?** popup, close it by click on **X**.

1. Provide name as `contentdb` **(1)** for **Database id** and select **Databse throughput** as **Manual** **(2)**,  provide the RU/s value to `400` **(3)** and click on **OK(4)**.

   ![](media/Ex2T2S3.png)

1. Navigate to the Azure Database Migration Service **contosotraders<inject key="DeploymentID" enableCopy="false" />** resource blade in the **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />** resource group.

1. On the Azure Database Migration Service blade, select **+ New Migration Project** on the **Overview** pane.

   ![](media/newproject.png)

1. On the **New migration project** pane, enter the following values and then select **Create and run activity**:

   - Project name: `contoso`
   - Source server type: `MongoDB`
   - Target server type: `CosmosDB (MongoDB API)`
   - Migration activity type: `Offline data migration`

      ![The screenshot shows the New migration project pane with values entered.](media/ex2-newmigrationproject.png  "New migration project pane")

   >**Note**: The **Offline data migration** activity type is selected since you will be performing a one-time migration from MongoDB to Cosmos DB. Also, the data in the database won't be updated during the migration. In a production scenario, you will want to choose the migration project activity type that best fits your solution requirements.

1. On the **MongoDB to Azure Database for CosmosDB Offline Migration Wizard** pane, enter the following values for the **Select source** tab:

   - Mode: **Standard mode**
   - Source server name: Enter the Private IP Address of the Build Agent VM used in this lab.
   - Server port: `27017`
   - Require SSL: Unchecked

   > **Note:** Leave the **User Name** and **Password** blank as the MongoDB instance on the Build Agent VM for this lab does not have authentication turned on. The Azure Database Migration Service is connected to the same VNet as the Build Agent VM, so it's able to communicate within the VNet directly to the VM without exposing the MongoDB service to the Internet. In production scenarios, you should always have authentication enabled on MongoDB.

      ![Select source tab with values selected for the MongoDB server.](media/CNV2-E2-T2-S5.png "MongoDB to Azure Database for CosmosDB - Select source")
    
   > **Note:** If you face an issue while connecting to the source DB with an error connection is refused. Please run the following commands in **build agent VM connected in CloudShell**. You can use the **Command to Connect to Build Agent VM**, which is given on the lab environment details page.

   ```bash
   sudo apt install mongodb-server
   cd /etc
   sudo sed -i 's/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/g' /etc/mongodb.conf
   sudo sed -i 's/#port = 27017/port = 27017/g' /etc/mongodb.conf
   sudo service mongodb stop
   sudo service mongodb start
   ```
    
1. Select **Next: Select target >>**.

1. On the **Select target** pane, select the following values:

   - Mode: **Select Cosmos DB target**

   - Subscription: Select the Azure subscription you're using for this lab.

   - Select Cosmos DB name: Select the **contosotraders-<inject key="DeploymentID" enableCopy="false" />** Cosmos DB instance.

      ![The Select target tab with values selected.](media/targetmongo.png "MongoDB to Azure Database for CosmosDB - Select target")

   Notice, that the **Connection String** will automatically populate with the Key for your Azure Cosmos DB instance.

1. Select **Next: Database setting >>**.

1. On the **Database setting** tab, select the `contentdb` **Source Database**, so this database from MongoDB will be migrated to Azure Cosmos DB.

   ![The screenshot shows the Database setting tab with the contentdb source database selected.](media/contentdb.png "Database setting tab")

1. Select **Next: Collection setting >>**.

1. On the **Collection setting** tab, expand the **contentdb** database, and ensure both the **products** and **items** collections are selected for migration. Also, update the **Throughput (RU/s)** to `400` for both collections.

   ![The screenshot shows the Collection setting tab with both items and items collections selected with Throughput RU/s set to 400 for both collections.](media/db3.png "Throughput RU")

1. Select **Next: Migration summary >>**.

1. On the **Migration summary** tab, enter `MigrateData` in the **Activity name** field, and then select **Start migration** to initiate the migration of the MongoDB data to Azure Cosmos DB.

   ![The screenshot shows the Migration summary is shown with MigrateData entered in the Activity name field.](media/cloudnative3.png "Migration summary")

1. The migration activity's status will be displayed. The migration will be finished in a matter of seconds. Select **Refresh** to reload the status and ensure it is **complete**. 

   ![The screenshot shows the MigrateData activity showing the status has completed.](media/completed.png "MigrateData activity completed")

1. To verify the migrated data, navigate to the **contosotraders-<inject key="DeploymentID" enableCopy="false" />** Azure CosmosDB for MongoDB account in the **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />** resource group. Select **Data Explorer** from the left menu.

   ![The screenshot shows the Cosmos DB is open in the Azure Portal with Data Explorer open showing the data has been migrated.](media/dataexplorer.png "Cosmos DB is open")

1. You will see the `items` and `products` collections listed within the `contentdb` database and you will be able to explore the documents.

   ![The screenshot shows the Cosmos DB is open in the Azure Portal with Data Explorer open showing the data has been migrated.](media/migrates2.png "Cosmos DB is open")

1. Within the **contosotraders-<inject key="DeploymentID" enableCopy="false" />** **(1)** Azure CosmosDB for MongoDB account. Select **Quick start** **(2)** from the left menu and **Copy** the **PRIMARY CONNECTION STRING** **(3)** and paste it into the text file for later use in the next exercise.

   ![](media/ex2-cdb-copycs.png)

1. Click the **Next** button located in the bottom right corner of this lab guide to continue with the next exercise.

#### Validation

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide. 
> - If you need any assistance, please contact us at labs-support@spektrasystems.com. We are available 24/7 to help you out.
<validation step="ee0ef7bb-5d78-4a69-8e01-f3df1020fb41" />

## Summary

In this exercise, you have completed exploring your on-prem Mongodb and migrating your on-premises MongoDB database to Azure CosmosDB using Azure database migration.

