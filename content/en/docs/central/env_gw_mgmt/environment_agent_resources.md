---
title: Visualize the agent status
linkTitle: Visualize the agent status
weight: 50
description: Adding your agent status to the environment detail page
---

You are certainly wondering why your environment in AMPLIFY Cental / Topology view shows `Manual Sync.` whereas you already have an agents configured that have discovered APIs from your gateway and send the relative traffic to the API Observer.

It is maybe because you installed the agents manually or with a previous version of AMPLIFY Central CLI. Recent version of CLI (0.12.0 minimum) creates necessary resources for the known agents (AWS, v7, Azure) to report its status to AMPLIFY Central.

In case you have an existing installation of agents that have not been done with AMPLIFY Central CLI v0.12.0 minimum or you have build your own agent, you are probably not able to see the agent status and definition in the Environment.

For that, you will need new resources: a discovery agent resource and a traceability agent resource.

## Resources descriptions

Refer to `amplify central get` to list the resources.

**Discovery agent resource**:

| RESOURCE                  | SHORT NAMES  | RESOURCE KIND                   | SCOPED  | SCOPE KIND    |
|---------------------------|--------------|---------------------------------|---------|---------------|
| discoveryagents           | da           | DiscoveryAgent                  | true    | Environment   |

**Traceability agent resource**:

| RESOURCE                  | SHORT NAMES  | RESOURCE KIND                   | SCOPED  | SCOPE KIND    |
|---------------------------|--------------|---------------------------------|---------|---------------|
| traceabilityagents        | ta           | TraceabilityAgent               | true    | Environment   |

In the next samples, we will describe the resource for:

* an environment: my-amplify-central-environment
* a discovery agent: my-discovery-agent-name
* a traceability agent: my-traceability-agent-name

Environment sample:

```yml
group: management
apiVersion: v1alpha1
kind: Environment
name: my-amplify-central-environment
title: My beautiful environment title
metadata:
attributes:
  attr1: value1
finalizers: []
tags:
  - sample
spec:
  icon:
    data: >-
     base64EncodedImage
    contentType: image/png
  description: >-
    This is the environment for representing the gateway ZYZ.
```

Discovery agent sample:

```yaml
group: management
apiVersion: v1alpha1
kind: DiscoveryAgent
name: my-discovery-agent-name
title: My beautiful DiscoveryAgent title
metadata:
  scope:
    kind: Environment
    name: my-amplify-central-environment
attributes: {}
finalizers: []
tags:
  - sample
spec:
  config:
    additionalTags:
      - DiscoveredByV7Agent
  logging:
    level: debug
  dataplaneType: my-dataplane-name
```

Traceability agent sample:

```yaml
group: management
apiVersion: v1alpha1
kind: TraceabilityAgent
name: my-traceability-agent-name
title: My beautiful TraceabilityAgent title
metadata:
  scope:
    kind: Environment
    name: my-amplify-central-environment
attributes: {}
finalizers: []
tags:
  - sample
spec:
  config:
    excludeHeaders:
      - Authorization
    processHeaders: true
  dataplaneType: my-dataplane-name
```

## How to tell the environment that agents are connected to it?

In the following section, we will guide you step by step to define the require agent resources in order to display the agent status associated to an environment.

You will need to access the Axway central CLI. Refer to [Install Axway Central CLI](/docs/central/cli_central/cli_install)

## Step 1: Authenticate yourself with Axway Central CLI

In a command line prompt, enter `axway auth login`

A browser will popup asking you to enter your credentials and choose your platform organization. Once connected you can close the browser.

## Step 2: create an environment

If you already have an environment, you can skip this step. Only the environment name will be require later.

For that, you have 3 possibilities:

* using the CLI: `amplify central create env my-environment-name`
* using the CLI with a file: create a file (myEnvFile.yaml) containing the environment resource definition mentioned above and use `amplify central apply -f myEnvFile.yaml` to create it.
* using the UI. Go to topology and use the "+ Environment" button

This should result in the following display after running `amplify central get env`:

```shell
NAME                            AGE                TITLE                           RESOURCE KIND
my-amplify-central-environment  a few seconds ago  My beautiful environment title  Environment
```

## Step3: create the agent resources

Create a file `discovery-agent-res.yaml` with the content explained in "Resources description" section. Then execute `amplify central apply -f discovery-agent-res.yaml` to create the resource. Be sure to replace the environment name (`my-amplify-central-environment` in the sample) with your environment name in the resource.

Create a file `traceability-agent-res.yaml` with the content explained in "Resources description" section. Then execute `amplify central apply -f traceability-agent-res.yaml` to create the resource. Be sure to replace the environment name (`my-amplify-central-environment` in the sample) with your environment name in the resource.

Once you are done you can verify your work by running the commands `amplify central get da` or `amplify central get ta` or `amplify central get da,ta`

You should see something similar to this:

```shell
// discovery agent
NAME                     STATUS   AGE           RESOURCE KIND       SCOPE KIND   SCOPE NAME
my-discovery-agent-name           a minute ago  DiscoveryAgent      Environment  my-amplify-central-environment

// traceability agent
NAME                        STATUS   AGE                RESOURCE KIND          SCOPE KIND   SCOPE NAME
my-traceability-agent-name           a few seconds ago  TraceabilityAgent      Environment  my-amplify-central-environment
```

You can notice that each agent has a column named `STATUS` which is empty. This status column will be updated either with `running` when agent is running, `stopped` when agent is stopped or `failed` when agent cannot establish the connection with the gateway.

## Step4: update agent configuration

In order to link agent binary with the appropriate agent resource, you have to update the agent configuration file (env_vars). For that, you need to use `CENTRAL_AGENTNAME` variable and link the value to the resource name defined previously.

Sample: CENTRAL_AGENTNAME=my-discovery-agent-name

Once the discovery agent starts correctly, you should be able to see that the environment status (AMPLIFY Central / Topology) should change from `Manual sync.` to `Connected`. In case the agent stops, the environment status will move to `Disconnected`. Finally, if the agent has difficulty to reach the Gateway, the status will be `Connection error`.

Opening the environment details page will display all agents and status linked to this environment.

You can also check the status value in CLI using `amplify central get da` or `amplify central get ta`.
