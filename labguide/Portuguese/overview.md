# Aplicações nativas da nuvem

### Duração geral estimada: 8 horas

## Visão geral

A Contoso Traders (ContosoTraders) fornece serviços de sites de retalho online personalizados para a comunidade de eletrónica. Estão a refatorar o seu aplicativo para ser executado como um aplicativo Docker. Pretendem implementar uma prova de conceito que os ajude a familiarizarem-se com o processo de desenvolvimento, o ciclo de vida da implementação e os aspetos críticos do ambiente de alojamento. Irão implementar as suas aplicações no Serviço Azure Kubernetes e quererão aprender como implementar contentores de forma dinâmica com balanceamento de carga, descobrir contentores e escalá-los sob demanda.

Neste laboratório prático, ajudará a completar este POC com um subconjunto da base de código da aplicação. Utilizará um agente de build pré-criado baseado em Linux e um cluster do Azure Kubernetes Service para executar aplicações implantadas. Irá ajudá-los a concluir a configuração do Docker para a sua aplicação, testar localmente, enviar por push para um repositório de imagens, implementar no cluster, testar o balanceamento de carga e a escala e utilizar o Azure Monitor e visualizar os insights.

## Objetivo

Este laboratório foi concebido para equipar os participantes com experiência prática na construção de imagens Docker, migrar o MongoDB para o Cosmos DB, implementar e escalar aplicações no Azure Kubernetes Service, gerir atualizações e encaminhamento de tráfego e monitorizar o desempenho do contentor com o Azure Monitor .

1. **Crie imagens Docker para a aplicação:** Este exercício prático tem como objetivo criar imagens Docker para contentorizar a sua aplicação para implementações consistentes e portáteis. Os participantes irão contentorizar a aplicação com sucesso, permitindo uma implementação consistente em vários ambientes.

1. **Migrar o MongoDB para o Cosmos DB utilizando a Migração de Base de Dados do Azure:** Este exercício prático tem como objetivo transferir os seus dados do MongoDB para o Azure Cosmos DB para tirar partido dos seus serviços de base de dados escaláveis ​​​​e geridos. Os participantes migrarão perfeitamente os dados do MongoDB para o Azure Cosmos DB, garantindo a disponibilidade dos dados e a compatibilidade com os serviços do Azure.

1. **Implantar a aplicação no Serviço Azure Kubernetes:** Este exercício prático tem como objetivo implementar e gerir a sua aplicação contentorizada utilizando o Serviço Azure Kubernetes para orquestração e escalabilidade. Os participantes irão implementar a aplicação em contentor no Azure Kubernetes Service, fornecendo um ambiente escalonável e gerido para operação.

1. **Escale a aplicação e valide o HA:** Este exercício prático tem como objetivo ajustar o dimensionamento da aplicação e confirmar a sua alta disponibilidade para garantir que tem um bom desempenho sob cargas variadas. Os participantes irão escalar a aplicação para lidar com cargas variadas e confirmar a sua alta disponibilidade para manter o desempenho e a fiabilidade.

1. **Atualização de aplicações e gestão do Kubernetes Ingress:** Este exercício prático tem como objetivo aplicar atualizações à sua aplicação e configurar o Kubernetes Ingress para gerir e encaminhar o tráfego externo de forma eficaz. Os participantes irão atualizar a aplicação com sucesso e configurar o Kubernetes Ingress para gerir e encaminhar eficazmente o tráfego externo.

1. **Azure Monitor para Contentores:** Este exercício prático tem como objetivo utilizar o Azure Monitor para Contentores para rastrear e analisar o desempenho e a integridade das suas aplicações contentorizadas no AKS. Os participantes permitirão a monitorização de aplicações em contentores com o Azure Monitor, fornecendo insights sobre o desempenho e a integridade operacional.

## Pré-requisitos

Os participantes deverão ter:

- Compreender conceitos Docker, como containers, imagens e Dockerfiles.
- Conhecimento das estruturas de dados do MongoDB e das capacidades do Azure Cosmos DB para uma migração eficaz.
- Compreensão básica dos conceitos do Kubernetes, incluindo pods, implementações e serviços, bem como do Azure Kubernetes Service (AKS).
- Uma subscrição ativa do Azure com as permissões apropriadas para criar e gerir recursos.
- Compreensão geral de serviços de cloud, orquestração de contentores e estratégias de escalabilidade.
- Proficiência na utilização de ferramentas e interfaces de linha de comandos, como o Azure CLI e o Docker CLI.
- Familiaridade com práticas de Integração Contínua e Implantação Contínua, pois podem ser relevantes para a gestão de atualizações e implementações.

## Arquitetura

Os exercícios utilizam vários serviços do Azure para criar, implementar e gerir aplicações de forma eficaz. O Azure Container Registry (ACR) é utilizado para armazenar e gerir imagens de contentores Docker, enquanto o Azure Cosmos DB fornece uma solução de base de dados escalável e multimodelo para migração de dados. O Azure Kubernetes Service (AKS) permite a implantação e gestão de aplicações contentorizadas num ambiente Kubernetes gerido. Para escalabilidade e alta disponibilidade, o Azure Load Balancer distribui o tráfego entre servidores, e o Azure Application Gateway oferece balanceamento de carga e encaminhamento avançados para aplicações Web. Por fim, o Azure Monitor monitoriza o desempenho e a saúde das aplicações e da infraestrutura, incluindo ambientes contentorizados, garantindo monitorização e insights abrangentes.

