---
title: Connect Azure Gateway
linkTitle: Connect Azure Gateway
weight: 145
date: 2021-01-07
description: Understand why you would connect Azure API Management Services to
  AMPLIFY Central. Learn how you can publish to the AMPLIFY Catalog from your
  API Management Services in order to obtain a global view of your APIs and
  present this Catalog to your consumers. Learn how you can collect the traffic
  of all your gateways and see it in a single place in AMPLIFY Central
  Observability.
---
## What is Azure API Management Service connected?

Connect your Azure Management Services to AMPLIFY Central by using two agents: Discovery and Traceability. These two agents will help you to represent and expose your API Management eco-system in AMPLIFY Central:

* Create an environment in AMPLIFY Central that represent your actual API Management eco-system.
* Detect a published API using the Discovery Agent. The Discovery Agent discovers the API from API Manager and makes it available in AMPLIFY Central. An API Service in Central is created to reference the API from API Management Service and then you can optionally tell the agent to publish it to the AMPLIFY Catalog to allow your consumer to discover it.
* Manage consumer subscription using the Discovery Agent. When a consumer subscribes / unsubscribes to a Catalog asset, the Discovery Agent keeps track of the changes and maintains the API Management system accordingly.
* Filter the Azure Gateway logs using the Traceability Agent. The Traceability Agent uses the discovered API to filter Azure Gateway events to extract the transaction information and send it to the AMPLIFY platform Observability module.

### Discovery Agent

The Discovery Agent is used to discover new published APIs. The Discovery Agent pushes both REST and SOAP API definitions to AMPLIFY Central.

The related APIs are published to AMPLIFY Central either as an API Service in environment or an API Service in environment and optionally as Catalog item (default behavior).

![Service Discovery](/Images/central/connect-azure-gateway/discoveryagent.png)

### Traceability Agent

The Traceability Agent sends log information about APIs that have been discovered and published to AMPLIFY Central.

![Service Traceability](/Images/central/connect-azure-gateway/traceabilityagent.png)

## Prerequisites

* An Axway AMPLIFY Central subscription in the AMPLIFY™ platform
* An AMPLIFY Central Service Account
* An AMPLIFY Central environment
* An Azure Service principal for the Discovery / Traceability agent to use Azure APIs

## System requirements

* A Docker container where the agent images will run

## Region support

AMPLIFY Central supports two regions, US (default) and EU. The data (APIs, traffic) that the agents send to AMPLIFY Central is stored in one of those regions based on the agent configuration.

Use one of the following URLs to access the AMPLIFY Central UI:

* US: <https://apicentral.axway.com>
* EU: <https://central.eu-fr.axway.com>

Update the following variables to move data to the EU region:

* `CENTRAL_DEPLOYMENT`= **prod-eu**
* `CENTRAL_URL`= **<https://central.eu-fr.axway.com>**
* `TRACEABILITY_HOST`= **ingestion-lumberjack.visibility.eu-fr.axway.com:453**

### Preparing AMPLIFY Central

Create a **service account** using AMPLIFY Central command: `amplify central create service-account`. This command generates a key pair (public_key.pem / private_key.pem) and associates the public key to an AMPLIFY Central Service account. The service account client ID is required for the agent configuration. Refer to AMPLIFY Central UI / Access / Service Accounts. You will also need the generated keys for starting the agents.

Create an **environment** using the AMPLIFY Central command:  `amplify central create environment my-azure-env`. This command creates an environment object named 'my-azure-env' in AMPLIFY Central. It will become the placeholder for the discovered APIs. This environment name will be part of the agent configuration.

## Connecting Azure API Management services to AMPLIFY Central for discovery

The following is a high-level overview of the required steps to connect Azure API Management services to AMPLIFY Central:

* Create an Azure Service principal
* Create a service account for the agent to communicate with the AMPLIFY platform
* Create an environment to group the APIs
* Pull the Discovery Agent from Docker
* Update the Azure agent YAML file or use an environment variable file to configure the access to Azure.

