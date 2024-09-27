## Ejercicio 4: Escalar la aplicación y validar la Alta Disponibilidad

**Duración**: 40 minutos

## Descripción general

En este punto, ha desplegado una sola instancia de los contenedores de servicios Web y API Productos. En este ejercicio, aumentará el número de instancias de contenedor para el servicio web y escalará el front-end en el clúster existente.

### Tarea 1: Modificar las implementaciones de recursos de Kubernetes en el servicio de Kubernetes

En esta tarea, aumentará el número de instancias para la implementación del API en AKS. Mientras se está implementando, observará el estado cambiante.

1. Vaya al Portal de Azure, abra el servicio de Kubernetes **contoso-traders-aks<inject key="DeploymentID" enableCopy="false" />** del grupo de recursos **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />**. Seleccione **Cargas de trabajo (1)** en recursos de Kubernetes en el menú del lado izquierdo y luego seleccione la implementación **contoso-traders-products (2)**.

   ![Seleccionando la carga de trabajo en AKS.](media/1.png "Seleccionando la carga de trabajo en AKS")

1. Seleccione **YAML (1)** en el menú de la izquierda en la Descripción general de **contoso-traders-products** y desplácese hacia abajo hasta encontrar **réplicas** en la sección **especificaciones**. Cambie el número de réplicas a **2 (2)** y luego seleccione **Revisar + guardar (3)**. Cuando se le solicite Confirmar los cambios en el manifiesto, marque **Confirmar cambio de manifiesto** y seleccione **Guardar**.

   ![En el cuadro de diálogo de edición de YAML, se ingresa 2 en el número deseado de réplicas.](media/3.png "Configurando las réplicas en 2")

    >**Nota**: Si la implementación se completa rápidamente, es posible que no vea la implementación en estados de espera en el portal, como se describe en los siguientes pasos.

1. Actualmente se está implementando y puede ver que hay una instancia en estado sana y otra en espera.

1. Abra la aplicación web Contoso Traders y podrá comprobar que la aplicación sigue funcionando sin errores.

    ![Aplicación web funcionando correctamente.](media/11.png "Aplicación web funcionando correctamente")

    <validation step="cd2e41f5-e0af-43fc-97ac-3358da846e31" />

    > **Felicitaciones** por completar la tarea. Ahora es momento de validarla. Estos son los pasos:
    > - Si recibe un mensaje de éxito, puede continuar con la siguiente tarea.
    > - Si no es así, lea atentamente el mensaje de error y vuelva a intentar el paso, siguiendo las instrucciones de la guía de laboratorio.
    > - Si necesita ayuda, comuníquese con nosotros a labs-support@spektrasystems.com. Estamos disponibles las 24 horas, los 7 días de la semana para ayudarlo.

### Tarea 2: Resolver el aprovisionamiento de réplicas fallido

En esta tarea, resolverá las réplicas de API que han fallado. Estas fallas se producen por la imposibilidad de satisfacer los recursos solicitados.

1. En el servicio Kubernetes **contoso-traders-aks<inject key="DeploymentID" enableCopy="false" />**, seleccione **Cargas de trabajo (1)** y luego elija la implementación **contoso-traders-products (2)**. 

    ![Seleccionando la carga de trabajo.](media/exe4-task2-step1-select-workload.png "Seleccionando la carga de trabajo")

1. Seleccione **YAML** en el menú de la izquierda en la Descripción general de **contoso-traders-products**.

   ![Seleccionando YAML.](media/CNA-Ex4-task2-step2.png "Seleccionando YAML")

1. En la pantalla **YAML**, desplácese hacia abajo y cambie los siguientes elementos:

   - En la sección **especificaciones** agregue los siguientes **puertos (1)**.

      ```yaml
      ports:
        - containerPort: 3001
          protocol: TCP
      ```

   - Modifique la **cpu** y configúrela en **100m (2)**. La CPU se divide entre todos los Pods de un Nodo.

      ```yaml
      requests:
         cpu: 100m
         memory: 128Mi
      ```

      ![Modificando el manifiesto de implementación.](media/cloudnative10.png "Modificando el manifiesto de implementación.")

1. Seleccione **Revisar + guardar** y, cuando se le solicite Confirmar cambio de manifiesto, marque **Confirmar cambio de manifiesto** y seleccione **Guardar**.

