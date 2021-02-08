---
title: Feature - Manage subscriptions
linkTitle: Feature - Manage subscriptions
draft: false
weight: 20
description: >-
  A subscription provides the consumer, or subscriber, with the required
  security and endpoint materials to correctly consume the API.

  The security material and/or quota to access an API is configured inside the API Policy and subscription on Azure API Management service.
---
## Supported use cases when consumer subscribes to an API

Each time the agent received an approved subscription, it generates a new subscription/keys in the Azure API Management service and adds the access to the API from the newly created subscription.

## Supported use cases for subscription approval

Each API can define its own approval mode:

* manual (default): an API provider has to approve the subscription before the consumer receives the API credentials.
(Optional) the agent configuration contains webhook information that will be triggered on each subscription state change. The webhook implementation can, for instance, trigger an MS Teams card to a dedicated Teams channel where the API provider will approve the subscription.
* automatic: the subscription is auto-approved without human intervention.

## Supported use cases for receiving API credentials

Once the subscription is approved, the agent catches this event from Amplify Central and, based on its configuration, can forward the credentials using either an SMTP server or a webhook.

* **email**: the agent configuration contains the access details to an SMTP server (endpoint / port / credentials, if any) and the templates for the emails. Emails can be triggered when the subscription succeeds, fails or when unsubscribes to an API. The agent configuration allows you to customize the email template with several properties:

    * `${catalogItemUrl}`: url of the catalog item to help consumer find it easily
    * `${catalogItemName}`: name of the catalog item
    * `${keyHeaderName}` / `${key}`: apiKey header name and apiKey value
    * `${clientID}` /  `${clientSecret}`: oauth clientID and clientSecret to request the oauth token
    * `${message}`: error message raised by the agent when the subscription fails or the unsubscribe fails

