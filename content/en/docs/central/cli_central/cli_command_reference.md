---
title: AMPLIFY Central CLI Command reference
linkTitle: CLI commands reference
weight: 130
date: 2021-01-13T00:00:00.000Z
description: Learn about the different AMPLIFY Central CLI commands.
---

This section contains the basic commands for creating, fetching, updating, and deleting various Axway API Server assets using the AMPLIFY Central CLI. Each command is followed by a brief description, an explanation of the proper command syntax, including command arguments and options, along with example syntax for various use cases.

### The accessibility of resources

Resources can be *scoped* or *unscoped*.

The scope of a resource refers to the accessibility of the resource. A scoped resource type will be deleted when its scoped, or related, resource is deleted. For example, an API Service resource is scoped to a corresponding Environment resource. When that Environment is deleted, the scoped API Service resource will be deleted as well.

The accessibility, or availability, of an unscoped resource is independent of the accessibility of other resources, meaning that deleting an unscoped resource only deletes that specific resource. For example, deleting a Webhook, which is an unscoped resource type, only deletes that specific Webhook, and does not delete other resources.

If the desired resource type is scoped, you must specify the scope name by providing the `-s, --scope <name>` flag.

You can search for more than one resource if you use comma-separated resources in a command. The search for multiple resources will display multiple result tables, one result table for each resource you fetch.

To see the list of all available resources from AMPLIFY Central, including information about whether those resources are scoped or unscoped, run:

```
amplify central get
```

## get

This command lists one or more resources. It also prints a table of the most important information about an specified resource.

The following table describes the usage, options, and arguments for the `get` command:

|Usage                                                          |                             |
|---                                                            |---                                   |
|`amplify central get [options] [<args...>]`                    |                                    |
|`amplify central get <Resource>`                               |Get a list of the resources          |
|`amplify central get <Resource1>,<Resource2>,...,<ResourceN>`  |Get a list of multiple resources  |
|`amplify central get <Resource> <Name> -s/--scope <Scope Name>`|Get a specific resource by name |
|**Options**                                                    |                 |
|`--client-id=<value>`                                          |Override your DevOps account's client ID |
|`-o,--output=<value>`                                          |Additional output formats, YAML or JSON  |
|`-s,--scope=<name>`                                            |Scope name for scoped resources          |
|**Arguments**                                                  |                   |
|args...                                                        |Command arguments, run `amplify central get` to see the examples |

The following examples show how to use the `get` command:

```bash
# To get all environments:
amplify central get envs

# To get all environments in YAML format:
amplify central get environments -o yaml

# To get environment by resource, or common name (for example, 'myenv') in JSON format:
amplify central get env myenv -o json

# To get all webhooks:
amplify central get webhooks

# To get all webhooks by short name:
amplify central get webh

# To get all webhooks and API services by short name:
amplify central get webh, apis

# To get all environments and API services:
amplify central get envs, apisvc

# To get an environment and an API service, which matches a resource in a specified scope in JSON format. In the following example, 'env1' is scope, and it is required after the `-s` flag):
amplify central get env,apisvc commonname -s env1 -o json
```

For more examples, see [Create and fetch resources via the AMPLIFY Central CLI](/docs/central/cli_central/cli_create_fetch_resources/).

## create

Use this command to create one or more resources from a YAML or JSON file, or `Stdin`.

The following table describes the usage, options, and arguments for the `create` command:

|Usage                                                    |                             |
|---                                                      |---                                   |
|`amplify central create <command> [options]`             |                                    |
|`amplify central create -f <path_to_file>`               |Create multiple resources from a file|
|`amplify central create environment [options] <name>`    |Create an environment with the specified name. Only environments are currently available for this command|
|**Commands**                                             |          |
|`environment`                                            |Create an environment with the specified name  |
|`service-account`                                        |Create a service account |
|**Options**                                              |                   |
|`--client-id=<value>`                                    |Override your DevOps account's client ID |
|`-f,--file=<path>`                                       |Filename to use to create the resource  |
|`-o,--output=<value>`                                    |Additional output formats, YAML or JSON|
|`--region=<value>`                                       |Override your region configuration          |
|**Arguments**                                            |                   |
|`name`                                                   |Name of the new environment |