1. Regrese a la vista principal **Cargas de trabajo** del servicio de Kubernetes **contoso-traders-aks<inject key="DeploymentID" enableCopy="false" />**, refresque la página y ahora verá que la implementación está sana con **dos** Pods en funcionamiento.

   ![Despliegue del API en estado sano.](media/2.png "Despliegue del API en estado sano.")       

### Tarea 3: Configurar el Autoescalado Horizontal para pods del servicio de Kubernetes

En esta tarea, configurará el autoescalado horizontal para sus pods del servicio de Kubernetes.
   
1. Vuelva al Símbolo del sistema de Windows.

1. Ejecute el siguiente comando para configurar el autoescalado horizontal para sus pods del API de Productos.

   ```bash 
   kubectl autoscale deployment contoso-traders-products -n contoso-traders --cpu-percent=50 --min=1 --max=10
   ```
   
   ![Configurando el autoescalado horizontal.](media/HS11.png "kubectl autoscale deployment")
   
1. Ejecute el siguiente comando para comprobar el estado del Autoescalador Horizontal de Pods recién añadido.

   ```
   kubectl get hpa -n contoso-traders
   ```
   
   ![Verificando el estado del autoscaler horizontal.](media/HS12.png "kubectl get hpa")

   >**Nota:** Si no obtiene el resultado esperado, espere unos minutos ya que puede tardar un tiempo en reflejarse.

### Tarea 4: Autoescalado en el clúster de Azure Kubernetes Service

En esta tarea, habilitará el autoescalador del clúster para el clúster de AKS existente y escalará automáticamente los grupos de nodos del clúster.

1. Vuelva al símbolo del sistema de Windows. Si no ha iniciado sesión en Azure, hágalo con el siguiente comando después de actualizar los valores en el comando.

   * Nombre de usuario: **<inject key="AzureAdUserEmail"></inject>**
   * Contraseña: **<inject key="AzureAdUserPassword"></inject>**

    ```
    az login -u <inject key="AzureAdUserEmail"></inject> -p <inject key="AzureAdUserPassword"></inject>
    ```

1. Para configurar la conexión del clúster de Kubernetes, asegúrese de reemplazar SUFFIX con el valor DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** proporcionado en el siguiente comando y ejecútelo.

    ```
    az aks get-credentials --resource-group ContosoTraders-SUFFIX --name contoso-traders-aksSUFFIX
    ```
    
1.  Verifique el `recuento` de grupos de nodos en el clúster y asegúrese de que `enableblingAutoScaling` sea `null`. Asegúrese de reemplazar SUFFIX con el valor DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** proporcionado en el siguiente comando.   
    
     ```
     az aks nodepool list --resource-group ContosoTraders-SUFFIX --cluster-name contoso-traders-aksSUFFIX
     ```   
    
    ![](media/ex4-t3-scaling1.png)

1. Ejecute el siguiente comando para habilitar el autoescalado del clúster en el clúster existente. Verifique que `enablementAutoScaling` sea `true`. Asegúrese de reemplazar SUFFIX con el valor DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** proporcionado en el siguiente comando.

    ```
    az aks update --resource-group ContosoTraders-SUFFIX --name contoso-traders-aksSUFFIX --enable-cluster-autoscaler --min-count 1 --max-count 3
    ```
  
   ![](media/ex4-t3-scaling2.png)
   
    >**Nota**: Tenga en cuenta que el comando anterior puede tardar hasta 5 minutos en finalizar la actualización. Antes de realizar cualquier otra acción, asegúrese de que se ejecute correctamente.
   
1. Ejecute el siguiente comando para escalar automáticamente los grupos de nodos en el clúster existente. Asegúrese de reemplazar SUFFIX con el valor DeploymentID **<inject key="DeploymentID" enableCopy="true"/>** proporcionado en el siguiente comando.

    ```
    az aks update --resource-group ContosoTraders-SUFFIX --name contoso-traders-aksSUFFIX --update-cluster-autoscaler --min-count 1 --max-count 5
    ```
   
   ![](media/ex4-t3-scaling3.png)
   
   >**Nota**: Tenga en cuenta que el comando anterior puede tardar hasta 5 minutos en finalizar la actualización. Antes de realizar cualquier otra acción, asegúrese de que se ejecute correctamente.

