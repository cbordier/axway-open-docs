---
title: Unpublish an API
linkTitle: Unpublish an API
draft: true
weight: 60
description: Understand the implications of unpublishing your API in API Manager
  in the centralMode (publishToEnvironmentAndCatalog), especially as it relates
  to subscriptions.
---
## Unpublishing your API in publishToEnvironmentAndCatalog mode

Assume you have an API in API Manager that had previously been discovered by the agent and pushed to Amplify Central as a Catalog item. Now you choose to unpublish that API in API Manager. If the agent's mode is set to `publishToEnvironmentAndCatalog`, then:

* The agent updates the **state** of the ConsumerInstance in the Amplify Central environment to UNPUBLISHED.
* The agent updates the **status** of the ConsumerInstance in the Amplify Central environment to UNPUBLISHED.
* The status tag for the catalog in Amplify Central is now marked as UNPUBLISHED.
