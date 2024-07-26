# Cloud Native Applications

### Overall Estimated Duration: 8 hours

## Abstract and learning objectives

This hands-on lab will guide the student through deploying a web application and API microservice to a Kubernetes platform hosted on Azure Kubernetes Services (AKS). In addition, the lab will instruct the student on configuring the behaviour of these services through dynamic service discovery, service scale-out, and high availability in the context of AKS-hosted services. By demonstrating crucial Kubernetes concepts, the student will gain experience with the Kubernetes deployment and service resource types. The student will create them manually through the Azure Portal and manipulate their configurations to scale the associated microservice instances up and down and manage their CPU and memory resource allocations with the Kubernetes cluster.

At the conclusion of this lab, you have a solid understanding of how to build and deploy containerized applications to Azure Kubernetes Service and perform common tasks and procedures.


## Overview

Contoso Traders (ContosoTraders) provides online retail website services tailored to the electronics community. They are refactoring their application to run as a Docker application. They want to implement a proof of concept that will help them get familiar with the development process, lifecycle of deployment, and critical aspects of the hosting environment. They will be deploying their applications to Azure Kubernetes Service and want to learn how to deploy containers in a dynamically load-balanced manner, discover containers, and scale them on demand.

In this hands-on lab, you will assist with completing this POC with a subset of the application codebase. You will use a pre-created build agent based on Linux and an Azure Kubernetes Service cluster for running deployed applications. You will be helping them to complete the Docker setup for their application, test locally, push to an image repository, deploy to the cluster, test load-balancing and scale and use Azure Monitor and view the insights.

## Objective

1. **Build Docker Images for the Application:** This hands-on exercise aims to create Docker images to containerize your application for consistent and portable deployments. Participants will successfully containerize the application, enabling consistent deployment across various environments.

1. **Migrate MongoDB to Cosmos DB using Azure Database Migration:** This hands-on exercise aims to transfer your MongoDB data to Azure Cosmos DB to leverage its scalable and managed database services. Participants will seamlessly migrate MongoDB data to Azure Cosmos DB, ensuring data availability and compatibility with Azure services.

1. **Deploy the application to the Azure Kubernetes Service:** This hands-on exercise aims to deploy and manage your containerized application using Azure Kubernetes Service for orchestration and scalability. Participants will deploy the containerized application to Azure Kubernetes Service, providing a scalable and managed environment for operation.

1. **Scale the application and validate HA:** This hands-on exercise aims to adjust the application's scale and confirm its high availability to ensure it performs well under varying loads. Participants will scale the application to handle varying loads and confirmed its high availability to maintain performance and reliability.

1. **Updating Apps & Managing Kubernetes Ingress:** This hands-on exercise aims to apply updates to your application and configure Kubernetes Ingress to manage and route external traffic effectively. Participants will update the application successfully and configure Kubernetes Ingress to effectively manage and route external traffic.

1. **Azure Monitor for Containers:** This hands-on exercise aims to utilize Azure Monitor for Containers to track and analyze the performance and health of your containerized applications in AKS. Participants will enable monitoring of containerize applications with Azure Monitor, providing insights into performance and operational health.

## Architecture Diagram

![Selecting Add to create a deployment.](media/newoverview.png "Selecting + Add to create a deployment")
