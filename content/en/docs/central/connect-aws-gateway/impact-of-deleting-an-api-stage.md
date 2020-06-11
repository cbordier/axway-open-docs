---
title: Impact of deleting an API stage
description: Understand the implications of deleting a stage in AWS API Gateway
  in each of the two centralModes (publishToCatalog or
  publishToEnvironmentAndCatalog), especially as it relates to subscriptions and
  your AMPLIFY Central Catalog items.
---
## Deleting a stage in publishToCatalog mode

Assume you have an API stage in AWS API Gateway that has been previously discovered by the agent and pushed to AMPLIFY Central as a Catalog item. Now you choose to delete that stage using the AWS API Gateway console. If the agent's mode is set to `publishToCatalog`, then:

* The agent first checks if there are any active subscriptions for that Catalog item. If there are any, then the agent automatically unsubscribes each of them.
* Then, the agent removes the Catalog item for that stage in AMPLIFY Central.

## Deleting a stage in publishToCatalogAndEnvironment mode

Assume you have an API stage in AWS API Gateway that has been previously discovered by the agent and pushed to AMPLIFY Central as a Catalog item. Now you choose to delete that stage using the AWS API Gateway console. If the agent's mode is set to `publishToCatalogAndEnvironment`, then:

* The agent first checks if there are any active subscriptions for that Catalog item. If there are any, then the agent automatically unsubscribes each of them.
* The agent then removes the Catalog item for that stage in AMPLIFY Central.
* Finally, the agent removes the underlying ConsumerInstance in the AMPLIFY Central environment.