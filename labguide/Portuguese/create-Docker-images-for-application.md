# Exercício 1: Criar imagens Docker para a aplicação

### Duração estimada: 60 minutos

## Visão geral

Neste exercício, aprenderá a containerizar a aplicação Contoso Traders utilizando imagens Docker. As aplicações em contentores são aplicações que são executadas em ambientes de tempo de execução isolados, chamados contentores. Uma imagem Docker é um ficheiro utilizado para executar código num contentor Docker. As imagens Docker atuam como um conjunto de instruções para construir um contentor Docker, como um modelo. Além disso, enviará as imagens Docker criadas para o Azure Container Registry.

## Objetivos do laboratório

Irá completar as seguintes tarefas:

- Tarefa 1: Configurar uma infraestrutura local com a VM Linux
- Tarefa 2: Criar imagens Docker para colocar a aplicação em contentor e enviá-las para o Azure Container Registry

### Tarefa 1: Configurar uma infraestrutura local com a VM Linux

Nesta tarefa, irá ligar-se à VM do agente Build utilizando a linha de comandos e clonar o repositório GitHub onde está o código fonte do site da Contoso Trader.

1. Depois de iniciar sessão na VM, pesquise **prompt de Comando** **(1)** na barra de pesquisa do Windows e clique em **prompt de Comando** **(2)** para abrir.

   ![](../media/22-10-24(22).png "abrir cmd")

1. Execute o comando fornecido **<inject key="Command to Connect to Build Agent VM" enableCopy="true" />** para se ligar à VM Linux utilizando o ssh.

    >**Nota**: Na linha de comandos, digite **yes** e prima **Enter** para `Are you sure you want to continue connecting (yes/no/[fingerprint])?`

1. Assim que o SSH estiver ligado à VM, introduza a palavra-passe da VM fornecida abaixo:

    * Password: **<inject key="Build Agent VM Password" enableCopy="true" />**

      ![](../media/EX1-T1-S3.png "abrir cmd")

      >**Nota**: Note que ao introduzir a palavra-passe não a poderá ver devido a questões de segurança.

1. Assim que a VM estiver ligada, execute o comando abaixo para clonar o repositório GitHub que iremos utilizar no laboratório.

    ```
    git clone https://github.com/CloudLabsAI-Azure/Cloud-Native-Application
    ```

    ![](../media/EX1-T1-S4.png)

    > **Nota:** Se receber uma mensagem de saída a informar - o caminho de destino 'Cloud-Native-Application' já existe e não é um diretório vazio. Execute os comandos seguintes e execute novamente o passo 4 da tarefa.

    ```
    sudo su
    rm -rf Cloud-Native-Application
    exit
    ```

   ![](../media/EX1-T1-S4-1.png)

1. Após a conclusão da clonagem do GitHub, execute o comando abaixo para alterar o diretório para os ficheiros de laboratório.

    ```
    cd Cloud-Native-Application/labfiles/
    ```

   ![](../media/EX1-T1-S5.png)

### Tarefa 2: Criar imagens Docker para colocar a aplicação em contentor e enviá-las para o registo do contentor

Nesta tarefa, irá criar as imagens do Docker para containerizar a aplicação e enviá-las usando um comando push para o ACR (Azure Container Registry) para utilização posterior no AKS.

1. Certifique-se de estar no diretório **labfiles** antes de executar as próximas etapas, pois o docker build precisa encontrar o DockerFile para criar a imagem.

   ```
   cd Cloud-Native-Application/labfiles/
   ```

1. Execute o comando abaixo para baixar o Azure CLI,

   ```
   sudo apt install azure-cli
   ```

   >**Nota:** no prompt de comando, digite **Y** e pressione **Enter** para **Você quer continuar? [S/n]**.

1. Execute o comando abaixo para iniciar sessão no Azure, navegue até ao URL de início de sessão do dispositivo `https://microsoft.com/devicelogin` no browser e copie o código de autenticação.

    ```
    az login
    ```

   ![](../media/EX1-T2-S1.png)