The following examples show how to use the `create` command:

```bash
# create new environment with "newenv" name
amplify central create env newenv

# create new environment with "newenv" name and output result in YAML
amplify central create environment newenv -o yaml

# create multiple resources from file
amplify central create -f ./some/folder/resources.yaml

# create a service account (DOSA)
amplify central create service-account
```

## apply

The `apply` command updates resources from a file. The resource name must be specified in the file. The resource will be created if it does not exist yet.

The following table describes the usage and options for the `apply` command:

|Usage                                                    |                             |
|---                                                      |---                                   |
|`amplify central apply [options]`             |                                    |
|**Options**                                              |                   |
|`--client-id=<value>`                                    |Override your DevOps account's client ID |
|`-f,--file=<path>`                                       |Filename to use to create the resource  |
|`-o,--output=<value>`                                    |Additional output formats, YAML or JSON|
|`--region=<value>`                                       |Override your region configuration          |

The following examples show how to use the `apply` command:

```bash
# create multiple resources from file
amplify central apply -f ./some/folder/resources.yaml

# create multiple resources from file and output results in YAML format
amplify central apply -f ./some/folder/resources.json -o yaml
```

## delete

Delete resources by type name or file name. When deleting a single resource by its name, if the desired resource type is scoped, you must specify the scope name by adding the `-s, --scope <name>` flag.

The following table describes the usage, options, and arguments for the `delete` command:

|Usage                                                    |                             |
|---                                                      |---                                   |
|`amplify central delete [options] [<args...>]`             |                                    |
|**Options**                                              |                   |
|`--client-id=<value>`                                    |Override your DevOps account's client ID |
|`-f,--file=<path>`                                       |Filename to use to create the resource  |
|`-s,--scope=<name>`                                    |Scope name for scoped resources.|
|`--wait`                                               |Wait for the resources to be completely deleted          |
|**Arguments**                                            |                   |
|`args...`                                                  |Command arguments, run `amplify central delete` to see the examples |

The following examples show how to use the `delete` command:

```bash
# delete environment by name
amplify central delete environment newenv

# delete API service by name (a scoped resource)
amplify central delete apisvc someapisvc -s newenv

# delete all resources specified in the file
amplify central delete -f ./some/folder/resources.yaml
```

## edit

Edit and update resources by using the default editor.

The following table describes the usage, options, and arguments for the `edit` command:

|Usage                                                    |                             |
|---                                                      |---                                   |
|`amplify central edit <command> [options]`             |                                    |
|`amplify central edit environment [options] <name>`      |`environment` - Edit an environment with the specified name.     |
|**Options**                                              |                   |
|`--client-id=<value>`                                    |Override your DevOps account's client ID |
|`-o,--output=<value>`                                       |Additional output formats, YAML or JSON |
|**Arguments**                                            |                   |
|`name`                                                  |Name of the environment |

The following example shows how to use the `edit` command:

```bash
# edit environment by name
amplify central edit environment newenv
```

## install

Install additional platform resources.

The following table describes the usage, options, and arguments for the `edit` command:

|Usage                                                    |                             |
|---                                                      |---                                   |
|`amplify central install <command> [options] [<args...>]`             |                                    |
|`amplify central install agents [options]`             |`agents` - Install API Gateway v7, Amazon API Gateway, Azure API Gateway, Kubernetes agents|
|**Options**                                              |                   |
|`--client-id=<value>`                                    |Override your DevOps account's client ID |
|`--region=<value>`                                       |Override your region config |
|**Arguments**                                            |                   |
|`args...`                                                  |Command arguments, run `amplify central install` to see the examples |

The following example shows how to use the `install` command:

```bash
# install agent configuration in interactive mode
amplify central install agents
```
