---
title: Add an endpoint to API service
linkTitle: Add an endpoint to API service
weight: 30
date: 2021-02-22
description: Learn how add endpoints to an API service.
---

## Add an endpoint to API service

Before adding an endpoint, you must [add a service](/docs/central/env_gw_mgmt/add_api_service).

1. From the details page of your service, click the (+ Add Endpoint) button located at the top right of the **Endpoints** tab.
2. Enter information about your API service endpoint:
    * **Protocol**: The transfer protocol used by the API service.
    * **Host**: The domain name or IP address of the API service.
    * **Port**: The port number where the API service is exposed.
    * **Basepath**: The path relative to the host where the API service is deployed.
3. Click **Add and save** to add the endpoint, you can repeat steps 2 and 3 to add more endpoints.
4. Click **Save** to create the endpoint(s).

> If you want to add an endpoint to an API service using the Amplify Central CLI, please refer to these [docs](/docs/central/cli_central/cli_publish) instead.
  
### Errors and debugging

If there is an error while publishing to catalog, the form page will present a large error box explaining the caused of the error. The error may contain references to objects only found when using the CLI or API directly. In this case, please refer to the [Amplify CLI](/docs/central/cli_central/cli_publish) documentation for further guidance.