### Creating an Azure service principal

Use the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) to create the Azure Service principal.

Once the Azure CLI is installed, run the following commands:

* Connect to Azure: `az login`. You will be redirected to the Azure login page where you enter your credentials to your Azure account. Once connected, the command line output displays all your associated Azure subscription.
* Create the Service principal: `az ad sp create-for-rbac -n "http://your service principal name"`.

Sample

```shell
c:\az ad sp create-for-rbac -n "http://ServicePrincipalForAmplifyAgent"
Creating a role assignment under the scope of "/subscriptions/0fb0f691-********************"
{
  "appId": "3175c9ac-********************",
  "displayName": "ServicePrincipalForAmplifyAgent",
  "name": "http://ServicePrincipalForAmplifyAgent",
  "password": "********************",
  "tenant": "300f59df-********************"
}
```

When you create the Azure principal, the return gives you information you need later to configure the agents. If you lose this information, you can retrieve it again with the following command: `az ad sp list --filter "displayname eq 'service-principal'`, where *service-principal* is the name of the principal you created. Be careful, as this command will not return the service principal password. It is preferable to store the information safely.

Notes:

* If you have more than one subscription within your Azure account, run the following command `az account set --subscription "subscription_name"` to select the appropriate subscription you want to work with.
* You must have at least Owner rights to create the Service principal account.

You can retrieve your subscription id with the command: `az account show --query id`

### Preparing Discovery Agent configuration

Below is the basic configuration to specify connectivity for Azure and AMPLIFY Central. Put this information into an `da_env_vars.env` file and adapt the values according to your configuration.

Note: It is not necessary to surround parameter values with quotes.

```Shell
#
#AZURE connectivity
#
AZURE_SUBSCRIPTIONID={Azure subscription}
# Service Principal credentials
AZURE_TENANTID={tenant of your Service principal}
AZURE_CLIENTID={appId from your Service principal}
AZURE_CLIENTSECRET={password of your Service principal}
# Azure resource group
AZURE_RESOURCEGROUPNAME=Finance
# Azure Service name
AZURE_APIMSERVICENAME=finance-loan

#
#API Central connectivity
#
# Service account to be used to connect to AMPLIFY Central
CENTRAL_AUTH_CLIENTID={service account Client ID: DOSA_xxxxxxxxxxxxxxxxxxxxxxx}
# AMPLIFY Central Organization Id (Refer to AMPLIFY UI / Organization) 
CENTRAL_ORGANIZATIONID=AAAAAAAAA
# Amplify Central environment where to group discovered APIs
CENTRAL_ENVIRONMENT=my-azure-env
# Additional tags that can be added to discovered API. Leave it empty if you don't want to add additional tags
CENTRAL_ADDITIONALTAGS=DiscoveryAgent,Azure

LOG_LEVEL=info
LOG_OUTPUT=stdout
```

For more information about the agent variables, refer to [Reference - Agent configuration](/docs/central/connect-azure-gateway/agent-variables).

### Running the Discovery Agent

First, pull out the image: `docker pull beano.swf-artifactory.lab.phx.axway.int/beano/azure-discovery-agent`.

Second, run the following docker command: `docker run --env-file <PATH>/da_env_vars.env -v <PATH>/<SA-Key-folder>:/keys beano.swf-artifactory.lab.phx.axway.int/beano/azure-discovery-agent`.

Note: `SA-Key-folder` is the folder name that contains the service account keys (private_key.pem / public_key.pem).

## Connecting Azure API Management services to AMPLIFY Central for traceability

The following is a high-level overview of the required steps to connect Azure API Management services to AMPLIFY Central:

* Create an Azure Event Hubs Namespace and Event Hub
* Create an Azure diagnostic setting
* Configure Azure API's for Azure monitoring
* Pull the Traceability Agent from Docker
* Update the Azure agent YAML file or use an environment variable file to configure the access to Azure.

