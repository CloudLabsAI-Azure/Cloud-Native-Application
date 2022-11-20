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
    
1. 
    
