# Ejercicio 3: Implementar la aplicación en Azure Kubernetes Service

### Duración estimada: 120 minutos

## Descripción general

En este ejercicio, desplegará su aplicación web en contenedores hacia AKS (Azure Kubernetes Service) con la ayuda de Key Vault Secrets y ACR, donde almacenó las imágenes de su aplicación web en contenedores. Además, explorará dos formas de desplegar la aplicación en AKS.

## Objetivos del laboratorio

Podrá completar las siguientes tareas:

- Tarea 1: Tunelizar en el clúster de Azure Kubernetes Service
- Tarea 2: Implementar un espacio de nombres, un servicio y una carga de trabajo en Azure Kubernetes Service mediante el Portal de Azure
- Tarea 3: Implementar un servicio y una carga de trabajo mediante kubectl


## Tarea 1: Túnel hacia el clúster de Azure Kubernetes Service 

Esta tarea recopilará la información que necesita sobre su clúster de Azure Kubernetes Service para conectarse al clúster y ejecutar comandos para conectarse al panel de administración de Kubernetes desde Cloud Shell.

> **Nota**: Las siguientes tareas deben ejecutarse en el **Símbolo del sistema**.

1. Abra un nuevo símbolo del sistema como Administrador en su JumpVM e inicie sesión en Azure con los siguientes comandos después de actualizar los valores en el siguiente comando.
   
    ```bash
    az login -u <inject key="AzureAdUserEmail"></inject> -p <inject key="AzureAdUserPassword"></inject>
    ```    
    > **Nota:** Si encuentra algún error al ejecutar el comando 'az', ejecute el siguiente comando para instalar Azure CLI y cierre el símbolo del sistema. Vuelva a realizar el paso 1 en un nuevo símbolo del sistema como Administrador.

    ```bash
    choco install azure-cli
    ```
    ![](media/E3T1S1.png)

1. Ejecute el siguiente comando para configurar la conexión del clúster de Kubernetes utilizando kubectl.

   ```bash
   az aks get-credentials -a --name contoso-traders-aks<inject key="DeploymentID" enableCopy="true"/> --resource-group ContosoTraders-<inject key="DeploymentID" enableCopy="true"/>
   ```
   
    ![](media/E3T1S2.png)

1. Rápidamente ejecute un comando kubectl para generar una lista de nodos y verificar si la configuración es correcta.

   ```bash
   kubectl get nodes
   ```

    ![En esta captura de pantalla de la consola, kubectl get nodes se escribió y ejecutó en el símbolo del sistema, lo que produce una lista de nodos.](media/E3T1S3.png "kubectl get nodes")   


## Tarea 2: Implementar un espacio de nombres, un servicio y una carga de trabajo en Azure Kubernetes Service mediante el Portal de Azure
   
En esta tarea, implementará la aplicación API Carts en el clúster de Azure Kubernetes Service utilizando el Portal de Azure.
   
1. Ya hemos definido un nuevo **Espacio de nombres (1)** para el despliegue de su API. En el futuro, utilizará únicamente el espacio de nombres **contoso-traders (2)**. 

    ![Esta es una captura de pantalla del Portal de Azure mostrando cómo acceder a los espacios de nombres en AKS.](media/SE3T2S1.png "Espacios de nombres en AKS")
    
2. Defina un Servicio para su API, de modo que se pueda acceder a la aplicación dentro del clúster Seleccione la hoja **Servicios y entradas (1)** de la página de detalles del recurso AKS **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>** en el Portal de Azure. En la pestaña Servicios, seleccione **+ Crear (2)** y elija **Aplicar un YAML (3)**. 
    
    ![Esta es una captura de pantalla del Portal de Azure para AKS que muestra cómo agregar un servicio.](media/SE3T2S2.png "Agregando un Servicio")

3. En el panel **Aplicar con YAML**, pegue el siguiente código YAML que crea un servicio en AKS y haga clic en **Aplicar (2)**. Asegúrese de reemplazar SUFFIX con el valor DeploymentID **<inject key="DeploymentID" enableCopy="true"/> (1)** proporcionado en el archivo YAML.
    >**Información**: El siguiente script YAML creará un servicio AKS dentro del espacio de nombres contoso-traders que creó en los pasos anteriores. El servicio AKS es una forma abstracta de exponer una aplicación que se ejecuta en un conjunto de Pods como un servicio de red. 

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
    ![Agregando con YAML.](media/SE3T2S4.png "Agregando con YAML")

   **Nota:** Asegúrese de que la sangría en su script YAML coincida con el formato que se muestra en la imagen para evitar errores.

   **Nota:** Al ingresar el código YAML, si se le solicita la sugerencia **Borrador con Copilot**, haga clic en el botón **Cerrar** **(1)** para descartarla.

   ![](media/SE3T2S4-N.png)

1. Seleccione **Cargas de trabajo (1)** en la sección de recursos Kubernetes en el menú a la izquierda. Con **Implementaciones** seleccionado por defecto, elija **+ Crear (2)** y luego seleccione **Aplicar un YAML (3)**.

    ![Seleccione cargas de trabajo en los recursos de Kubernetes.](media/SE3T2S5.png "SSeleccione cargas de trabajo en los recursos de Kubernetes")