### Tarea 5: Reiniciar contenedores y validar HA

En esta tarea, reiniciará los contenedores y validará que el reinicio no afecte al servicio en ejecución.

1. En la hoja Azure Kubernetes Service, seleccione **Cargas de trabajo (1)** y luego seleccione la implementación **contoso-traders-product (2)**.

   ![En la vista Carga de trabajo con la implementación de API resaltada.](media/upd-upd-productwkrlos.png "La implementación de API ahora está en estado sano")

1. Seleccione el elemento de navegación **YAML (1)** y aumente el contador de réplicas requeridas a `4` **(2)**, luego haga clic en **Revisar + guardar (3)** y, cuando se le solicite Confirmar cambio de manifiesto, marque **Confirmar cambio de manifiesto** y seleccione **Guardar**.
 
   ![Editando el número de replicas.](media/4.png "Editando el número de replicas")

1. Después de unos momentos, encontrará que el despliegue de **contoso-traders-product** ahora está ejecutando `4` réplicas exitosamente.

   ![Viendo el conjunto de réplicas en el Portal de Azure.](media/5.png "Viendo el conjunto de réplicas en el Portal de Azure")

1. Regrese a la pestaña del navegador con la página de la aplicación web cargada. Actualice la página una y otra vez. No verá ningún error.

   ![Página web de Contoso Traders.](media/11.png "Página web de Contoso Traders")

1. Regrese a la página **contoso-traders-products| Descripción general**, seleccione **dos de los Pods (1)** al azar y elija **Eliminar (2)**.

   ![Eliminando dos pods en ejecución.](media/6.png "Eliminando dos pods en ejecución")

1. En la página **Eliminar**, seleccione **Confirmar eliminación (1)** y haga clic en **Eliminar (2)** nuevamente.

   ![Confirmando la eliminación de pods.](media/7.png "Confirmando la eliminación de pods")

