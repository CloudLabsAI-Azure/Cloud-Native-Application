# Aplicaciones Nativas de la Nube

## Resumen y objetivos de aprendizaje

Esta práctica de laboratorio guiará al estudiante a través de la implementación de una aplicación web y un microservicio API en una plataforma Kubernetes alojada en Azure Kubernetes Services (AKS). Además, el laboratorio instruirá al estudiante sobre cómo configurar el comportamiento de estos servicios mediante el descubrimiento dinámico de servicios, la escalabilidad horizontal de servicios y la alta disponibilidad en el contexto de los servicios alojados en AKS. Al demostrar conceptos cruciales de Kubernetes, el estudiante obtendrá experiencia con la implementación de Kubernetes y los tipos de recursos de servicio. El estudiante los creará manualmente a través del Portal de Azure y manipulará sus configuraciones para escalar las instancias de microservicio asociadas hacia arriba y hacia abajo y gestionar sus asignaciones de recursos de CPU y memoria con el clúster de Kubernetes.

Al finalizar esta práctica de laboratorio, tendrá un conocimiento sólido de cómo crear y desplegar aplicaciones en contenedores en Azure Kubernetes Service y realizar tareas y procedimientos comunes.


## Descripción General

Contoso Traders (ContosoTraders) proporciona servicios de sitios web minoristas en línea adaptados a la comunidad electrónica. Están refactorizando su aplicación para que se ejecute como una aplicación Docker. Quieren implementar una prueba de concepto que les ayude a familiarizarse con el proceso de desarrollo, el ciclo de vida de la implementación y los aspectos críticos del entorno de alojamiento. Desplegarán sus aplicaciones en Azure Kubernetes Service y quieren aprender a desplegar contenedores de forma dinámica con equilibrio de carga, descubrir contenedores y escalarlos bajo demanda.

En esta práctica de laboratorio, ayudará a completar esta POC con un subconjunto del código base de la aplicación. Utilizará un agente de compilación creado previamente basado en Linux y un clúster de Azure Kubernetes Service para ejecutar aplicaciones desplegadas. Les ayudará a completar la configuración de Docker para su aplicación, probar localmente, empujar a un repositorio de imágenes, desplegar en el clúster, probar el equilibrio de carga y la escala, usar Azure Monitor y ver la información.

## Arquitectura de Solución

A continuación se muestra un diagrama de la arquitectura de la solución que creará en esta práctica de laboratorio. Estudie esto detenidamente para comprender la solución completa mientras trabaja en los distintos componentes.

Los contenedores propuestos desplegados en el clúster se ilustran a continuación con Cosmos DB como servicio administrado.

  ![Seleccionando Agregar para crear un despliegue.](media/newoverview.png "Seleccionando + Agregar para crear un despliegue")