1. En el panel **Aplicar con YAML**, pegue el siguiente código YAML que crea un servicio en AKS y haga clic en **Aplicar (2)**. Asegúrese de reemplazar SUFFIX con el valor DeploymentID **<inject key="DeploymentID" enableCopy="true"/> (1)** proporcionado en el archivo YAML para actualizar el nombre LOGINSERVER de la instancia ACR.
    >**Información**: El siguiente archivo YAML creará pods de despliegue en el espacio de nombres contoso-traders. Una implementación de Kubernetes le dice a Kubernetes cómo crear o modificar instancias de los pods que contienen una aplicación en contenedores. Las implementaciones pueden ayudar a escalar de manera eficiente el número de réplicas de pods, permitir el despliegue de código actualizado de una manera controlada o volver a una versión de implementación anterior si es necesario.

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
   ![Agregando con YAML.](media/SE3T2S6.png "Agregando con YAML")

1. Después de unos minutos, verá la implementación en la lista, que debería estar ejecutándose.

   ![Implementación en ejecución.](media/SE3T2S7.png "Implementación en ejecución")

> **Felicitaciones** por completar la tarea. Ahora es momento de validarla. Estos son los pasos:
> - Si recibe un mensaje de éxito, puede continuar con la siguiente tarea.
> - Si no es así, lea atentamente el mensaje de error y vuelva a intentar el paso, siguiendo las instrucciones de la guía de laboratorio.
> - Si necesita ayuda, comuníquese con nosotros a cloudlabs-support@spektrasystems.com. Estamos disponibles las 24 horas, los 7 días de la semana para ayudarlo.

<validation step="5027ff24-34ab-49f1-9fa2-72e214db0831" />

## Tarea 3: Implementar un servicio y una carga de trabajo mediante kubectl

En esta tarea, implementará el servicio web y su carga de trabajo utilizando kubectl.

1. Abra un **Explorador de archivos** desde su JumpVM.

1. Navegue hasta el directorio `C:\LabFiles` **(1)** y seleccione el archivo `web.deployment.yml` **(2)**. Haga clic derecho y seleccione **Abrir** **(3)** para abrir el archivo en VS Code.

   ![](media/cloudnative8.png)

1. Asegúrese de actualizar **_SUFFIX_** con el valor DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** indicado en el archivo YAML para que coincida con el nombre de su servidor de inicio de sesión de ACR.

    ![En esta captura de pantalla se observa el nombre de la imagen.](media/cloudnative7.png "Nombre de imagen")

1. Guarde los cambios presionando **CTRL + S** para **Guardar**.

1. Vuelva al símbolo del sistema de Windows y ejecute el siguiente comando para cambiar el directorio a la carpeta `~/LabFiles`.

    ```bash
    cd C:/LabFiles
    ```

1. Inicie sesión en Azure si aún no lo ha hecho con el siguiente comando después de actualizar los valores en el comando.

    ```
    az login -u <inject key="AzureAdUserEmail"></inject> -p <inject key="AzureAdUserPassword"></inject>
    ```
    ![](media/E3T3S6.png)
1. Ejecute el siguiente comando para desplegar la aplicación descrita en los archivos YAML. Recibirá un mensaje indicando que el elemento `kubectl` ha creado una implementación web y un servicio web.
   
   >**Información**: El siguiente comando kubectl creará la carga de trabajo de implementación y el servicio en el espacio de nombres que hemos definido en los archivos YAML. 

    ```bash
    kubectl create --save-config=true -f web.deployment.yml -f web.service.yml 
    ```

    ![En esta captura de pantalla de la consola, kubectl create ha sido tecleado y ejecutado en el símbolo del sistema.](media/E3T3S7.png "Comando kubectl create")

1. Regrese a la hoja de AKS en el Portal de Azure. En el menú de navegación, seleccione **Servicios y entradas** en **Recursos de Kubernetes**. Debería poder acceder al sitio web a través de un **Punto de conexión externo**.

    ![Servicios y entradas de AKS mostrados con la IP externa resaltada](media/SE3T3S8.png "Servicios y entradas de AKS mostrados con la IP externa resaltada")

    ![Accediendo a la aplicación web](media/website2.png "Accediendo a la aplicación web")

   > **Nota:** Si el sitio web no se carga, intente actualizar la página varias veces, ya que AKS puede tardar un poco en completar el sitio web.
    
1. Haga clic en el botón **Siguiente** ubicado en la esquina inferior derecha de esta guía de laboratorio para continuar con el siguiente ejercicio.

> **Felicitaciones** por completar la tarea. Ahora es momento de validarla. Estos son los pasos:
> - Si recibe un mensaje de éxito, puede continuar con la siguiente tarea.
> - Si no es así, lea atentamente el mensaje de error y vuelva a intentar el paso, siguiendo las instrucciones de la guía de laboratorio.
> - Si necesita ayuda, comuníquese con nosotros a cloudlabs-support@spektrasystems.com. Estamos disponibles las 24 horas, los 7 días de la semana para ayudarlo.

<validation step="bf5a46a2-1e97-41f7-a010-d514c5e91636" />

## Resumen

En este ejercicio, implementó su aplicación web en contenedores en AKS que contiene el espacio de nombres, el servicio y la carga de trabajo en Azure Kubernetes. Además, creó un servicio para AKS y accedió al sitio web mediante un punto de conexión externo. Además, ha configurado el secreto del almacén de claves para acceder a MongoDB desde AKS.

![](media/3-sn.png "Next")