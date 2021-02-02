---
title: Create and fetch resources with AMPLIFY Central CLI
linkTitle: Create and fetch resources with the CLI
weight: 120
date: 2021-01-13T00:00:00.000Z
description: Creating and fetch different AMPLIFY Central resources using the CLI.
---

## Before You Start

* [Install and authenticate yourself via the AMPLIFY Central CLI](/docs/central/cli_central/cli_install/index.html).
* Familiarize yourself with the [most commonly used AMPLIFY Central CLI commands](/docs/central/cli_central/cli_command_reference/index.html).

## Objectives

* Learn how to create and fetch various types of resources via the AMPLIFY Central CLI `create` and `get` commands.
* Learn about the information the AMPLIFY Central CLI provides when you fetch the resources you have created.

## Create a resource

AMPLIFY Central CLI supports creating several resources from either a YAML or JSON file, or Stdin. For example:

```
amplify central create -f <path_to_file>  # Create resources defined in a YAML or JSON file.
```

## Fetch a resource

You can query for a singular resource or multiple resources, and the CLI will display a table of the most important information about the specified resource.

```
amplify central get <Resource> # Get a list of the resources
```

```
amplify central get <Resource1>,<Resource2>,...,<ResourceN> # Get a list of multiple resources
```

```
amplify central get <Resource> <Name> -s/--scope <Scope Name> # Get a specific resource by name
```

## Create and fetch examples

The following are examples of how you can use AMPLIFY Central samples to create and fetch different resources.

### Consumer instances

You can use the [sdkconsumerinstance.json](https://axway-open-docs.netlify.app/samples/central/sdkconsumerinstance.json) sample to create a consumer instance. Then, you can fetch information about your consumer instances as follows:

```
amplify central get consumerinstances
```

Alternatively, you can use a short name:

```
amplify central get consumeri
```

Resource(s) successfully retrieved:

```
NAME           AGE           TITLE                RESOURCE KIND    SCOPE KIND   SCOPE NAME
consumerinst1  a month ago   consumerinst1 title  ConsumerInstance Environment  awsgtw-us-east-2

```

### Consumer subscription definitions

You can use the [apisubscription.json](https://axway-open-docs.netlify.app/samples/central/apisubscription.json) sample to create a consumer subscription definition. Then, you can fetch information about your consumer subscription definitions as follows:

```
amplify central get consumersubscriptiondefs
```

Alternatively, you can use a short name:

```
amplify central get consumersd
```

Resource(s) successfully retrieved:

```
NAME             AGE           TITLE                 RESOURCE KIND                  SCOPE KIND   SCOPE NAME
consumersubdef1  a month ago   consumersubdef1 title ConsumerSubscriptionDefinition Environment  awsgtw-us-east-2
```

### Secrets

You can use the [apisecret.json](https://axway-open-docs.netlify.app/samples/central/apisecret.json) sample to create a secret. Then, you can fetch information about your secrets as follows:

```
amplify central get secret
```

Alternatively, you can use a short name:

```
amplify central get secrets
```

Resource(s) successfully retrieved:

```
NAME        AGE           TITLE       RESOURCE KIND  SCOPE KIND   SCOPE NAME
secretname  4 months ago  secrettitle Secret         Environment  apigtw-v77
```

### Webhooks

You can use the [apiwebhook.json](https://axway-open-docs.netlify.app/samples/central/apiwebhook.json) sample to create a Webhook. Then, you can then fetch information about your Webhooks as follows:

```
amplify central get webhooks
```

Alternatively, you can use a short name:

```
amplify central get wh
```

Resource(s) successfully retrieved:

```
NAME                       AGE           TITLE                             RESOURCE KIND  SCOPE KIND   SCOPE NAME
streams-extension-webhook  a month ago   Streams Extension Webhook         Webhook        Environment  streams-dataplane-integrations
webhook                    6 months ago  Webhook to invoke requestbin.com  Webhook        Environment  cisco-b2bi
msflow                     7 months ago  webhook1 title                    Webhook        Environment  swaggerhub
msflow                     7 months ago  webhook1 title                    Webhook        Environment  azure
subscriptionwebhook        4 months ago  subscriptionwebhook               Webhook        Environment  apigtw-v77
```

### More sample resources

You can practice the above pattern of creating and fetching resources using our sample files:

* API services: [apiservice.json](https://axway-open-docs.netlify.app/samples/central/apiservice.json)
* API service instances: [apiendpoint.json](https://axway-open-docs.netlify.app/samples/central/apiendpoint.json)
* API service revisions: [apirevisions1.json](https://axway-open-docs.netlify.app/samples/central/apirevisions1.json)
* Environments: [create_environments.json](https://axway-open-docs.netlify.app/samples/central/create_environments.json)

Run `amplify central get` to see the entire list of resources supported by the AMPLIFY Central CLI.