1. Introduza o código de autenticação copiado **(1)** e clique em **Seguinte** **(2)**.

   ![](../media/1-10-24(10).png)

1. No separador **Faça login na sua conta** verá um ecrã de login, nele digite o seguinte e-mail/nome de utilizador e clique em **Seguinte**.

    * E-mail/Nome de utilizador: **<inject key="AzureAdUserEmail"></inject>**

      > **Nota:** Se receber um pop-up **Escolha uma conta**, selecione o ID de e-mail acima.

1. Agora digite a seguinte palavra-passe e clique em **Entrar**.

    * Palavra-passe: **<inject key="AzureAdUserPassword"></inject>**

      > **Nota:** Não verá o pop-up para introduzir a palavra-passe se tiver o pop-up **Escolha uma conta** onde escolheu a conta.

1. Num pop-up para confirmar o início de sessão na CLI do Microsoft Azure, clique em **Continuar**.

   ![](../media/1-10-24(11).png)

1. Depois de entrar, verá um pop-up de confirmação **Entrou na aplicação Interface de linha de comando multiplataforma do Microsoft Azure no seu dispositivo**. Feche o separador do navegador e abra a sessão anterior do comando de linha.

   ![](../media/1-10-24(17).png)

1. Depois de fazer login no Azure, irá construir as imagens do Docker nos próximos passos e enviá-las para o ACR.

   ![](../media/EX1-T2-S6.png)

1. Certifique-se de que está no diretório **labfiles** antes de executar os próximos passos, pois a construção do docker precisa de encontrar o DockerFile para criar a imagem.

    ```
    cd Cloud-Native-Application/labfiles/
    ```

1. Agora crie a imagem docker **contosotraders-carts** utilizando o Dockerfile no diretório. Observe como o Registo de Contentor do Azure implantado é referenciado.

    ```
    docker build src -f ./src/ContosoTraders.Api.Carts/Dockerfile -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapicarts:latest -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapicarts:latest
    ```

   ![](../media/1-10-24(14).png)

1. Repita os passos para criar a imagem docker **contosotraders-Products** com o comando abaixo.

    ```
    docker build src -f ./src/ContosoTraders.Api.Products/Dockerfile -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapiproducts:latest -t contosotradersacr<inject key="DeploymentID" enableCopy="false"/>.azurecr.io/contosotradersapiproducts:latest
    ```

   ![](../media/1-10-24(14).png)

1. Execute o comando abaixo para alterar o directório para `services` e abra o ficheiro `configService.js`.

    ```
    cd src/ContosoTraders.Ui.Website/src/services
    sudo chmod 777 configService.js
    vi configService.js
    ```

   ![](../media/EX1-T2-S10.png)

1. No editor `vi`, prima **_i_** para entrar no modo `insert`. Em APIUrl e APIUrlShoppingCart, substitua **deploymentid** pelo valor **<inject key="DeploymentID" enableCopy="true"/>** e **REGION** por **<inject key="Region" enableCopy= "true"/>** valor. De seguida, prima **_ESC_**, escreva **_:wq_** para guardar as suas alterações e feche o ficheiro. Precisamos de atualizar o URL da API aqui para que a aplicação Contoso Traders possa ligar-se à API do produto depois de enviado para contentores AKS.

    >**Nota**: Se **_ESC_** não funcionar pressione `ctrl + [` e depois escreva **_:wq_** para guardar as suas alterações e fechar o ficheiro.

    ```
    const APIUrl = 'http://contoso-traders-products<inject key="DeploymentID" enableCopy="true"/>.<inject key="Region" enableCopy="true"/>.cloudapp.azure.com/v1';
    const APIUrlShoppingCart = 'https://contoso-traders-carts<inject key="DeploymentID" enableCopy="true"/>.orangeflower-95b09b9d.<inject key="Region" enableCopy="true"/>.azurecontainerapps.io/v1';
    ```

   ![](../media/cdnfix1.png)

