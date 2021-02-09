---
title: Feature - Manage subscription workflow
linkTitle: Feature - Manage subscription workflow
draft: false
weight: 45
description: >-
  A subscription provides the consumer, or subscriber, with the required
  security and endpoint materials to correctly consume the API.

  The security material and/or quota to access an API is configured inside the application on Axway API Manager.
---
## Supported use cases when consumer subscribes to an API

* **API providers allow the subscriber to create an application** (property `APIMANAGER_ALLOWAPPLICATIONAUTOCREATION=true` set in the discovery agent configuration file): the agent generates the application and adds the access to the API from the newly created application.
* **Application has no access to the API** in Axway API Manager: the agent adds access to the API from the selected application.
* **Application already has access to the API** in Axway API Manager: the agent has nothing to do.

## Supported use cases for issuing consumer credentials

The property `APIMANAGER_SUBSCRIPTIONSISSUENEWCREDENTIALS` allows the API provider to issue new credentials each time a consumer subscribes to an API (default behavior) or reuse existing credentials.

* **generate new credentials** (default): new credentials (ApiKey / oauth client&secret ) are generated per subscription and store within the selected application.
* **reuse existing credentials** (property `APIMANAGER_SUBSCRIPTIONSISSUENEWCREDENTIALS=false` set in the Discovery Agent configuration file): the agent sends the first non-repudiated credentials available in the application to the subscriber.

## Supported use cases for subscription approval

Each API can define its own approval mode:

* manual (default): an API provider has to approve the subscription before the consumer receives the API credentials.
(Optional) the agent configuration contains webhook information that will be triggered on each subscription state change. The webhook implementation can, for instance, trigger an MS Teams card to a dedicated Teams channel where the API provider will approve the subscription.
* automatic: the subscription is auto-approved without human intervention.

Agent configuration:

```yml
CENTRAL_SUBSCRIPTIONS_APPROVAL_MODE={manual|auto|webhook}
CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_URL={The webhook URL that subscription data will be posted to}
CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_HEADERS={The headers that will be used when posting data to the webhook url}
```

## Supported use cases for receiving API credentials

Once the subscription is approved, the agent catches this event from Amplify Central and, based on its configuration, can forward the credentials using either an SMTP server or a webhook.

* **email**: the agent configuration contains the access details to an SMTP server (endpoint / port / credentials, if any) and the templates for the emails. Emails can be triggered when the subscription succeeds, fails or when unsubscribes to an API. The agent configuration allows you to customize the email template with several properties:

    * `${catalogItemUrl}`: url of the catalog item to help consumer find it easily
    * `${catalogItemName}`: name of the catalog item
    * `${keyHeaderName}` / `${key}`: apiKey header name and apiKey value
    * `${clientID}` /  `${clientSecret}`: oauth clientID and clientSecret to request the oauth token
    * `${message}`: error message raised by the agent when the subscription fails or the unsubscribe fails

Agent configuration:

```yml
# SMTP Server definition
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_HOST={SMTP server host}
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_PORT={SMTP server port}
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_AUTHTYPE={The authentication type based on the email server.  You may have to refer to the email server properties and specifications. This value defaults to NONE.}
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_USERNAME={The username used to authenticate to the SMTP server, if necessary}
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_PASSWORD={The password used to authenticate to the SMTP server, if necessary}
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_FROMADDRESS={The email address that will be listed in the from field}

# emails template are defaulted to the following:
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_SUBJECT=Subscription Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_BODY=Subscription created for Catalog Item: <a href= ${catalogItemUrl}> ${catalogItemName}</a><br/>${authtemplate}<br/>
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_OAUTH=Your API is secured using OAuth token. You can obtain your token using grant_type=client_credentials with the following client_id=<b>${clientID}</b> and client_secret=<b>${clientSecret}</b>
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_APIKEYS=Your API is secured using an APIKey credential: header: <b>${keyHeaderName}</b> / value: <b>${key}</b>

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBE_SUBJECT=Subscription Removal Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBE_BODY=Subscription for Catalog Item: <a href= ${catalogItemUrl}> ${catalogItemName}</a> has been unsubscribed

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBEFAILED_SUBJECT=Subscription Failed Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBEFAILED_BODY=Could not subscribe to CatalogItem: <a href= ${catalogItemUrl}> ${catalogItemName}</a>

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBEFAILED_SUBJECT=Subscription Removal Failed Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBEFAILED_BODY=Could not unsubscribe to Catalog Item: <a href= ${catalogItemUrl}> ${catalogItemName}</a>
```