## Diagrama de Arquitetura

![Selecionando anúnciod para criar uma implantação.](../media/newoverview.png "Selecionar + Adicionar para criar uma implantação")

## Explicação dos Componentes

A arquitetura deste laboratório envolve vários componentes principais:

- **Azure Container Registry (ACR):** um registo de contentor Docker gerido para armazenar e gerir imagens de contentores Docker.
- **Azure Cosmos DB:** um serviço de base de dados multimodelo distribuído globalmente para gerir e escalar dados NoSQL.
- **Azure Kubernetes Service (AKS):** um serviço gerido de orquestração de contentores Kubernetes para a implementação, dimensionamento e gestão de aplicações em contentores.
- **Balanceador de carga do Azure (parte do AKS):** um balanceador de carga de alto desempenho que distribui o tráfego de rede por vários servidores para garantir a alta disponibilidade.
- **Azure Application Gateway (parte do AKS):** Um balanceador de carga de tráfego web que lhe permite gerir o tráfego para as suas aplicações web e fornece encaminhamento baseado em URL e terminação SSL.
- **Azure Monitor:** um serviço de monitorização abrangente que fornece informações sobre o desempenho e a integridade de aplicações e infraestruturas, incluindo cargas de trabalho em contentores.

## Introdução ao laboratório

1. Depois de o ambiente ser provisionado, uma máquina virtual (JumpVM) e um guia de laboratório serão carregados no seu browser. Utilize esta máquina virtual durante todo o workshop para realizar o laboratório. Pode ver o número na parte inferior do guia de laboratório para alternar para os diferentes exercícios do guia de laboratório.

   ![](../media/gs01.png "Ambiente de laboratório")

1. Para obter os detalhes do ambiente de laboratório, pode selecionar o separador **Ambiente**. Além disso, as credenciais também serão enviadas para o seu endereço de e-mail registado. Também pode abrir o Guia do laboratório numa janela completa e separada, selecionando **Janela dividida** no canto superior direito. Além disso, pode iniciar, parar e reiniciar máquinas virtuais no separador **Recursos**.

   ![](../media/gs02.png "Ambiente de laboratório")

   > Verá o valor DeploymentID no separador **Environment**.

## Validação laboratorial

1. Depois de concluir a tarefa, clique no botão **Validar** no separador Validação integrado no seu guia de laboratório. Se receber uma mensagem de sucesso, poderá avançar para a tarefa seguinte;

   ![Validação Inline](../media/inline-validation.png)

1. Também pode validar a tarefa navegando até ao separador **Validação de laboratório**, no canto superior direito da secção do guia de laboratório.

   ![Validação laboratorial](../media/lab-validation.png)

1. Se precisar de ajuda, contacte-nos através do e-mail labs-support@spektrasystems.com.

## Extensão da duração do laboratório

1. Para prolongar a duração do laboratório, clique no ícone **Ampulheta** no canto superior direito do ambiente do laboratório.

   ![Gerencie a sua máquina virtual](../media/gext.png)

   >**Nota:** Receberá o ícone **Ampulheta** quando restarem 10 minutos no laboratório.

2. Clique em **OK** para prolongar a duração do laboratório.

   ![Gerencie a sua máquina virtual](../media/gext2.png)

3. Se não tiver prolongado a duração antes do fim do laboratório, será apresentado um pop-up, oferecendo a opção de prolongar. Clique em **OK** para prosseguir.

## Faça login no Portal Azure

1. No JumpVM, clique no atalho do portal Azure do navegador Microsoft Edge que é criado no ambiente de trabalho.

   ![](../media/gs-3.png "Ambiente de Laboratório")

1. No separador **Entrar no Microsoft Azure** verá o ecrã de login, nele digite o seguinte e-mail/nome de utilizador e clique em **Seguinte**.

    * E-mail/Nome de utilizador: <inject key="AzureAdUserEmail"></inject>

      ![](../media/gs-4.png "Introduza o e-mail")

1. Agora digite a seguinte palavra-passe e clique em **Entrar**.

    * Palavra-passe: <inject key="AzureAdUserPassword"></inject>

      ![](../media/gs-5.png "Introduza a palavra-passe")

    > Se vir a caixa de diálogo **Ajude-nos a proteger a sua conta**, selecione a opção **Saltar por enquanto**.

   ![](../media/gs-6.png "Introduza a palavra-passe")

1. Se vir o pop-up **Permanecer ligado?**, clique em Não

1. Se vir o pop-up **Tem recomendações gratuitas do Azure Advisor!**, feche a janela para continuar o laboratório.

1. Se for apresentada uma janela pop-up **Bem-vindo ao Microsoft Azure**, clique em **Talvez mais tarde** para ignorar o tour.

1. Agora verá o Painel do Portal do Azure, clique em **Grupos de recursos** no painel Navegar para ver os grupos de recursos.

   ![](../media/gs-7.png "Grupos de recursos")

No final deste laboratório, os participantes aprenderão a criar imagens Docker para aplicações em contentores, a migrar dados do MongoDB para o Azure Cosmos DB e a implementar aplicações no Azure Kubernetes Service (AKS) para orquestração. Também irão escalar aplicações e garantir alta disponibilidade, gerir atualizações e encaminhamento de tráfego e utilizar o Azure Monitor para monitorizar o desempenho e a integridade das suas aplicações em contentores.

### Boa aprendizagem!!
