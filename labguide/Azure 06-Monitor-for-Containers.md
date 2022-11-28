## Exercise 6: Azure Monitor for Containers-Optional

  In this exercise, you will be configuring the Azure Monitor on your containers.
  
### Task 1: Deploy Azure Monitor for Containers 
  
1. Navigate back to Azure Portal in the browser and search for **Monitor**. 
    
1. Select **Monitor** from the list.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/monitor.png "Add a Namespace")
     
1. On the Azure Monitor Overview page, Select Container from the left side menu.
     
   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/container1.png "Add a Namespace")
     
1. On the Getting Started page, Click on **Onboard unmonitored clusters** to onboard your container and cluster

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/onboardcluster.png "Add a Namespace")
    
1. You will be redirected to the **Unmonitored Cluster** section, here click on you AKS cluster to onboard it Azure Monitor.

1. Once you click on the Cluster, you will be redirected to logs section on AKS.
    

### Task 2: Review Azure Monitor metrics & Setup Alerts 

1. Once you onboarded the cluster to Azure monitor, To review the logs, Navigate to **Monitored clusters** section and select you AKS.

   ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/monitoredclster.png "Add a Namespace")
   
1. You will be redirect to the Insight seciton in you AKS resource blade and you should be able to see some logs.

    > Note: The Azure Monitor can take upto 15 minutes to populate the data in insight blade
  ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/logscontainer.png "Add a Namespace")

1. Now to setup the alerts, Click on **Recommended alerts** on the same insight page.

    ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/setalerts.png "Add a Namespace")

1. A new window will open for **Recommended alerts**, on the page enable the **Restarting container count** to setup the alert for this
  
     ![This is a screenshot of the Azure Portal for AKS showing adding a Namespace.](media/enablealert.png "Add a Namespace")
     
1. So far, we have enabled the alerts and you can see these alerts using Log analytic workspace and Azure Monitor, to read more about this:  https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview

