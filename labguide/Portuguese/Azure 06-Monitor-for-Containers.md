# Exercício 6: Azure Monitor para contentores

### Duração estimada: 20 Minutos

## Visão geral

Neste exercício, irá analisar os insights do contentor no Azure Monitor para o cluster AKS. O Azure Monitor ajuda-o a maximizar a disponibilidade e o desempenho das suas aplicações e serviços. Oferece uma solução abrangente para recolher, analisar e atuar na telemetria dos seus ambientes de cloud e locais.

Alguns exemplos do que pode fazer com o Azure Monitor incluem:

- Detetar e diagnosticar problemas em aplicações e dependências com o Application Insights.
- Correlacionar problemas de infraestrutura com insights de VM e insights de contentores.
- Recolher dados de recursos monitorizados utilizando métricas do Azure Monitor.

## Objectivos do Laboratório

Poderá completar as seguintes tarefas:

- Tarefa 1: Rever as métricas do Azure Monitorar

### Tarefa 1: Rever as métricas do Azure Monitorar

Nesta tarefa, irá rever o cluster AKS monitorizado.Esta tarefa está focada na revisão visual das métricas e dos registos disponíveis no Azure Monitor para o seu cluster AKS. Não se espera a deteção de alertas ou problemas, a menos que sejam configurados explicitamente.

1. Navegue de volta para o portal do Azure e procure **aks (1)**, selecione **Serviços Kubernetes (2)** no resultado.

    ![Na caixa de diálogo de edição YAML, é introduzido 2 no número de réplicas pretendido.](../media/E6T1S1-0808.png "Definir réplicas para 2")

1. Na página Serviços Kubernetes, selecione **contoso-traders-aks<inject key="DeploymentID" enableCopy="false"/>**.

    ![Na caixa de diálogo de edição YAML, é introduzido 2 no número de réplicas pretendido.](../media/cn92.png "Definir réplicas para 2")
   
1. Navegue até a seção **Monitorar** folha de recursos do serviço Kubernetes, você poderá ver alguns logs.
   
    ![](../media/cn93.png "Definir réplicas para 2")

    > **Nota**: O Monitorar do Azure pode demorar até 15 minutos a preencher os dados na folha de insights.
    
    > **Importante**: Esta tarefa destina-se apenas à revisão visual. Se desejar explorar alertas, pode configurar uma regra de alerta no Azure Monitor. Por exemplo, pode criar um alerta para utilização elevada de CPU ou consumo de memória. Consulte a documentação da Azure para obter orientações sobre como configurar regras de alerta.


> **Parabéns** por concluir a tarefa! Agora é hora de validá-lo. Aqui estão as etapas:
> - Se você receber uma mensagem de sucesso, poderá prosseguir para a próxima tarefa.
> - Caso contrário, leia atentamente a mensagem de erro e repita a etapa, seguindo as instruções do guia do laboratório.
> - Se precisar de ajuda, entre em contato conosco em cloudlabs-support@spektrasystems.com. Estamos disponíveis 24/7 para ajudá-lo.    

<validation step="ba51688d-c5b8-43c8-811c-e78e9a5539ce" />    

## Resumo

Neste exercício, reviu os insights do contentor do Azure Monitor para o cluster AKS.

Ao concluir este **Cloud Native Applications hands-on lab**, containerizou a aplicação Contoso Traders utilizando o Docker, migrou os dados do MongoDB para o Azure Cosmos DB e implementou-a no Azure Kubernetes Service (AKS) para orquestração escalável. Aprendeu a escalar a aplicação e validar a sua alta disponibilidade, a aplicar atualizações e a configurar o Kubernetes Ingress para uma gestão eficiente do tráfego. Por fim, ativou o Azure Monitor for Containers para obter informações valiosas sobre o desempenho e a integridade. Estas competências oferecem-lhe experiência prática na criação, implementação, escalabilidade e monitorização de aplicações modernas cloud-native no Azure.
