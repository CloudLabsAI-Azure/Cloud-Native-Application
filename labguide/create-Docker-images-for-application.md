# Exercise 1: Create Docker Images for Application

### Task 1: Create Local Infrastructure using Linux VM

1. Once you log into the VM, open **Command Prompt** from the desktop of your VM on the left side of the environment.

    ![](media/cmd.png "open cmd")
    
1. Run the given command **<inject key="Command to Connect to Build Agent VM" enableCopy="true" />** to connect to the Linux VM using ssh.
   
   >**Note**: In the command prompt, type **yes** and press **Enter** for `Are you sure you want to continue connecting (yes/no/[fingerprint])?`
   
1. Once the ssh is getting connected to the VM, please enter the VM password given below:
   
    * Password: <inject key="Build Agent VM Password" enableCopy="true" />

   ![](media/ex1-connecttolinuxvm.png "open cmd")
   
   >**Note**: Please note that while typing the password you wont be able to see it due to the security concerns.
    
1. Once the VM is connected, run the below command to clone the Github repository that we are going to use for the lab.

    ``` 
    git clone https://github.com/CloudLabsAI-Azure/Cloud-Native-Application
    ```
    
    ![](media/ex1-gitclone.png)
    
1. After the github cloning is completed, run the below command to change the directory to the labfiles.
    
    ```
    cd Cloud-Native-Application/labfiles/ 
    ```
    
    ![](media/ex1-cd.png)
    
### Task 2: Create Docker images and push to container registry

In this task, you will be building the docker image and will be pushing them to the ACR to later use in AKS

1. Run the below command to login to Azure, navigate to device login URL `https://microsoft.com/devicelogin` in the browser and copy the authentication code.

   ``` 
   az login
   ```
    
   ![](media/ex-azlogincode.png)
    
1. Enter the copied authentication code **(1)** and click on **Next** **(2)**.

   ![](media/ex1-codelogin.png)
   
1. On **Sign in to Microsoft Azure** tab you will see login screen, in that enter following email/username and then click on **Next**.

   * Email/Username: <inject key="AzureAdUserEmail"></inject>

1. Now enter the following password and click on **Sign in**.

   * Password: <inject key="AzureAdUserPassword"></inject> 

1. In a pop-up to confirm the sign in to Microsoft Azure CLI, click on **Continue**.

   ![](media/ex1-logincontinue.png)

1. Once you logged in to Azure, you are going to build the Docker images in the next steps and will be pushing them to ACR.

   ![](media/ex1-logincomplete.png)

1. Please make sure that you are in **labfiles** directory before running the next steps.

    ```
    cd Cloud-Native-Application/labfiles/
    ```
    
1. Now build the contosotraders-carts container image using the Dockerfile in the directory. Note how the deployed Azure Container Registry is referenced. Replace the SUFFIX placeholder in the command with the given DeploymentID <inject key="DeploymentID" enableCopy="true"/> value.

    ```
     docker build src -f ./src/ContosoTraders.Api.Carts/Dockerfile -t contosotradersacr[SUFFIX].azurecr.io/contosotradersapicarts:latest -t contosotradersacr[SUFFIX].azurecr.io/contosotradersapicarts:latest
    ```
    
    ![](media/ex1-apicarts.png)
    
1. Repeat the steps to create the contosotraders-Products docker image with the below command. Make sure to replace the SUFFIX with the given DeploymentID <inject key="DeploymentID" enableCopy="true"/> value in the below command.

    ```
     docker build src -f ./src/ContosoTraders.Api.Products/Dockerfile -t contosotradersacr[SUFFIX].azurecr.io/contosotradersapiproducts:latest -t contosotradersacr[SUFFIX].azurecr.io/contosotradersapiproducts:latest
    ```

    ![](media/ex1-apiproducts.png)

1. Repeat the steps to create the contosotraders-UI-Website docker image with the below command. Make sure to replace the SUFFIX with the given DeploymentID <inject key="DeploymentID" enableCopy="true"/> value in the below command.

    ```
    cd src/ContosoTraders.Ui.Website
    docker build . -t contosotradersacr[SUFFIX].azurecr.io/contosotradersapiproducts:latest -t contosotradersacr[SUFFIX].azurecr.io/contosotradersuiweb:latest
    ```    
    
    ![](media/ex1-apiwebsite.png)
    
1. Redirect to the **labfiles** directory before running the next steps.

    ```
    cd Cloud-Native-Application/labfiles/
    ```

1. Observe the built Docker images by running command `docker image ls`. The images were tagged with latest, but it is possible to use other tag values for versioning.

    ```
    docker image ls
    ```

    ![](media/ex1-dockerimages.png)
    
1. Now login to ACR using the below commands, please update the Suffix and ACR password value in the below command. You should be able to see that output as below in the screenshot.

    ```
    docker login contosotradersacr[SUFFIX].azurecr.io -u contosotradersacr[SUFFIX] -p [password]
    ```

    ![](media/ex1-dockerlogin.png "open cmd")

1. Once you logged in to the ACR, please run the below commands to push the Docker images to Azure container registry. Also, make sure to update the SUFFIX value.

   ```
   docker push contosotradersacr[SUFFIX].azurecr.io/contosotradersapicarts:latest 
   ```
   
   ```
   docker push contosotradersacr[SUFFIX].azurecr.io/contosotradersapiproducts:latest
   ```
   
   ```
   docker push contosotradersacr[SUFFIX].azurecr.io/contosotradersuiweb:latest
   ```
   
1. You should be able to see the docker image getting pushed to ACR as per the below screenshots. 
    
    ![](media/ex1-dockerpush.png "open cmd")
    
