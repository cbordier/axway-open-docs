---
title: Deploy agents - quickstart
linkTitle: Deploy your agents - quickstart
draft: false
weight: 25
description: >-
  Learn how to deploy your Discovery Agent and Traceability Agent using Docker
  containers so that you can manage  your AWS API Gateway environment within
  AMPLIFY Central.

  Once agents are correctly deployed, they can collect the data from the AWS API Gateway and send it securely to AMPLIFY Central.
---
## Before you start

* Read [AMPLIFY Central AWS API Gateway connected overview](/docs/central/connect-aws-gateway/)
* [Prepare AMPLIFY Central](/docs/central/connect-aws-gateway/prepare-amplify-central-1/)
* [Prepare AWS API Gateway](/docs/central/connect-aws-gateway/prepare-aws-api-gateway/)
* Docker must be installed and you will need a basic understanding of Docker commands

## Objectives

Learn the basics to create your Discovery Agent and Traceability Agent configuration files, then install and run your agents.

## Discovery Agent

### 1. Create configuration file

Prepare an `env_vars_discovery` file with the following content:

```
# AWS connectivity
AWS_REGION=<AWS region where API are located>
AWS_QUEUENAME=<DiscoveryQueueName>
AWS_AUTH_ACCESSKEY=<YOUR AWS ACCESS KEY HERE>
AWS_AUTH_SECRETKEY=<YOUR AWS SECRET KEY HERE>
AWS_FILTER=tag.publishToAmplify == true
#
#AMPLIFY Central connectivity
CENTRAL_TENANTID=<YOUR ORGANISATION ID>
CENTRAL_TEAMID=<THE TEAM ID>
CENTRAL_ENVIRONMENT=<NAME OF THE CENTRAL TOPOLOGY ENVIRONMENT>
CENTRAL_AUTH_CLIENTID=<SERVICE ACCOUNT NAME: DOSA_xxxxxxxxx>
# Logging
LOG_LEVEL=info
LOG_OUTPUT=stdout
LOG_PATH=logs
```

The required values are either coming from the output of the CloudFormation template or from AMPLIFY platform configuration.
Explanation for each variable can be found in the [advanced section](/docs/central/connect-aws-gateway/deploy-your-agents-1/).

### 2. Download Discovery Agent

```
docker pull axway-docker-public-registry.bintray.io/agent/aws-apigw-discovery-agent:latest
```

### 3. Start the Discovery Agent

```
docker run --env-file ./env_vars_discovery -v <pwd>/keys:/keys  axway-docker-public-registry.bintray.io/agent/aws-apigw-discovery-agent:latest
```

Start the Discovery Agent pointing to the `env_vars_discovery` file and the `keys` directory. Note that `<pwd>` relates to the local directory where the docker command is run. For Windows, the absolute path is preferred. This folder should contain the key pair used for creating the Service Account in AMPLIFY platform.

## Traceability Agent

### 1. Create Traceability Agent environment file

Prepare an `env_vars_traceability` file with the following content:

```
# AWS connectivity
AWS_REGION=<AWS region where API are located>
AWS_QUEUENAME=<TraceabilityQueueName>
AWS_AUTH_ACCESSKEY=<YOUR AWS ACCESS KEY HERE>
AWS_AUTH_SECRETKEY=<YOUR AWS SECRET KEY HERE>
#
#AMPLIFY Central connectivity
CENTRAL_TENANTID=<YOUR ORGANISATION ID>
CENTRAL_TEAMID=<THE TEAM ID>
CENTRAL_ENVIRONMENT=<NAME OF THE CENTRAL TOPOLOGY ENVIRONMENT>
CENTRAL_AUTH_CLIENTID=<SERVICE ACCOUNT NAME: DOSA_xxxxxxxxx>
# Logging
LOG_LEVEL=info
LOG_OUTPUT=stdout
LOG_PATH=logs
```

The required values are either coming from the output of the CloudFormation template or from AMPLIFY platform configuration.
Explanation for each variable could be found in the advance section (TO COMPLETE WITH THE LINK)

### 2. Download Traceability Agent

```
docker pull axway-docker-public-registry.bintray.io/agent/aws-apigw-traceability-agent:latest
```

### 3. Start the Traceability Agent

```
docker run --env-file ./env_vars_traceability -v <pwd>/keys:/keys  axway-docker-public-registry.bintray.io/agent/aws-apigw-traceability-agent:latest
```

Start the Traceability Agent pointing to the `env_vars_traceability` file and the `keys` directory. Note that `<pwd>` relates to the local directory where the docker command is run. For Windows, the absolute path is preferred. This folder should contain the key pair used for creating the Service Account in AMPLIFY platform.
