---
title: Visualize the agent status
linkTitle: Visualize the agent status
weight: 50
description: Adding your agent status to the environment detail page
---

If your environment status in **AMPLIFY Cental / Topology** displays `Manual Sync.`, even though you have configured agents that have discovered APIs from your gateway and sent relative traffic to the API Observer, then you either installed the agents manually or with an older version of AMPLIFY Central CLI. Amplify Central CLI (0.12.0 and later) creates necessary resources for the known agents (AWS, v7, Azure) to report its environment status to AMPLIFY Central for you to view.

If you installed the agents manually or with an older version of AMPLIFY Central CLI, you must:

* Add new agent resources: Discovery Agent resource and Traceability Agent resource
* Add your agent resources to the environment  

## Resources descriptions

Refer to `amplify central get` to list the resources.

**Discovery Agent resource**:

| RESOURCE                  | SHORT NAMES  | RESOURCE KIND                   | SCOPED  | SCOPE KIND    |
|---------------------------|--------------|---------------------------------|---------|---------------|
| discoveryagents           | da           | DiscoveryAgent                  | true    | Environment   |

**Traceability Agent resource**:

| RESOURCE                  | SHORT NAMES  | RESOURCE KIND                   | SCOPED  | SCOPE KIND    |
|---------------------------|--------------|---------------------------------|---------|---------------|
| traceabilityagents        | ta           | TraceabilityAgent               | true    | Environment   |

The following samples describe the resources for:

* An environment: my-amplify-central-environment
* A Discovery Agent: my-discovery-agent-name
* A Traceability Agent: my-traceability-agent-name

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

Discovery Agent sample:

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

Traceability Agent sample:

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

## Add your agent resources to the environment?

The following steps will guide you in defining the require agent resources in order to display the agent status associated to an environment.

You must access the Axway Central CLI. See [Install Axway Central CLI](/docs/central/cli_central/cli_install).

### Step 1: Authenticate yourself with Axway Central CLI

In a command line prompt, enter `axway auth login`.

A browser opens. You are prompted to enter your credentials and choose your platform organization. Once connected you can close the browser.

### Step 2: Create an environment

If you already have an environment, you can skip this step. Only the environment name will be require later.

Choose one of following to create an environment:

* Use the CLI: `amplify central create env my-environment-name`.
* Use the CLI with a file: create a file (myEnvFile.yaml) containing the environment resource definition mentioned above and use `amplify central apply -f myEnvFile.yaml` to create it.
* Use the UI: Go to topology and use the "+ Environment" button.

Run `amplify central get env`. You should see something similar to this:

```shell
NAME                            AGE                TITLE                           RESOURCE KIND
my-amplify-central-environment  a few seconds ago  My beautiful environment title  Environment
```

### Step 3: Create the agent resources

Create a file `discovery-agent-res.yaml` with the content explained in the above "Resources descriptions" section. Then execute `amplify central apply -f discovery-agent-res.yaml` to create the resource. Be sure to replace the environment name (`my-amplify-central-environment` in the sample) with your environment name in the resource.

Create a file `traceability-agent-res.yaml` with the content explained in "Resources descriptions" section. Then execute `amplify central apply -f traceability-agent-res.yaml` to create the resource. Be sure to replace the environment name (`my-amplify-central-environment` in the sample) with your environment name in the resource.

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

Notice that each agent has an empty column named `STATUS`. This status column will be updated with either `running` when agent is running, `stopped` when agent is stopped or `failed` when the agent cannot establish the connection with the gateway.

### Step 4: Update agent configuration

In order to link agent binary with the appropriate agent resource, you have to update the agent configuration file (env_vars). Use the `CENTRAL_AGENTNAME` variable and link the value to the resource name defined previously.

Sample: CENTRAL_AGENTNAME=my-discovery-agent-name

Once the Discovery Agent starts correctly, you should see the environment status (AMPLIFY Central / Topology) change from `Manual sync.` to `Connected`. If the agent stops, the environment status will move to `Disconnected`. Finally, if the agent cannot reach the Gateway, the status will be `Connection error`.

Opening the environment details page displays all agents and status linked to this environment.

You can also check the status value in CLI using `amplify central get da` or `amplify central get ta`.