For more information about this configuration, see [Customizing SMTP notifications](/docs/central/connect-api-manager/gateway-administation/#customizing-smtp-notification-subscription).

* **webhook**: the agent configuration contains the webhook details about where to send the payload (catalog asset url / catalog asset name / subscriber email / credentials / action=APPROVE / authtemplate=preconfigure security template sentence).

Agent configuration:

```yml
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_WEBHOOK_URL={The webhook URL that subscription notification data will be posted to}
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_WEBHOOK_HEADERS={The headers that will be used when posting data to the webhook url}
```

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

## API provider: subscription preparation

1. (Optional) An API provider creates one or more applications on Axway API Manager and provides the necessary security feature (API key / OAuth...) and quota, if needed:

   * Add a custom field to the application to track the Amplify Central subscription. Refer to `<API_Gateway_install_dir>/apigateway/webapps//apiportal/vordel/apiportal/app/app.config file` in the **customPropertiesConfig** section. For more details, see [Customize API Manager](/docs/apim_administration/apimgr_admin/api_mgmt_custom/).

       Sample application:

     ```
     customPropertiesConfig: {
             user: {
                 // custom properties...
             },
             organization: {
                 // custom properties...
             },
             application: {
                 subscriptions: {
                     label: 'Subscriptions'
                 },
             },
             api: {
                 // custom properties...
             }
         }
     ```
2. (Optional) An API provider adds API access on the application(s) for each API they wish to allow their subscriber to subscribe to.

3. (Optional) An API provider allows the consumer to create an application during the subscription flow (add the property `APIMANAGER_ALLOWAPPLICATIONAUTOCREATION=true` to the discovery agent configuration file).

## API consumer: subscription workflow

1. A consumer initiates the subscription in Amplify Central:

   1. Open an Amplify Catalog item.
   2. Click **Subscribe**.
   3. Select the Team and API Manager Application name for which you want to subscribe. For additional information, see [Manage Amplify Catalog subscriptions.](/docs/catalog/manage_subscriptions/)

2. Based on the API subscription approval (manual vs. automatic), an API provider has to approve the subscription.

3. The Discovery Agent receives the subscription event:

   * subscription status: **Active**

      * Subscription ID is automatically added to the **Custom** field of the application.
      * Agent triggers credentials sending (either via email or via webhook).
      * If a failure occurs for any reason during the process, the subscription status is set to: **Subscription failed**. Refer to the Discovery Agent log for more information. You can delete the subscription and start again from Step 1.

4. The subscriber consumes the API:

   * The API can be consumed once the API crendential details are received.

{{< alert title="Note" color="primary" >}}Depending on the poll interval settings for the Discovery Agent, it will take a little time from when the user subscribes an API to an application until Amplify Central shows the subscription state of **Active**. This is because of the time it takes to discover the change on API Manager and send events back and forth between API Manager and Amplify Central.{{< /alert >}}

{{< alert title="Note" color="primary" >}}If the FrontEnd API on API Manager corresponding to the Catalog item is set to **unpublished** at the time the subscription is initiated, the Discovery Agent will receive the event, but will not allow the subscription to be completed. Instead, it will send back a subscription status of **Subscribe failed**.{{< /alert >}}

{{< alert title="Note" color="primary" >}}The API Manager application and the API must be in the same organization. Otherwise, an error message is displayed in the Discovery Agent log.{{< /alert >}}

**Workaround**: You can grant the API access to the organization where the application belongs:

1. In the UI, select the API.
2. Expand **Manage selected**.
3. Select **Grant access**.

## Unsubscribe workflow

1. A consumer initiates unsubscribe:

   1. Open the Amplify Catalog and navigate to the **Subscription** tab.
   2. Unsubscribe from the active subscription. For additional information, see [Manage Amplify Catalog subscriptions](/docs/catalog/manage_subscriptions/).

2. The Discovery Agent receives the Unsubscribe event:

   * The subscription ID is removed from the application's Custom field.

## Impact on subscription when unpublishing an API

1. In API Manager, assume there is a FrontEnd API that is published, has been discovered by the Discovery Agent, and has an active subscription to it in Amplify Central.
2. A user in API Manager unpublishes that API.
3. The Discovery Agent discovers the change and:

   * Initiates an unsubscribe to Amplify Central for that Catalog item.
   * The subscription ID is removed from the application's Custom field.
   * The subscription status is set to **Unsubscribed**.

{{< alert title="Note" color="primary" >}}Depending on the poll interval settings for the Discovery Agent, it will take a little time from when the user unsubscribes an API until Amplify Central shows the subscription state of **Unsubscribed**. This is because of the time it takes to discover the change on API Manager and send events back and forth between API Manager and Amplify Central.{{< /alert >}}

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
| 1 | The API on API Gateway Manager is unpublished.                                                                                                                                         | Under the API section in API Manager > Manage the Frontend API: Publish the desired API.                                                                                                      |
| 2 | On API Gateway Manager, the organization to which the application chosen for the subscription has not given API Access to the API, or the access has been given but has been disabled. | Under the Clients section in API Manager > Organizations: Verify that the ORG has "Enabled" toggled correctly (under General) and that the API has been added (under API Access).                 |
| 3 | On API Gateway Manager, the application chosen for the subscription has not given API Access to the API, or the access has been given but has been disabled.                           | Under the Clients section in API Manager > Applications > Application Tab: Verify that the APP has "Enabled" toggled correctly (under General) and that the API has been added (under API Access). |
| 4 | On API Gateway Manager, the application chosen for the subscription has not set up any authentication.                                                                                 | Under the Clients section in API Manager > Applications > Authentication Tab: Verify that the APP has the appropriate authentication type setup.                                                   |
| 5 | On API Gateway Manager, the application chosen for the subscription does not match the inbound security setting for the API.                                                           | Under the API section in API Manager > Manage the Frontend API, click the API > Inbound Tab: Verify that the API has the appropriate Inbound security selected.                               |
| 6 | The agent fails to communicate to API Gateway Manager.                                                                                                                                 | Check your internet connection. API Gateway Manager requires an HTTPS connection.                                                                                                               |

For additional information, see [Manage Amplify Catalog subscriptions](/docs/catalog/manage_subscriptions/).
