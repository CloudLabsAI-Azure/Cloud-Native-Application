# Exercício 6: Azure Monitor para contentores

### Duração estimada: 20 minutos

## Visão geral

Neste exercício, irá analisar os insights do contentor no Azure Monitor para o cluster AKS. O Azure Monitor ajuda-o a maximizar a disponibilidade e o desempenho das suas aplicações e serviços. Oferece uma solução abrangente para recolher, analisar e atuar na telemetria dos seus ambientes de cloud e locais.

Alguns exemplos do que pode fazer com o Azure Monitor incluem:

- Detetar e diagnosticar problemas em aplicações e dependências com o Application Insights.
- Correlacionar problemas de infraestrutura com insights de VM e insights de contentores.
- Recolher dados de recursos monitorizados utilizando métricas do Azure Monitor.

## Objectivos do Laboratório

Poderá completar as seguintes tarefas:

- Tarefa 1: rever as métricas do Azure Monitor

### Tarefa 1: rever as métricas do Azure Monitor

Nesta tarefa, irá rever o cluster AKS monitorizado.

1. Navegue de volta para o portal do Azure e procure **Monitor (1)**, selecione **Monitor (2)** no resultado.

    ![Esta é uma captura de ecrã do Portal Azure para AKS que mostra a adição de um Namespace.](../media/14.png "Adicionar um Namespace")

1. No painel de navegação esquerdo, selecione **Containers (1)** no menu Insights, navegue até à secção **Monitored clusters (2)** para rever os registos e selecione o seu **Kubernetes service (3)** .

    ![Esta é uma captura de ecrã do Portal Azure para AKS que mostra a adição de um Namespace.](../media/13.png "Adicionar um Namespace")

1. Será redirecionado para a secção Insight na folha de recursos do serviço Kubernetes e deverá conseguir ver alguns registos.

    > **Nota**: O Monitor do Azure pode demorar até 15 minutos a preencher os dados na folha de insights.

    ![Esta é uma captura de ecrã do Portal Azure para AKS que mostra a adição de um Namespace.](../media/12.png "Adicionar um Namespace")

## Sumário

Neste exercício, reviu os insights do contentor do Azure Monitor para o cluster AKS.

### Concluiu o laboratório com sucesso