### Creating Azure Event Hubs namespace and Event Hub

Azure Event Hubs is a big data streaming platform and event ingestion service. Refer to [https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about).

To create an Azure Event Hub, it is first required to create an Event Hubs namespace. For that, go to Azure Portal and select the \[Event Hubs\] service. Then create the Event Hubs namespace. Select the appropriate Azure subscription and resource group where this namespace will be available. Be sure to create the Event Hubs namespace in the same region as your API Management service. For the pricing, we recommend the Standard one. When creating the Event Hubs namespace, Azure will automatically attach to it an access policy. We recommend you keep the default values provided.

Once the namespace is created, you can add an Event Hub to this namespace.

Remember the following when creating the Azure Event Hub, as you'll need the information for the Traceability Agent configuration:

* **Event Hubs namespace name**
* **Event Hub name**
* **policy name** attached to the Event Hubs namespace (RootManageSharedAccessKey by default)
* **policy primary or second key**

### Creating Azure diagnostic settings

The Azure diagnostic settings will link the Resource group to the Event Hub.

To create a diagnostic setting:

1. Go to Azure portal, open your resource group and open the Monitoring / Diagnostic settings page.
2. Add a diagnostic setting and give it a name.
3. Select the **GatewayLogs** and **Stream to an event hub** options. The **Stream to event hub** option requires the previous information from Event Hubs namespace and Event Hub name.
4. Save your changes.

Azure is now ready to register your API traffic to the Event Hub.

### Configuring API Azure monitoring

By default, Azure does not monitor API traffic or their headers. You must explicitly ask for that. You can do it per API or for all APIs present in the API Management service.

To configure monitoring:

1. Open the settings of an API (or all APIs).
2. Select the Azure Monitor tab.
3. Select the check box to enable monitoring.
4. Select the Verbose mode and add all headers you want to track. These headers can belong to any request/response (frontend/backend) or you can choose different headers to log using the advanced options.

### Preparing Traceability Agent configuration

Below is the basic configuration to specify connectivity for Azure and AMPLIFY Central. Put this information into an `ta_env_vars.env` file and adapt the values according to your configuration.

Note: It is not necessary to surround parameter values with quotes.

```Shell
#
#AZURE connectivity
#
# Event Hub Namespace
AZURE_EVENTHUBNAMESPACE={Azure event hub namespace}
# Event Hub Name
AZURE_EVENTHUBNAME={Azure event hub}
# Shared access key name
AZURE_SHAREDACCESSKEYNAME={Azure policy name}
# Shared access key value
AZURE_SHAREDACCESSKEYVALUE={Azure policy primary or second key}

#
#API Central connectivity
#
# Service account to be used to connect to AMPLIFY Central
CENTRAL_AUTH_CLIENTID={service account Client ID: DOSA_xxxxxxxxxxxxxxxxxxxxxxx}
# AMPLIFY Central Organization Id (Refer to AMPLIFY UI / Organization) 
CENTRAL_ORGANIZATIONID=AAAAAAAAA
# Amplify Central environment where to group discovered APIs
CENTRAL_ENVIRONMENT=my-azure-env
# Additional tags that can be added to discovered API. Leave it empty if you don't want to add additional tags
CENTRAL_ADDITIONALTAGS=DiscoveryAgent,Azure

LOG_LEVEL=info
LOG_OUTPUT=stdout
```

For more information about the agent variables, refer to [Reference - Agent configuration](/docs/central/connect-azure-gateway/agent-variables).

### Running the Traceability Agent

First, pull out the image: `docker pull  axway-docker-public-registry.bintray.io/agent/azure-traceability-agent:latest`.

Second, run the following docker command: `docker run --env-file <PATH>/ta_env_vars.env -v <PATH>/<SA-Key-folder>:/keys  axway-docker-public-registry.bintray.io/agent/azure-traceability-agent:latest`.

Note: `SA-Key-folder` is the folder name that contains the service account keys (private_key.pem / public_key.pem).