1. Kubernetes lanzará nuevos Pods para cumplir con el número de réplicas requerido. Dependiendo de su vista, es posible que vea las instancias antiguas con el estado Finalizando y nuevas instancias con el estado Creado.

   ![API Pods cambiando de estado".](media/nwcontainer.png "API Pods cambiando de estado")

1. Regrese a la implementación de API de **contoso-traders-product**. Seleccione el elemento de navegación **YAML** y escale nuevamente a la réplica `1`.

   ![Editando YAML.](media/8.png "Editando YAML")

1. Seleccione **Revisar + guardar** y, cuando se le solicite Confirmar cambio de manifiesto, marque **Confirmar cambio de manifiesto** y seleccione **Guardar**.

1. Regrese a la página web de ContosoTraders en el navegador y actualice mientras Kubernetes reduce la cantidad de Pods. Debería poder ver el sitio web ejecutándose sin ningún problema.

    ![Sitio web ContosoTraders.](media/11.png "Sitio web ContosoTraders")

      <validation step="0cddaf1e-5cbe-4a3c-8b20-0e6999478048" />

### Tarea 6: Configurar Autoscale en CosmosDB

En esta tarea, configurará Autoscale en Azure Cosmos DB.

1. En el Portal de Azure, navegue hasta la cuenta Azure CosmosDB **Contosotraders-<inject key="DeploymentID" enableCopy="false" />**.

2. Seleccione **Explorador de datos (1)** del menú del lado izquierdo. En **Explorador de datos**, expanda la base de datos `contentdb` **(2)**.

    ![](media/9.png "MongoDB contentdb")

4. En la base de datos `contentdb`, expanda la colección **Items (1)**, seleccione **Settings (2)**.

    ![](media/exe4-task6-step3-select-settings.png "MogoDB contentdb")

5. En la pestaña **Scale & Settings (1)**, seleccione **Autoscale (2)** para la configuración **Throughput** en **Scale** y haga clic en **Save (3)**.

    ![La captura de pantalla muestra la pestaña Escala y configuración de Cosmos DB con Autoscale seleccionada](media/exe4-task6-step4-autoscale.png "Escala y configuración de la colección CosmosDB")

   <validation step="772e22fb-588f-41b1-b761-428e48c79279" />

### Tarea 7: Probar Autoscale de CosmosDB

En esta tarea, ejecutará un script de prueba de rendimiento que probará la característica Autoscale de Azure Cosmos DB para que pueda ver que ahora escalará a más de 400 RU/s.

1. En el Portal de Azure, navegue hasta la cuenta de Azure CosmosDB **contosotraders-<inject key="DeploymentID" enableCopy="false" />**.

2. Seleccione **Cadena de conexión** en **Configuración**.

   ![](media/cnctionstring1.png "Ver cadena de conexión")

3. En el panel **Cadena de conexión**, copie los valores **HOST (1)**, **NOMBRE DE USUARIO (2)** y **CONTRASEÑA PRINCIPAL (3)**. Guárdelos en un archivo de texto para usarlos más adelante.

    ![El panel Cadena de conexión de la cuenta de Cosmos DB con los campos para copiar resaltados.](media/cnctionstringnew.png "Ver Cadena de conexión de CosmosDB")

4. Abra el símbolo del sistema y conéctese a la MV del Agente de Compilación usando el comando  **<inject key="Command to Connect to Build Agent VM" enableCopy="true" />** proporcionado.

5. Cuando se le solicite la contraseña, ingrese la **Contraseña de la MV del Agente de Compilación** que se proporciona a continuación.

   * Contraseña: **<inject key="Build Agent VM Password" enableCopy="true" />**

6. En la **MV del Agente de Compilación**, mavegue hasta el directorio `~/labfiles`.

    ```bash
    cd Cloud-Native-Application/labfiles/src
    ```

7. Ejecute el siguiente comando para abrir el script `perftest.sh` en la ventana del editor.

    ```bash
    sudo chmod 777 perftest.sh
    vi perftest.sh
    ```

8. Hay varias variables declaradas en la parte superior del script `perftest.sh`. Presione **_i_** para ingresar al modo `insert`. Luego modifique las variables **host**, **username** y **password** estableciendo sus valores en los valores correspondientes de la Cadena de Conexión de Cosmos DB que se copiaron anteriormente.

    ![La captura de pantalla muestra Vim con el archivo perftest.sh abierto y las variables configuradas en valores de cadena de conexión de Cosmos DB.](media/updatepreftest.png "Modificar la información de conexión en Vim")

9. Luego presione **_ESC_**, escriba **_:wq_** para guardar los cambios y cerrar el archivo.
    
    >**Nota**: Si **_ESC_** no funciona, presione `ctrl+[` y luego escriba **_:wq_** para guardar los cambios y cerrar el archivo.
    
10. Ejecute el siguiente comando para ejecutar el script `perftest.sh` para ejecutar una pequeña prueba de carga en CosmosDB. Este script consumirá RUs en CosmosDB al insertar muchos documentos en el contenedor Sessions.

    ```bash
    bash ./perftest.sh
    ```

    > **Nota:** El script tardará unos minutos en completar su ejecución.

11. Una vez que se complete la ejecución del script, regrese a la **Cuenta de CosmosDB** en el Portal de Azure.

12. Desplácese hacia abajo en el panel **Descripción general** de la hoja **Cuenta de Cosmos DB** y busque el gráfico **Cargo de la solicitud**.

    > **Nota:** La actividad en la colección CosmosDB puede tardar de 2 a 5 minutos en aparecer en el registro de actividad. Espere un par de minutos y luego actualice la página si la carga de las solicitudes recientes no aparece en este momento.

13. Observe que el **Cargo de la solicitud** ahora muestra que hubo actividad en la **cuenta de CosmosDB** que superó el límite de 400 RU/s que se estableció previamente antes de activar Autoscale.

    ![La captura de pantalla muestra el gráfico de cargos de la solicitud de Cosmos DB que muestra la actividad reciente de la prueba de rendimiento](media/cosmos-request-charge.png "Gráfico de actividad reciente de CosmosDB")
    
    >**Nota**: En caso de que no vea datos en el gráfico, configure el rango de tiempo para que dure 1 hora.

14. Haga clic en el botón **Siguiente** ubicado en la esquina inferior derecha de esta guía de laboratorio para continuar con el siguiente ejercicio.

      

## Resumen

En este ejercicio, ha aumentado las instancias de servicio y configurado el autoescalado horizontal para los pods de AKS. Además, ha configurado y probado CosmosDB Autoscale.
