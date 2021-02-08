---
title: Prepare Amplify Central
linkTitle: Prepare Amplify Central
draft: true
weight: 
description: Learn how to virtualize AWS API Gateway within Amplify Central by
  using an environment. Secure the connection between Amplify Central and the
  agents by using a Service Account.
---

## Before you start

* Read [Amplify Central AWS API Gateway connected overview](/docs/central/connect-aws-gateway/)
* You will need a basic knowledge of AWS API Gateway
* Verify that @axway/amplify-central-cli version is at minimum 0.1.4 (Get the [CLI](/docs/central/cli_central/cli_install/))
    * Check the installed version with `amplify central -v`
* Install OpenSSL

## Objectives

Learn how to create a Service Account and an environment for AWS API Gateway within Amplify Central.

## Create a Service Account

A Service Account is required to secure the connection between agents and Amplify Central. The Service Account uses a public/private key pair to authenticate your agents, so no user information is required.

1. Generate a private and public key pair:

    ```
    openssl genpkey -algorithm RSA -out ./aws_agent_private_key.pem -pkeyopt rsa_keygen_bits:2048
    openssl rsa -pubout -in ./aws_agent_private_key.pem -out ./aws_agent_public_key.pem
    ```

2. Create a new Service Account user in Amplify Central using the `aws_agent_public_key.pem` from above. You may name this Service Account (for example, AWS-Agent). For additional information, see [Create a service account](/docs/central/cli_central/cli_install/#create-a-service-account). There is no need to download the Service Account JSON-File.

## Create an environment

Create an environment object in Amplify Central that represents the effective API Gateway environment. Depending on your needs, you can create as many environments as required.

Each discovered API or Traffic is associated to this environment and eases the filtering.

You can create your environment using either the UI or CLI.

### Create environment using the UI

Create an environment in **Amplify Central UI > Topology > Environments > create** and give it a relevant name. It is not necessary to have a real environment at this point, but it is important to have an environment name. You can find this environment name in your environment details in the UI.

Example:

```
https:/<Amplify Central URL>/topology/environments/**aws-us-east-2**
```

**Bold** characters are your environment name.

### Create environment using the CLI

Examples:

```
amplify central config set --client-id <DOSA account name>
amplify central create -f <filename>
amplify central create env <name> -o json
```

Options:

```
-o, --output = yaml | json
-f, --file = (filename.yml, filename.yaml, or filename.json)
```

#### Sample environment file

```yaml
---
group: management
apiVersion: v1alpha1
kind: Environment
name: my-aws-us-east2-environment-for-testing
title: Any useful title
attributes:
  attr1: value1
  attr2: value2
  createdBy: CLI
tags:
  - Testing
  - another tag
spec:
  description: A wonderful description to help me.
  icon:
    contentType: image/png
    data: "[optional base64 encoded image]"
```

For information, see [Build an environment using Amplify CLI](/docs/central/cli_central/cli_environments/).
