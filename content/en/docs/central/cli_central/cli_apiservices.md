---
title: Build and manage API services in your environments
linkTitle: Build and manage API services in your environments
weight: 110
date: 2021-01-13T00:00:00.000Z
description: Learn how your DevOps process can use AMPLIFY Central CLI to build and manage API services in your environments.
---

## Before you start

* You must [authorize your DevOps service to use the DevOps API](/docs/central/cli_central/cli_install/#authorize-your-cli-to-use-the-amplify-central-apis)
* Verify the @axway/amplify-central-cli version is at minimum 0.1.3.

## Objectives

Learn how to create and manage your API services to represent your distributed cloud and on-premise environments using the AMPLIFY Central CLI.

* Create a new API service in an environment
* Retrieve a list of all API services in an environment
* Retrieve details for a specific API service
* Update a specific API service
* Delete a specific API service

## Create an API service in your environment

An API service represents an API, including all its versions and deployed endpoints, and additional information to represent your API, for example, description, environment scope, image encoded in base64.

To automate the creation of an API service in your environment:

1. Create an environment by providing the environment name argument, for example, `env1`:

    ```
    amplify central create env env1
    ```

2. Create an API service within environment `env1` by providing a path to a valid .yaml, .yml, or .json file that defines a specific resource (for example, `apiservice.yaml`).  In this example, only one API service called `apisvc1` is created from the resource file:

    ```
    amplify central create -f <filepath>
    ```

Try out this procedure using the [apiservice.json](https://axway-open-docs.netlify.app/samples/central/apiservice.json) or [apiservice.yaml](https://axway-open-docs.netlify.app/samples/central/apiservice.yaml) samples.

## Retrieve a list of API services

Get a list of all API services in all environments:

```
amplify central get apiservices
```

Alternatively, you can use the short name, `apis`:

```
amplify central get apis
```

This command outputs a list of all API services in all environments, with information about the API service name, age, title, and environment scope:

```
NAME                                  AGE           TITLE                   RESOURCE KIND  SCOPE KIND   SCOPE NAME
7841311a-3338-11eb-b6eb-0242ac110002  a month ago   PetStore-Secured        APIService     Environment  awsgtw-us-east-2
2f754bb3-34b2-11eb-986d-000c29b55428  a month ago   Stockquote (V7)         APIService     Environment  cca-m2020-apim
govuk-pay                             23 days ago   GOV.UK Pay              APIService     Environment  mulesoft
lyft                                  23 days ago   Lyft                    APIService     Environment  mulesoft
swagger-petstore-raml                 23 days ago   Swagger Petstore RAML   APIService     Environment  mulesoft
ably-rest-api                         5 days ago    ably-rest-api           APIService     Environment  apig33
```

To get help with a list of supported resource types, run:

```
amplify central get
```

This command outputs a table of supported resources, along with their resource kinds and short names:

```
The server supports the following resources:

RESOURCE                  SHORT NAMES  RESOURCE KIND                   SCOPED  SCOPE KIND
apiserviceinstances       apisi        APIServiceInstance              true    Environment
apiservicerevisions       apisr        APIServiceRevision              true    Environment
apiservices               apis         APIService                      true    Environment
apispecs                  apisp        APISpec                         true    K8SCluster
awsdataplanes             awsdp        AWSDataplane                    true    Environment
awsdiscoveryagents        awsda        AWSDiscoveryAgent               true    Environment
awstraceabilityagents     awsta        AWSTraceabilityAgent            true    Environment
consumerinstances         consumeri    ConsumerInstance                true    Environment
consumersubscriptiondefs  consumersd   ConsumerSubscriptionDefinition  true    Environment
edgedataplanes            edgedp       EdgeDataplane                   true    Environment
edgediscoveryagents       edgeda       EdgeDiscoveryAgent              true    Environment
edgetraceabilityagents    edgeta       EdgeTraceabilityAgent           true    Environment
environments              env          Environment                     false
integrations              integ        Integration                     false
k8sclusters               k8sc         K8SCluster                      false
k8sresources              k8sr         K8SResource                     true    K8SCluster
meshes                    mesh         Mesh                            false
meshworkloads             meshwrk      MeshWorkload                    true    Mesh
resourcediscoveries       resourced    ResourceDiscovery               true    K8SCluster
resourcehooks             resourceh    ResourceHook                    true    Integration
secrets                   secret       Secret                          true    Integration
secrets                   secret       Secret                          true    Environment
specdiscoveries           specd        SpecDiscovery                   true    K8SCluster
webhooks                  webh         Webhook                         true    Integration
webhooks                  webh         Webhook                         true    Environment
```

## Retrieve details of a specific API Service

Get the details of a specific API service in an environment by providing the environment name and the API service name:

```
amplify central get apisvc <name> --scope env1 -o yaml  # Get API service <name> details of `env1` in YAML format
```

This command outputs the details of that specific service in YAML format:

```
---
group: management
apiVersion: v1alpha1
kind: APIService
name: apisvc1
title: apisvc1 title
metadata:
  id: e4e540a975678cb901757ae1436562c2
  audit:
    createTimestamp: '2020-10-30T18:59:44.613+0000'
    createUserId: bd45cb77-e09f-440d-9a09-37f8812420b4
    modifyTimestamp: '2020-10-30T18:59:44.613+0000'
    modifyUserId: bd45cb77-e09f-440d-9a09-37f8812420b4
  scope:
    id: e4e87a1675678dc001757ae1417d483b
    kind: Environment
    name: env1
    selfLink: /management/v1alpha1/environments/env1
  resourceVersion: '46171'
  references: []
  selfLink: /management/v1alpha1/environments/env1/apiservices/apisvc1
attributes:
  createdBy: yaml
finalizers: []
tags:
  - apisvc
  - cli
  - axway
spec:
  description: api service 1 description

---
```

To output the information in JSON format, change the `-o` flag from YAML to JSON:

```
amplify central get apisvc <name> -s env1 -o json       # Get API service <name> details of `env1` in JSON format
```

## Update a specific API Service

Update the details of a specific API service by providing a path to the configuration file:

```
amplify central apply -f apiservice.yaml   # Update API service in YAML format
```

```
amplify central apply -f apiservice.json   # Update API service in JSON format
```

## Delete a specific API Service in an environment

This action will delete all API services and resources in the environment specified. The CLI command can take a few seconds to finish depending on the number of resources represented in the environment.

{{% alert title="Warning" color="warning"%}}This action cannot be reversed.{{% /alert %}}

To delete a specific API service in an environment, provide a path to the configuration file:

```
amplify central delete -f apiservice.yaml   # Delete an API service using a file in YAML format
```

```
amplify central delete -f apiservice.json   # Delete an API service using a file in JSON format
```

Use `--wait` to delete an API service using a YAML file while waiting for resource deletion confirmation. The `--wait` option will check for resource deletion for up to 10 seconds.

```
amplify central delete -f apiservice.yaml --wait
```

Use `--scope` to delete an API service within the scope of and environment named env1.

```
amplify central delete apiservice apisvc1 -scope env1 --wait
```

## Review

You have learned how to use the AMPLIFY Central CLI to build and manage API services in your environments.
