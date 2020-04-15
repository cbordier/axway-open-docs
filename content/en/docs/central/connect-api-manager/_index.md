---
title: Connect API Manager
linkTitle: Connect API Manager
draft: true
no_list: true
weight: 130
description: Understand why you would want a connected / managed environment for
  AMPLIFY Central and Axway API Manager. Learn how you can govern and monitor
  the creation / deployment / publishing and subscriptions of AMPLIFY Central
  and Axway API Manager hosted APIs in one central location.
---

{{< alert title="Note" color="primary" >}}The Axway API Manager connectivity to AMPLIFY Central is currently available in an alpha review mode; current functionality and configuration may change before release. Therefore, this connectivity is available for trial use only and is not supported for production API management or connectivity.{{< /alert >}}

## What is Axway API Manager connected?

Connecting Axway API Manager to AMPLIFY Central enables you to have a connected environment for Axway API Gateway where two agents (Discovery and Traceability) are used with Axway API Gateway to:

* Create a new API Gateway environment that can generate configurations for agents, allowing them to interact with AMPLIFY Central.
* Detect changes in API Manager deployments using the Discovery Agent. The Discovery Agent pushes the service configuration as an API service for the environment, which can then be published as a catalog item to be used by consumers to subscribe to the service.
* Create / Update a subscription in API Gateway that is associated with the service and API key and is used by AMPLIFY Central.
* Filter the Axway API Manager logs that are related to discovered APIs and prepare the transaction events that are sent to AMPLIFY platform.

### Discovery Agent

The Discovery Agent is used to discover new published API. The Discovery Agent pushes either an OAS3 or Swagger2 spec to AMPLIFY Central (depending on which was used to create the backend proxy in API Manager).

The Discovery Agent discovers APIs that have PassTrough / API Key / OAuth security.

The related APIs are published to AMPLIFY Central in either disconnected mode (catalog item publication) or connected mode (API Service publication). For additional information, see [Discovery Agent](/docs/central/connect-api-manager/deploy-your-agents/#discovery-agent).

{{< alert title="Note" color="primary" >}}Although both publication modes are functional, APIs cannot be fully managed from AMPLIFY Central before Q3-2020.{{< /alert >}}

![Service Discovery](/Images/central/ServiceDiscoveryAPIM.png)

test change

### Traceability Agent

The Traceability Agent is used to filter the logs and prepare the transaction events that are sent to AMPLIFY Central.

## Minimum requirements

* An AMPLIFY Central Service Account. See [Manage an API proxy using AMPLIFY CLI](/docs/central/cli_proxy_flow/)
* Axway API Manager / Axway API Gateway versions 7.6.2 SPx, 7.7 SPx or 7.8

## Connect Axway API Manager to AMPLIFY Central quickstart

1. Create an environment object in AMPLIFY Central using either the UI or CLI.
2. Generate a key pair.

   1. Create a new Service Account user in AMPLIFY Central using the key pair. see [Manage an API proxy using AMPLIFY CLI](/docs/central/cli_proxy_flow/).
3. Create a Discovery Agent environment file.

   1. Move key files to a keys directory.
   2. Log into the Artifactory Repository and pull the latest binary of the Discovery Agent.
   3. Start the Discovery Agent.
4. Create a Traceability Agent environment file.

   1. Move key files to a keys directory.
   2. Log into the Artifactory Repository and pull the latest binary of the Traceability Agent.
   3. Start the Traceability Agent.