For more information about this configuration, see [Customizing SMTP notifications](/docs/central/connect-api-manager/gateway-administation/#customizing-smtp-notification-subscription).

* **webhook**: the agent configuration contains the webhook details about where to send the payload (catalog asset url / catalog asset name / subscriber email / credentials / action=APPROVE / authtemplate=preconfigure security template sentence).

Webhook payload definition:

```json
{
    "type": "object",
    "properties": {
        "catalogItemId": {
            "type": "string"
        },
        "catalogItemUrl": {
            "type": "string"
        },
        "catalogItemName": {
            "type": "string"
        },
        "action": {
            "type": "string"
        },
        "email": {
            "type": "string"
        },
        "key": {
            "type": "string"
        },
        "keyHeaderName": {
            "type": "string"
        },
        "authtemplate": {
            "type": "string"
        }
    }
}
```

The payload is base64 encoded when sent to the webhook endpoint.

Request sample sent to the webhook endpoint:

```
{
    "headers": {
        "Accept-Encoding": "gzip",
        "Host": "<webHook url>",
        "User-Agent": "EnterpriseEdgeGatewayDiscoveryAgent/<agent_version>",
        "Contenttype": "application/json",
        "Content-Length": "485"
    },
    "body": {
        "$content-type": "application/octet-stream",
        "$content": "eyJjYXRhbG9nSXRlbUlkIjoiZTRlOTFkMjM3NDRiY2I0ZDAxWFhYWCIsImNhdGFsb2dJdGVtVXJsIjoiaHR0cHM6Ly9hcGljZW50cmFsLmF4d2F5LmNvbS9jYXRhbG9nL2V4cGxvcmUvZTRlOTFkMjM3NDRiY2I0ZDAxWFhYWCIsImNhdGFsb2dJdGVtTmFtZSI6Ik1lZGljYWwgUHJhY3RpdGlvbmVyIChWNykiLCJhY3Rpb24iOiJBQ1RJVkUiLCJlbWFpbCI6InVzZXJAbWFpbC5jb20iLCJrZXkiOiI0OWQ5NzJjZC0wZjA2LTQ1MGMtODZkMS1YWFhYWFhYIiwia2V5SGVhZGVyTmFtZSI6IktleUlkIiwiYXV0aHRlbXBsYXRlIjoiWW91ciBBUEkgaXMgc2VjdXJlZCB1c2luZyBhbiBBUElLZXkgY3JlZGVudGlhbDpoZWFkZXI6XHUwMDNjYlx1MDAzZUtleUlkXHUwMDNjL2JcdTAwM2UvdmFsdWU6XHUwMDNjYlx1MDAzZTQ5ZDk3MmNkLTBmMDYtNDUwYy04NmQxLVhYWFhYWFhcdTAwM2MvYlx1MDAzZSJ9"
    }
}
```

## API consumer: subscription workflow

1. A consumer initiates the subscription in Amplify Central:

   1. Open an Amplify Catalog item.
   2. Click **Subscribe**.
   3. Select the Team for which you want to subscribe. For additional information, see [Manage Amplify Catalog subscriptions.](/docs/catalog/manage_subscriptions/)

2. Based on the API subscription approval (manual vs. automatic), an API provider has to approve the subscription.

3. The Discovery Agent receives the subscription event:

   * Subscription status: **Active**

      * Agent create the subscription in Azure API Management service.
      * Agent triggers credentials sending (either via email or via webhook).
      * If a failure occurs for any reason during the process, the subscription status is set to: **Subscription failed**. Refer to the Discovery Agent log for more information. You can delete the subscription and start again from Step 1.

4. The subscriber consumes the API:

   * The API can be consumed once the API credential details are received.

{{< alert title="Note" color="primary" >}}Depending on the poll interval settings for the Discovery Agent, it will take a little time from when the user subscribes an API to an application until Amplify Central shows the subscription state of **Active**. This is because of the time it takes to discover the change on Azure API Management service and send events back and forth between API Manager and Amplify Central.{{< /alert >}}

## Unsubscribe workflow

1. A consumer initiates unsubscribe:

   1. Open the Amplify Catalog and navigate to the **Subscription** tab.
   2. Unsubscribe from the active subscription. For additional information, see [Manage Amplify Catalog subscriptions](/docs/catalog/manage_subscriptions/).

2. The Discovery Agent receives the Unsubscribe event:

   * The agent does nothing  

## Impact of subscription approval mode on subscription workflow

The configuration setting for central.subscriptions.approvalmode affects the flow of getting a subscription approved. Allowed settings are **manual**, **auto** and **webhook**. Each of these settings are detailed below.

### Manual approval mode

This is the default setting. In manual approval mode, the subscription approval flow is as follows:

1. A consumer in Amplify Central clicks on **Subscribe**.
2. The subscription status moves to **Waiting for approval...**.
3. The subscription remains in this state until a user with appropriate permissions on Amplify Central locates the subscription and clicks **Approve**.
4. The subscription status moves to **Subscribing**.
5. The Discovery Agent receives the event and sets the status to **Active**, or **Subscribe failed** if there is a failure to subscribe.

### Auto approval mode

In auto approval mode, the subscription approval flow is as described at the top of this page:

1. A consumer in Amplify Central clicks on **Subscribe**.
2. The subscription status moves immediately to **Subscribing...**.
3. The Discovery Agent receives the event and sets the status to **Active**, or **Subscribe failed** if there is a failure to subscribe.

### Webhook approval mode

In webhook approval mode, the Discovery Agent must be configured with a webhook url, and any webhook headers and authentication secret that the webhook needs. Within the webhook, many things are possible. For example, the webhook could generate an email to notify someone that a subscription is awaiting approval. Or, the webhook could do the subscription approval. Assuming that the webhook is correctly configured and coded, the subscription approval flow is as follows:

1. A consumer in Amplify Central clicks on **Subscribe**.
2. The subscription status moves to **Waiting for approval...**.
3. The webhook is notified of the event.
4. The subscription remains in this state until the webhook moves the subscription to **Approved**, or a user with appropriate permissions on Amplify Central locates the subscription and clicks **Approve**.
5. The subscription status moves to  **Subscribing**.
6. The Discovery Agent receives the event and sets the status to **Active**, or **Subscribe failed** if there is a failure to subscribe.

## Subscription failures

The agent can mark a subscription as **Failed to subscribe** or **Failed to unsubscribe** for any of the following reasons:

|   | Failure Description                                                                                                                                                                    | Remediation                                                                                                                                                                                     |
|---|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 | The agent fails to communicate to API Gateway Manager.                                                                                                                                 | Check your internet connection. API Gateway Manager requires an HTTPS connection.                                                                                                               |

For additional information, see [Manage Amplify Catalog subscriptions](/docs/catalog/manage_subscriptions/).
