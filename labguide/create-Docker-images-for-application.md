## Exercise 1: Create Docker Images for Application



### Task 1: Create Local Infrastructure using Linux VM

1. Once you log into the VM open **Connand Prompt** from the desktop of your VM on the left side of the envrionment.

    ![.](media/cmd.png "open cmd")
    
1. After the CMD is open, use the below command to connect to the Linux VM using ssh.

    
   ```bash
   Command to create an active session to the build agent VM:

       ssh -i ~/.ssh/fabmedical adminfabmedical@<PUBLIC IP OF VM>
   ```
   
   ![.](media/sshvm.png "open cmd")
   
1. Once the ssh is getting connected to the VM, please enter the VM password as **VMPASS**
   > Note: Please note that while typing the password you wont be able to see it due to the security concerns

    ![.](media/connectedvm.png "open cmd")
    
1. Once the VM is connect, run the below command to clone the Github repositry that we are going to use for the lab.

    ``` 
    git clone https://github.com/CloudLabsAI-Azure/Cloud-Native-Application ```
    
1. After the github clonning is completed, run the below command to change the directory to the labfiles where we will be working on the labguide
    
    ```
    cd Cloud-Native-Application/labfiles/  ```


Task 2: Create docker images and push to container registry.

    In this task you will be building the docker image and will be pushing them to the ACR to later use in AKS

1. run the below command to login to Azure 

    ``` 
    az login ```

1. Once you logged in to azure