1. Execute o comando abaixo para alterar o directório para a pasta `ContosoTraders.Ui.Website`.

    ```
    cd
    cd Cloud-Native-Application/labfiles/src/ContosoTraders.Ui.Website
    ```

1. Crie agora a imagem docker **contosotraders-UI-Website** com o comando abaixo.

    ```
    docker build . -t contosotradersacr<inject key="DeploymentID" enableCopy="true"/>.azurecr.io/contosotradersuiweb:latest -t contosotradersacr<inject key="DeploymentID" enableCopy="true"/>.azurecr.io/contosotradersuiweb:latest
    ```

   ![](../media/EX1-T2-S13.png)

   >**Nota**: Tenha em atenção que o comando acima pode demorar até 5 minutos para completar a compilação. Antes de realizar qualquer ação adicional, certifique-se de que é executada com sucesso. Além disso, poderá notar alguns avisos relacionados com a atualização da versão do npm que é esperada e não afeta a funcionalidade do laboratório.

1. Redirecione para o diretório **labfiles** antes de executar os próximos passos.

    ```
    cd
    cd Cloud-Native-Application/labfiles/
    ```

1. Observe as imagens Docker construídas executando o comando `docker image ls`. As imagens são marcadas com o que há de mais recente, sendo também possível utilizar outros valores de tag para versionamento.

    ```
    docker image ls
    ```

   ![](../media/EX1-T2-S15.png)

1. Navegue até ao portal Azure, abra o Container Registry **contosotradersacr<inject key="DeploymentID" enableCopy="false" />** no Grupo de Recursos **ContosoTraders-<inject key="DeploymentID" enableCopy="false" />**.

   ![](../media/1-10-24(15).png)

1. No Container Registry **contosotradersacr<inject key="DeploymentID" enableCopy="false" />** **(1)**, selecione **Chave de acesso** **(2)** em Settings à esquerda menu lateral. **Cópia** **(3)** a palavra-passe e cole-a num ficheiro de texto para utilização posterior.

   ![](../media/1-10-24(16).png)

1. Agora inicie sessão no ACR utilizando o comando abaixo, atualize o valor do sufixo e da palavra-passe do ACR no comando abaixo. Deve conseguir ver a saída abaixo na captura de ecrã. Certifique-se de substituir a palavra-passe pela palavra-passe copiada do registo do contentor que copiou no passo anterior no comando abaixo.

    ```
    docker login contosotradersacr<inject key="DeploymentID" enableCopy="true"/>.azurecr.io -u contosotradersacr<inject key="DeploymentID" enableCopy="true"/> -p [password]
    ```

   ![](../media/EX1-T2-S18.png "abrir cmd")

1. Depois de iniciar sessão no ACR, execute os comandos abaixo para enviar as imagens do Docker para o registo de contentores do Azure.

    ```
    docker push contosotradersacr<inject key="DeploymentID" enableCopy="true"/>.azurecr.io/contosotradersapicarts:latest 
    ```

    ```
    docker push contosotradersacr<inject key="DeploymentID" enableCopy="true"/>.azurecr.io/contosotradersapiproducts:latest
    ```

    ```
    docker push contosotradersacr<inject key="DeploymentID" enableCopy="true"/>.azurecr.io/contosotradersuiweb:latest
    ```

1. Deverá conseguir ver a imagem do docker a ser enviada para o ACR, como mostra a captura de ecrã abaixo.

   ![](../media/cloudnative2.png "abrir cmd")

1. Clique no botão **próximo** localizado no canto inferior direito deste guia de laboratório para continuar com o próximo exercício.

## Resumo

Neste exercício, containerizou completamente a sua aplicação web com a ajuda do docker e enviou-a para o registo do contentores.

### Concluiu o laboratório com sucesso
