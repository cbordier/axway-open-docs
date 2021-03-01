---
title: Administer API Manager Gateway
linkTitle: Administer API Manager Gateway
draft: false
weight: 25
description: Learn how to deploy your Discovery Agent and Traceability Agent so
  that you can manage your Axway API Gateway environment within Amplify Central.
---
## Before you start

* Read [Amplify Central and Axway API Manager connected overview](/docs/central/connect-api-manager/)
* Be sure you have [Prepared Amplify Central](/docs/central/connect-api-manager/#pre-requisites)
* You will need a basic knowledge of Axway API Management solution:

    * Where the solution is running (host / port / path to the logs / users)
    * How to create / publish an API
    * How to call an API
* For containerized agents, Docker must be installed and you will need a basic understanding of Docker commands

## Objectives

Learn how to install, customize and run your Discovery and Traceability agents.

## Discovery Agent

The Discovery Agent is used to discover new published APIs or any updated APIs. Once they are discovered, the related APIs are published to Amplify Central, in one of the following publication modes:

* **Environment / API Service publication**: Customers publish their APIs to the Amplify platform.
* **Environment / API Service publication / Catalog item publication** (default mode): Same as previous plus automatically expose the APIS to the consumer via the Amplify Catalog.

The Discovery Agent only discovers APIs that have the tag(s) defined in the agent configuration file. See [Discover APIs](/docs/central/connect-api-manager/filtering-apis-to-be-discovered/). By default, the filter is empty and thus the agent will discover all APIs.

The binary agent can run in the following mode:

* Default: With a yaml configuration file having the same name as the agent binary - `discovery_agent.yml`. Some values (Central url / authentication url) are defaulted to avoid mistake and will not be visible in the provided discovery_agent.yml file.
* **Recommended**: With an environment variable file `da_env_vars.env`. All values in the `discovery_agent.yml` file can be overridden with environment variables. Those environment variables can be stored in a single file and this file can be located anywhere (use --envFile flag in the agent command line to access it=`./discovery_agent --envFile /home/config/da_env_vars.env`). This makes it easy to update the agent (binary/yaml) without loosing the agent configuration. All environment variables are described in [Discovery Agent variables](/docs/central/connect-api-manager/agent-variables/) section.

The containerized agent can run in the following mode:

* With an environment variables configuration file, `da_env_vars.env`, supplied as a command line argument when running the Docker image.

### Installing the Discovery Agent

#### To install the Binary Discovery Agent

**Step 1**: Download the latest version of the zip file from the Axway public repository using the following command:

```shell
curl -L "https://axway.jfrog.io/artifactory/ampc-public-generic-release/v7-agents/v7_discovery_agent/latest/discovery_agent-latest.zip" -o discovery_agent-latest.zip
```

**Step 2**: Unzip the file discovery_agent-latest.zip to get the agent binary (discovery_agent) and a template configuration file (discovery_agent.yml).

```shell
unzip discovery_agent-latest.zip
```

**Step 3**: Copy those 2 files into a folder (/home/APIC-agents for instance) on the machine where the API Manager environment is located.

**Step 4**: Move the `private_key.pem` and `public_key.pem` files that were originally created when you set up your Service Account to the agent directory (APIC-agents). Note that the `public_key.pem` comes from Steps 3 or 4 of [Create a Service Account](/docs/central/cli_central/cli_install/#authorize-your-cli-to-use-the-amplify-central-apis) depending if you choose to use the `der` format or not.

#### To install the Dockerized Discovery Agent

Create your Discovery Agent environment file, `da_env_vars.env`. See [Discovery Agent variables](/docs/central/connect-api-manager/agent-variables/) for a reference to variable descriptions.
After customizing all the sections, your `da_env_vars.env` file should look like this example file:

```shell
# API MANAGER connectivity
APIMANAGER_HOST=<HOST>
APIMANAGER_AUTH_USERNAME=<USER>
APIMANAGER_AUTH_PASSWORD=<PASSWORD>

# API GATEWAY connectivity
APIGATEWAY_HOST=<HOST>
APIGATEWAY_AUTH_USERNAME=<USER>
APIGATEWAY_AUTH_PASSWORD=<PASSWORD>

# Amplify connectivity
CENTRAL_ORGANIZATIONID=<ORGANIZATIONID>
CENTRAL_TEAM=<TEAM>
CENTRAL_AUTH_CLIENTID=<CLIENTID, ie. DOSA_12345...>
```

* The value for *team* can be found in [Amplify Central > Access > Team Assets](https://apicentral.axway.com/access/teams/).
* The value for *organizationID* can be found in Amplify Central Platform > Organization.
* The value for *clientId* can be found in Service Account. See [Create a service account](/docs/central/cli_central/cli_install/#authorize-your-cli-to-use-the-amplify-central-apis).

Pull the latest image of the Discovery Agent:

```shell
docker pull axway.jfrog.io/ampc-public-docker-release/agent/v7-discovery-agent:latest
```

### Customizing the Discovery Agent environment variable file

The `da_env_vars.env` configuration file contain 3 sections to personalize: API Manager connectivity, central connectivity and logging.

#### Customizing Discovery Agent API Manager connectivity variables

This section connects the agent to API Manager and determines which APIs should be discovered and published to Amplify Central.

`APIMANAGER_HOST`: Machine name where API Manager is running. Use a hostname according to the certificate returned by the API-Manager.

`APIMANAGER_PORT`: API Manager port number (8075 by default).

`APIMANAGER_DISCOVERYIGNORETAGS` (optional): Comma-separated blacklist of tags. If an API has one or several of these blacklist tags, the agent ignores this API and will not publish it to Amplify Central. This property takes precedence over the filter property below. The default value is empty, which means no API is ignored.

`AMPMANGE_FILTER` (optional): Expression to filter the API you want the agent to discover. See [Discover APIs](/docs/central/connect-api-manager/filtering-apis-to-be-discovered/). Leaving this field empty tells the agent to discover all published APIs (REST / SOAP).

`APIMANAGER_SUBSCRIPTIONAPPLICATIONFIELD` (optional): The field name used to store Amplify Central subscription identifier inside the API Manager application securing the front end proxy. Default value is **subscriptions**. If you do not intend to change it, comment this property. Be aware that the field will not be visible in the API Manager application, as it is a specific configuration. If you want to see that field or customize it, refer to Add a custom property to applications in [Customize API Manager](/docs/apim_administration/apimgr_admin/api_mgmt_custom/#customize-api-manager-data/) documentation.

`APIMANAGER_POLLINTERVAL`: The frequency in which API Manager is polled for new endpoints. Default value is 30s.

`APIMANAGER_ALLOWAPPLICATIONAUTOCREATION` (optional): When creating a subscription on Amplify Central, setting this value to true will enable a selection in the App name dropdown for 'Create an application.' This allows the user to either select from an existing API Manager application, or to create a new application in API Manager. The new application in API Manager will be given the name of the subscription ID from Amplify Central. A value of false will cause 'Create an application' to not be shown in the dropdown. Default value is **false**.

`APIMANAGER_SUBSCRIPTIONSISSUENEWCREDENTIALS` (optional): When creating a subscription on Amplify Central, setting this value to true will enable a selection in the App name dropdown for ‘Create an application.’ This allows the user to either select from an existing API Manager application, or to create a new application in API Manager. The new application in API Manager will be given the name of the subscription ID from Amplify Central. A value of false will cause ‘Create an application’ to not be shown in the dropdown. Default value is **true**.

`APIMANAGER_AUTH_USERNAME`: An API Manager user the agent will use to connect to the API Manager. This user must have either the “API Manager Administrator” or “Organization administrator” role. Based on the role of this user, the agent is able to:

* discover any API from any organization (“API Manager Administrator”)  
* discovery any API from a specific organization (“Organization administrator”)

`APIMANAGER_AUTH_PASSWORD`: The password of the API Manager user in clear text.

Once all data is gathered, this section should looks like:

```shell
APIMANAGER_HOST=localhost
APIMANAGER_PORT=8075
APIMANAGER_AUTH_USERNAME=apiManagerUser
APIMANAGER_AUTH_PASSWORD=apiManagerUserPassword
APIMANAGER_DISCOVERYIGNORETAGS=tag1,tag2
APIMANAGER_FILTER=tag.APITAG==value
#APIMANAGER_POLLINTERVAL=30s
# Subscription management
#APIMANAGER_SUBSCRIPTIONAPPLICATIONFIELD=subscriptions
#APIMANAGER_ALLOWAPPLICATIONAUTOCREATION=true
#APIMANAGER_SUBSCRIPTIONSISSUENEWCREDENTIALS=true
```

#### Customizing Discovery Agent Central connectivity variables

This section connects the agent to Amplify Central and determines how to published the discovered APIs.

`CENTRAL_URL`: The Amplify Central url. Default value is **<https://apicentral.axway.com>**.

`CENTRAL_TEAM`: The Team name in Amplify Central that all APIs will be linked to. Locate this at Amplify Central > Access > Team Assets.

`CENTRAL_ORGANIZATIONID`: The Organization ID from Amplify Central. Locate this at Platform > User > Organization > Org ID field.

`CENTRAL_ENVIRONMENT`: The environment name you created when [preparing AMPLIFY Central](/docs/central/cli_central/cli_install/).

`CENTRAL_APISERVERVERSION`: The version of AMPLIFY Central API the agent is using. Default value is **v1alpha1**.

`CENTRAL_MODE`: The method to send endpoints back to Central. (publishToEnvironment = API Service, publishToEnvironmentAndCatalog = API Service and Catalog asset).  

`CENTRAL_AUTH_URL`: The Amplify login URL. Default value is **<https://login.axway.com/auth>**.

`CENTRAL_AUTH_REALM`: The Realm used to authenticate for Amplify Central. Default value is **Broker**.

`CENTRAL_AUTH_CLIENTID`: The Client ID of the Service Account (DOSA_....) you created when [preparing Amplify Central](/docs/central/cli_central/cli_install/). Locate this at AMPLIFY Central > Access > Service Accounts.

`CENTRAL_AUTH_PRIVATEKEY`: The location of the private key file you created when [preparing Amplify Central](/docs/central/cli_central/cli_install/). Absolute file path is recommended to avoid confusion.

`CENTRAL_AUTH_PUBLICKEY`:  The location of the public key file you created when [preparing Amplify Central](/docs/central/cli_central/cli_install/). Absolute file path is recommended to avoid confusion.  

`CENTRAL_AUTH_KEYPASSWORD`: The key password to open the key. None set up by default.

`CENTRAL_AUTH_TIMEOUT`: Timeout for the authentication. Default value is **10s**.

Once all data is gathered, this section should look like:

```shell
#CENTRAL_URL=https://apicentral.axway.com
CENTRAL_TEAM=Dev
CENTRAL_ORGANIZATIONID=68794y2
CENTRAL_ENVIRONMENT=my-v7-env
#CENTRAL_APISERVERVERSION=v1alpha1
#CENTRAL_MODE=publishToEnvironmmentAndCatalog
#CENTRAL_AUTH_URL=https://login.axway.com/auth
#CENTRAL_AUTH_REALM=Broker
CENTRAL_AUTH_CLIENTID=DOSA_66743...
CENTRAL_AUTH_PRIVATEKEY=/home/APIC-agents/private_key.pem
CENTRAL_AUTH_PUBLICKEY=/home/APIC-agents/public_key.pem
#CENTRAL_AUTH_KEYPASSWORD:
#CENTRAL_AUTH_TIMEOUT=10s
```

#### Customizing Discovery Agent SMTP Notification for subscription

The SMTP Notification variables defines how the agent manages email settings for subscriptions.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST`: SMTP server where the email notifications will originate from.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT`: Port of the SMTP server.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_FROMADDRESS`: Email address which will represent the sender.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME`: Login user for the SMTP server.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD`: Login password for the SMTP server.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE`: The authentication type based on the email server.  You may have to refer to the email server properties and specifications. This value defaults to NONE.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SUBSCRIBE_SUBJECT`: Subject of the email notification for action subscribe. Default is `Subscription Notification`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SUBSCRIBE_BODY`: Body of the email notification for action subscribe. Default is `Subscription created for Catalog Item: <a href= ${catalogItemUrl}> ${catalogItemName}</a><br/>${authtemplate}<br/>`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SUBSCRIBE_OAUTH:` Body of the email notification for action subscribe on OAuth authorization is `Your API is secured using OAuth token. You can obtain your token using grant_type=client_credentials with the following client_id=<b>${clientID}</b> and client_secret=<b>${clientSecret}</b>`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SUBSCRIBE_APIKEYS`: Body of the email notification for action subscribe on APIKey authorization is `Your API is secured using an APIKey credential: header: <b>${keyHeaderName}</b> / value: <b>${key}</b>`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_UNSUBSCRIBE_SUBJECT`: Subject of the email notification for action unsubscribe. Default is `Subscription Removal Notification`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_UNSUBSCRIBE_BODY`: Body of the email notification for action unsubscribe. Default is `Subscription for Catalog Item: <a href= ${catalogItemUrl}> ${catalogItemName}</a> has been unsubscribed`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SUBSCRIBEFAILED_SUBJECT`: Subject of the email notification for action subscribe failed. Default is `Subscription Failed Notification`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SUBSCRIBEFAILED_BODY`: Body of the email notification for action subscribe failed. Default is `Could not subscribe to CatalogItem: <a href= ${catalogItemUrl}> ${catalogItemName}</a>`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_UNSUBSCRIBEFAILED_SUBJECT`: Subject of the email notification for action unsubscribe failed. Default is `Subscription Removal Failed Notification`.

`CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_UNSUBSCRIBEFAILED_BODY` : Body of the email notification for action unsubscribe failed. Default is `Could not unsubscribe to Catalog Item: <a href= ${catalogItemUrl}> ${catalogItemName}</a>`.

#### Customizing Discovery Agent email server for subscription notifications

The `CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST`, which represents the email server, can be configured with minimal setup.  This section represents the email servers that have been currently tested. Please note, that all testing has been set up on port 587 signifying TLS support.  

```
# Google/Gmail server
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST=smtp.gmail.com
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT=587
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME=your GMAIL account
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD=application generated GMAIL password (see note below)
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE=PLAIN

# Microsoft office server
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST=smtp.office365.com
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT=587
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME=your Office Mail account
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD=your Office Mail password
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE=LOGIN

# Microsoft outlook server
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST=smtp-mail.outlook.com
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT=587
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME=your Outlook Mail account
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD=your Outlook Mail password
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE=PLAIN

# Yahoo email server
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST=smtp.mail.yahoo.com
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT=587
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME=your Yahoo Mail account
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD=application generated Yahoo password (see note below)
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE=PLAIN

# Amazon Simple Email Service
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST=email-smtp.<region>.amazonaws.com
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT=587
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME=user access key (see note below)
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD=user secret key (see note below)
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE=PLAIN
```

**Note**: You will be required to use an application generated password instead of the actual user email password for the following email servers. Follow the links for application generated passwords.

* Gmail - [Application generated gmail password](https://support.google.com/accounts/answer/185833?hl=en). Use this password in place of your actual password in the agent configuration `password:` field.
* Yahoo - [Application generated yahoo password](https://help.yahoo.com/kb/generate-third-party-passwords-sln15241.html). Use this password in place of your actual password in the agent configuration `password:` field.
* [AWS  Simple email service](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-smtp.html). Create your [SMTP credentials](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html) and use them in the username (ACCESS KEY) and password (SECRET KEY) of the agent configuration.

### Customizing Discovery Agent Webhook Notification for subscription

The Webhook Notification section defines how the agent manages to send notifications to a webhook URL. For using the webhook, you should set the variable `CENTRAL_SUBSCRIPTIONS_APPROVAL_MODE` to webhook value. Other available mode are: manual (default) or auto. Manual means that subscription has to be manually approved by an administrator, whereas auto will be automatically approved.

`CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_URL`: url where the webhook server is defined.

`CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_HEADERS`: Information used to verify the webhook. Provided by the customer, and may include such information as contentType and Authorization.

Both webhook and smtp  sections can be configured at the same time.  The agent will attempt the subscription notifications that are set in the agent config.

Once all data is gathered, this section should look like this for webhook and subscription Notification:

```shell
CENTRAL_SUBSCRIPTIONS_APPROVAL_MODE=webhook
CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_URL=http://mywebhookurl.com
CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_HEADERS=contentType,Value=application/json
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST=smtpServerHost
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT=smtpServerPort
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME=userName
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD=userPassword
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE=PLAIN
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_FROMADDRESS=agentSubscription@email.com
```

If you want to customize your SMTP email notifications to be something different than the defaults, you can add to the configuration file as follows:

```shell
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_SUBJECT==Custom Subscription Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_BODY=Subscription created for Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a><br/>${authtemplate}<br/> ${authtemplate}<br/>
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_OAUTH=Your API is secured using OAuth token. You can obtain your token using grant_type=client_credentials with the following client_id=<b>${clientID}</b> and client_secret=<b>${clientSecret}</b>
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_APIKEYS=Your API is secured using an APIKey credential=header=<b>${keyHeaderName}</b> / value=<b>${key}</b>

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBE_SUBJECT=Custom subscription Removal Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBE_BODY=Subscription for Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a> has been unsubscribed

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBEFAILED_SUBJECT=Custom Subscription Failed Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBEFAILED_BODY=Could not unsubscribe to Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a>.<br/>Error encountered: ${message}

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBEFAILED_SUBJECT=Custom Subscription Removal Failed Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBEFAILED_BODY=Could not unsubscribe to Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a>.<br/>Error encountered: ${message}
```

#### Customizing Discovery Agent logging variables

The log section defines how the agent is managing its logs.

`LOG_LEVEL`: The log level for output messages (debug, info, warn, error). Default value is **info**.

`LOG_FORMAT`: The format to print log messages (json, line, package). Default value is **json**.

`LOG_OUTPUT`: The output for the log lines (stdout, file, both). Default value is **stdout**.

`LOG_MASKEDVALUES` : Comma-separated list of keywords to identify within the agent config, which is used to mask its corresponding sensitive data. Keywords are matched by whole words and are case-sensitive. Displaying of agent config to the console requires that the log.level be at debug (level: debug).

`LOG_FILE_NAME`: The name of the log file. Default value is the name of the binary.

`LOG_FILE_PATH`: The path (relative / absolute) to save log files, if output is file or both.

`LOG_FILE_ROTATEEVERYMEGABYTES`: The maximum size, im megabytes, that log file can grow to.

`LOG_FILE_KEEPFILES`: The maximum number of log file backups to keep.

`LOG_FILE_CLEANBACKUPS`: The maximum age of a backup up, in days.

Once all data is gathered, this section should look like:

```shell
LOG_LEVEL=info
LOG_OUTPUT=stdout
LOG_PATH=logs
LOG_MASKEDVALUES=keyword1, keyword2, keyword3
LOG_FILE_NAME=discovery_agent.log
```

#### Validating your Discovery Agent configuration file

After customizing all variables, your `da_env_vars.env` file should look like:

```shell
# API Manager connectivity
APIMANAGER_HOST=localhost
APIMANAGER_PORT=8075
APIMANAGER_AUTH_USERNAME=apiManagerUser
APIMANAGER_AUTH_PASSWORD=apiManagerUserPassword
APIMANAGER_DISCOVERYIGNORETAGS=tag1,tag2
APIMANAGER_FILTER=tag.APITAG==value
#APIMANAGER_POLLINTERVAL=30s
# Subscription management
#APIMANAGER_SUBSCRIPTIONAPPLICATIONFIELD=subscriptions
#APIMANAGER_ALLOWAPPLICATIONAUTOCREATION=true
#APIMANAGER_SUBSCRIPTIONSISSUENEWCREDENTIALS=true

# Central connectivity 
#CENTRAL_URL=https://apicentral.axway.com
CENTRAL_TEAM=Dev
CENTRAL_ORGANIZATIONID=68794y2
CENTRAL_ENVIRONMENT=my-v7-env
#CENTRAL_APISERVERVERSION=v1alpha1
#CENTRAL_MODE=publishToEnvironmmentAndCatalog
#CENTRAL_AUTH_URL=https://login.axway.com/auth
#CENTRAL_AUTH_REALM=Broker
CENTRAL_AUTH_CLIENTID=DOSA_66743...
CENTRAL_AUTH_PRIVATEKEY=/home/APIC-agents/private_key.pem
CENTRAL_AUTH_PUBLICKEY=/home/APIC-agents/public_key.pem
#CENTRAL_AUTH_KEYPASSWORD:
#CENTRAL_AUTH_TIMEOUT=10s

# Subscription approval
CENTRAL_SUBSCRIPTIONS_APPROVAL_MODE=webhook
CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_URL=http://mywebhookurl.com
CENTRAL_SUBSCRIPTIONS_APPROVAL_WEBHOOK_HEADERS=contentType,Value=application/json

# Subscription SMTP definition
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_HOST=smtpServerHost
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PORT=smtpServerPort
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_USERNAME=userName
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_PASSWORD=userPassword
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_AUTHTYPE=PLAIN
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_FROMADDRESS=agentSubscription@email.com

# Subscription email notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_SUBJECT==Custom Subscription Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_BODY=Subscription created for Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a><br/>${authtemplate}<br/> ${authtemplate}<br/>
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_OAUTH=Your API is secured using OAuth token. You can obtain your token using grant_type=client_credentials with the following client_id=<b>${clientID}</b> and client_secret=<b>${clientSecret}</b>
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBE_APIKEYS=Your API is secured using an APIKey credential=header=<b>${keyHeaderName}</b> / value=<b>${key}</b>

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBE_SUBJECT=Custom subscription Removal Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBE_BODY=Subscription for Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a> has been unsubscribed

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBEFAILED_SUBJECT=Custom Subscription Failed Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_SUBSCRIBEFAILED_BODY=Could not unsubscribe to Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a>.<br/>Error encountered: ${message}

CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBEFAILED_SUBJECT=Custom Subscription Removal Failed Notification
CENTRAL_SUBSCRIPTIONS_NOTIFICATIONS_SMTP_UNSUBSCRIBEFAILED_BODY=Could not unsubscribe to Catalog Item=<a href= ${catalogItemUrl}> ${catalogItemName}</a>.<br/>Error encountered: ${message}

# logging
LOG_LEVEL=info
LOG_OUTPUT=stdout
LOG_PATH=logs
LOG_MASKEDVALUES=keyword1, keyword2, keyword3
```

### Running the Discovery Agent

#### Execute binary Discovery Agent in Foreground

Open a shell and run the following command to start up your agent:

```shell
cd /home/APIC-agents
./discovery_agent --envFile ./da_env_vars.env
{"level":"info","msg":"Starting Discovery agent for V7 APIGateway (-)","time":"2020-07-06T02:56:20-07:00"}
{"level":"info","msg":"Services are Ready","time":"2020-07-06T02:56:22-07:00"}
{"level":"info","msg":"Found new frontend proxy: EMR-System-Surgery","time":"2020-07-06T02:56:22-07:00"}
{"level":"info","msg":"Found new frontend proxy: Security-HIPAA-Control","time":"2020-07-06T02:56:22-07:00"}
...
```

To stop your binary agent, press Ctrl+C within the shell.

#### Execute binary Discovery Agent in Background

When executing in the background, it is best to save your logging to a file rather than the console output. See [Customizing log section (log)](#customizing-log-section-log) above.

Open a shell and run the following command to start up your agent:

```shell
cd /home/APIC-agents
./discovery_agent --envFile /path/to/da_env_vars.env &
[1] 13186
```

Notice that the line after the execution returns the PID (Process Identifier).

Run the following commands to kill the PID and stop your agent:

```shell
# to find the PID, if you do not know it
ps -ef | grep discovery_agent
ubuntu     13186    4615 16 13:37 pts/1    00:00:02 ./bin/discovery_agent

# to stop the PID
kill 13186
```

#### Execute Discovery Agent as a Service

The agent can be installed as a Linux service with systemd. The following commands will help you utilize the service. These commands install the service abilities and must be run as a root user.

When running as a service, it is best to save your logging to a file rather than the console output. See [Customizing log section (log)](#customizing-log-section-log) above.

* Install

  To install the service and have it execute as user axway and group axway:

  ```shell
  cd /home/APIC-agents
  sudo ./discovery_agent service install -u axway -g axway --envFile /path/to/da_env_file.env
  ```

* Start

  To start the service:

  ```shell
  cd /home/APIC-agents
  sudo ./discovery_agent service start
  ```

* Logs

  To get all logs for the service, since the machine last booted:

  ```shell
  cd /home/APIC-agents
  ./discovery_agent service logs
  ```

* Stop

  To stop the service:

  ```shell
  cd /home/APIC-agents
  sudo ./discovery_agent service stop
  ```

* Enable

  To enable the service to start when the machine starts:

  ```shell
  cd /home/APIC-agents
  sudo ./discovery_agent service enable
  ```

* Name

  To get the name of the service:

  ```shell
  cd /home/APIC-agents
  sudo ./discovery_agent service name
  ```

* Remove

  To uninstall the service from the machine:

  ```shell
  cd /home/APIC-agents
  sudo ./discovery_agent service stop   # to ensure it is not running
  sudo ./discovery_agent service remove
  ```

#### Verify Discovery Agent is running

To verify if the agent is up and running, open a shell and run:

```shell
cd /home/APIC-agents
./discovery_agent --envFile /path/to/da_env_vars.env --status

{
  "name"="discovery_agent",
  "version"="-",
  "status"="OK",
  "statusChecks"={
    "apimanager"={
      "name"="API Manager",
      "endpoint"="apimanager",
      "status"={
        "result"="OK"
      }
    },
    "central"={
      "name"="Amplify Central",
      "endpoint"="central",
      "status"={
        "result"="OK"
      }
    }
  }
}
```

#### Run the Dockerized Discovery Agent

1. Copy the `private_key.pem` and `public_key.pem` files that were originally created when you set up your Service Account to a keys directory. Make sure the directory is located on the machine being used for deployment.
2. Start the Docker Discovery Agent pointing to the `da_env_vars.env` file and the keys directory. `pwd` relates to the local directory where the docker command is run. For Windows, the absolute path is preferred.

   ```shell
   docker run --env-file ./da_env_vars.env -v <pwd>/keys:/keys axway.jfrog.io/ampc-public-docker-release/agent/v7-discovery-agent:latest
   ```
3. Run the following health check command to ensure the agent is up and running:

   ```shell
   docker inspect --format='{{json .State.Health}}' <container>
   ```

## Traceability Agent

The Traceability Agent is used to filter the Axway API Gateway logs that are related to discovered APIs and prepare the transaction events that are sent to Amplify platform. Each time an already discovered API is called by a consumer, an event (summary + detail) is sent to Amplify Central and is visible in API Observer.

The binary agent can run in the following mode:

* Default: With a yaml configuration file having the same name as the agent binary - `traceability_agent.yml`. Some values (Central url / authentication url) are defaulted to avoid mistake and will not be visible in the provided traceability_agent.yml file.
* **Recommended**: With an environment variable file `ta_env_vars.env`. All values in the `traceability_agent.yml` file can be overridden with environment variables. Those environment variables can be stored in a single file and this file can be located anywhere (use --envFile flag in the agent command line to access it=`./traceability_agent --envFile /home/config/ta_env_vars.env`). This makes it easy to update the agent (binary/yaml) without loosing the agent configuration. All environment variables are described in [Traceability Agent variables](/docs/central/connect-api-manager/agent-variables/) section.

The containerized agent can run in the following mode:

* With an environment variables configuration file, `ta_env_vars.env`, supplied as a command line argument when running the Docker image.

### Installing the Traceability Agent

#### To install the binary Traceability Agent

**Step 1**: Download the latest version of the zip file from the Axway public repository using the following command:

```shell
curl -L "https://axway.jfrog.io/artifactory/ampc-public-generic-release/v7-agents/v7_traceability_agent/latest/traceability_agent-latest.zip" -o traceability_agent-latest.zip
```

**Step 2**: Unzip the file traceability_agent-latest.zip to get the agent binary (traceability_agent) and a template configuration file (traceability_agent.yml).

```shell
unzip traceability_agent-latest.zip
```

**Step 3**: Copy those 2 files into a folder (/home/APIC-agents for instance) on the machine where the API Manager environment is located.

**Step 4**: If not done yet, move the `private_key.pem` and `public_key.pem` files that were originally created when you set up your Service Account to the agent directory (APIC-agents). Note that the `public_key` comes from Steps 3 or 4 of [Create a Service Account](/docs/central/cli_central/cli_install/#authorize-your-cli-to-use-the-amplify-central-apis) depending if you choose to use the `der` format or not.

#### To install the Dockerized Traceability Agent

Create your Discovery Agent environment file, `ta_env_vars.env`. See [Traceability Agent variables](/docs/central/connect-api-manager/agent-variables/) for a reference to variable descriptions.
After customizing all the sections, your `ta_env_vars.env` file should look like this example file:

```shell
# API MANAGER connectivity
APIMANAGER_HOST=<HOST>
APIMANAGER_AUTH_USERNAME=<USER>
APIMANAGER_AUTH_PASSWORD=<PASSWORD>

# API GATEWAY connectivity
APIGATEWAY_HOST=<HOST>
APIGATEWAY_AUTH_USERNAME=<USER>
APIGATEWAY_AUTH_PASSWORD=<PASSWORD>

# Amplify connectivity
CENTRAL_ORGANIZATIONID=<ORGANIZATIONID>
CENTRAL_TEAM=<TEAM>
CENTRAL_AUTH_CLIENTID=<CLIENTID, ie. DOSA_12345...>
CENTRAL_ENVIRONMENT=<Environment>
```

* The value for *team* can be found in [Amplify Central > Access > Team Assets](https://apicentral.axway.com/access/teams/).
* The value for *organizationID* can be found in Amplify Central Platform > Organization.
* The value for *clientId* can be found in Service Account. See [Create a service account](/docs/central/cli_central/cli_install/#authorize-your-cli-to-use-the-amplify-central-apis).

Pull the latest Docker image of the Traceability Agent:

```shell
docker pull axway.jfrog.io/ampc-public-docker-release/agent/v7-traceability-agent:latest
```

### Customizing the Traceability Agent environment variable file

The `ta_env_vars.env` configuration file contain six sections to customize: the beat input, API Manager connectivity, API Gateway connectivity, central connectivity, output ingestion service and logging.

#### Customizing beat input variables

This section describes where the API Gateway logs are located on the machine so the beat can read them.

`EVENT_LOG_PATHS`: List all API Gateway event log files (absolute path) the beat will listen to. It could be a single file if there is only one gateway installed on the machine, or multiple files if several gateways are installed on the same machine.

Single Gateway - explicit file name

```shell
EVENT_LOG_PATHS=<API GATEWAY INSTALL DIRECTORY>/apigateway/events/group-2_instance-1.log
```

Multiple Gateways on the same machine - explicit file names

```shell
EVENT_LOG_PATHS=<API GATEWAY INSTALL DIRECTORY>/apigateway/events/group-2_instance-1.log <API GATEWAY INSTALL DIRECTORY>/apigateway/events/group-2_instance-3.log <API GATEWAY INSTALL DIRECTORY>/apigateway/events/group-2_instance-7.log
```

Multiple Gateways on the same machine - file path with wildcard

```shell
# Input files
EVENT_LOG_PATHS=<API GATEWAY INSTALL DIRECTORY>/apigateway/events/group-2_instance-?.log
```

#### Customizing Traceability Agent API Manager connectivity variables

This section tells the agent which API needs to be monitored=one that has been discovered by the Discovery Agent.
This section is exactly the same as the [Discovery Agent - API Manager](/docs/central/connect-api-manager/gateway-administation/#customizing-discovery-agent-api-manager-connectivity-variables)

Once all data is gathered, this section should look like:

```shell
# API Manager connectivity
APIMANAGER_HOST=localhost
APIMANAGER_PORT=8075
APIMANAGER_AUTH_USERNAME=apiManagerUser
APIMANAGER_AUTH_PASSWORD=apiManagerUserPassword
```

#### Customizing Traceability Agent API Gateway connectivity variables

This section helps the agent to collect the header from request/response from the API Gateway system.

`APIGATEWAY_GETHEADERS`: Tells the agent to  call the API Gateway API to get additional transaction details (headers). Default value is **true**. If false, API Gateway config does not need to be set and no headers will be send to Amplify Central.

`APIGATEWAY_HOST`: The host that Axway API Gateway is running on. Default value is **localhost**.

`APIGATEWAY_PORT`: The port that Axway API Gateway is listening on. Default value is **8090**.

`APIGATEWAY_POLLINTERVAL`: The frequency in which the agent polls the logs in us, ms, s, m, h. Default value is **1m**.

`APIGATEWAY_AUTH_USERNAME`: An Axway API Gateway username with the "API Gateway operator" role.

`APIGATEWAY_AUTH_PASSWORD`: The Axway API Gateway username password in clear text.

Security connection settings: By default, for connecting to API Gateway, the agent uses TLS 1.2 with a predefined list of cipher suites. Refer to [Administer API Manager agent security](/docs/central/connect-api-manager/agent-security-api-manager/) section for changing this behavior.

Once all data is gathered, this section should look like:

```shell
# API Gateway connectivity
APIGATEWAY_HOST=localhost
APIGATEWAY_PORT=8090
APIGATEWAY_AUTH_USERNAME=myApiGatewayOperatorUser
APIGATEWAY_AUTH_PASSWORD=myApiGatewayOperatorUserPassword
#APIGATEWAY_GETHEADERS=true 
#APIGATEWAY_POLLINTERVAL
```

#### Customizing Traceability Agent Central connectivity variables

This section connects the agent to Amplify Central.
This section is exactly the same as the [Discovery Agent - Central connectivity](/docs/central/connect-api-manager/gateway-administation/#customizing-discovery-agent-central-connectivity-variables)

Once all data is gathered, the variable list should look like:

```shell
# Central connectivity
#CENTRAL_URL=https://apicentral.axway.com
CENTRAL_TEAM=Dev
CENTRAL_ORGANIZATIONID=68794y2
CENTRAL_ENVIRONMENT=my-v7-env
#CENTRAL_APISERVERVERSION=v1alpha1
#CENTRAL_MODE=publishToEnvironmmentAndCatalog
#CENTRAL_AUTH_URL=https://login.axway.com/auth
#CENTRAL_AUTH_REALM=Broker
CENTRAL_AUTH_CLIENTID=DOSA_66743...
CENTRAL_AUTH_PRIVATEKEY=/home/APIC-agents/private_key.pem
CENTRAL_AUTH_PUBLICKEY=/home/APIC-agents/public_key.pem
#CENTRAL_AUTH_KEYPASSWORD:
#CENTRAL_AUTH_TIMEOUT=10s
```

#### Customizing Traceability Agent output ingestion service variables

This section describes where the logs should be sent on Amplify Central.

`TRACEABILITY_HOST`: The host and port of the ingestion service to forward the transaction log entries. Default value is **ingestion-lumberjack.datasearch.axway.com:453**.

`TRACEABILITY_PROTOCOL`: The protocol (https or tcp) to be used for communicating with ingestion service. Default value is **tcp**.

`TRACEABILITY_PROXYURL`: The socks5 or http URL of the proxy server for ingestion service (**socks5://username:password@hostname:port**) to use when the API Management eco-system is not allowed to access the internet world where Amplify Central is installed. **username** and **password** are optional and can be omitted if not required by the proxy configuration. Leaving this value empty means that no proxy will be used to connect to Amplify Central ingestion service.

`TRACEABILITY_COMPRESSIONLEVEL`: The gzip compression level for the output event. Default value is **3**.

`TRACEABILITY_BULKMAXSIZE`: Maximum number of events to bulk in  a single ingestion request. Default value is 100.

`TRACEABILITY_TIMEOUT`: Time to wait for ingestion response. Default value is 300s.

Security connection settings: By default, for connecting to API Gateway, the agent uses TLS 1.2 with a predefined list of cipher suites. Refer to [Administer API Manager agent security](/docs/central/connect-api-manager/agent-security-api-manager/) section for changing this behavior.

Once all data is gathered, the section should look like this if you do not use a proxy:

```shell
# Send output to Central Database
TRACEABILITY_HOST=ingestion-lumberjack.datasearch.axway.com:453
TRACEABILITY_PROTOCOL=tcp
#TRACEABILITY_PROXYURL=socks5://username:password@hostname:port
#TRACEABILITY_COMPRESSIONLEVEL=3
#TRACEABILITY_BULKMAXSIZE=100
#TRACEABILITY_TIMEOUT=300s
```

#### Customizing Traceability Agent beat queuing section variables

The queue section defines the internal Filebeat queue to store events before publishing them. The queue is responsible for buffering and combining events into batches that can be consumed by the outputs. The outputs use bulk operations to send a batch of events in one transaction.

`QUEUE_MEM_EVENTS`: Number of events the queue can store (2048 by default).

`QUEUE_MEM_FLUSH_MINEVENTS`: Minimum number of events required for publishing. If this value is set to 0, the output starts publishing events without additional waiting times. Otherwise, the output must wait for more events to become available (100 by default).

`QUEUE_MEM_FLUSH_TIMEOUT`: Maximum wait time for `QUEUE_MEM_FLUSH_MINEVENTS` to be fulfilled (1 second by default). If set to 0s, events are immediately available for consumption.

Once all data is gathered, this section should look like:

```shell
#QUEUE_MEM_EVENTS=2048
#QUEUE_MEM_FLUSH_MINEVENTS=100
#QUEUE_MEM_FLUSH_TIMEOUT=1s
```

#### Customizing Traceability Agent logging variables

The log section defines how the agent manages its logs. This section is similar to the one define for the [Discovery Agent](/docs/central/connect-api-manager/gateway-administation/#customizing-discovery-agent-logging-variables)

Once all data is gathered, this section should look like this for standard output logging:

```shell
LOG_LEVEL=info
LOG_OUTPUT=stdout
LOG_PATH=logs
LOG_FILE_NAME=traceability_agent.log
```

#### Validating your Traceability Agent configuration file

After customizing all variables, your `ta_env_vars.env` file should look like:

```shell
# Input files
EVENT_LOG_PATHS=<API GATEWAY INSTALL DIRECTORY>/apigateway/events/group-2_instance-?.log

# API Manager connectivity
APIMANAGER_HOST=localhost
APIMANAGER_PORT=8075
APIMANAGER_AUTH_USERNAME=apiManagerUser
APIMANAGER_AUTH_PASSWORD=apiManagerUserPassword

# API Gateway connectivity
APIGATEWAY_HOST=localhost
APIGATEWAY_PORT=8090
APIGATEWAY_AUTH_USERNAME=myApiGatewayOperatorUser
APIGATEWAY_AUTH_PASSWORD=myApiGatewayOperatorUserPassword
#APIGATEWAY_GETHEADERS=true 
#APIGATEWAY_POLLINTERVAL

# Central connectivity
#CENTRAL_URL=https://apicentral.axway.com
CENTRAL_TEAM=Dev
CENTRAL_ORGANIZATIONID=68794y2
CENTRAL_ENVIRONMENT=my-v7-env
#CENTRAL_APISERVERVERSION=v1alpha1
#CENTRAL_MODE=publishToEnvironmmentAndCatalog
#CENTRAL_AUTH_URL=https://login.axway.com/auth
#CENTRAL_AUTH_REALM=Broker
CENTRAL_AUTH_CLIENTID=DOSA_66743...
CENTRAL_AUTH_PRIVATEKEY=/home/APIC-agents/private_key.pem
CENTRAL_AUTH_PUBLICKEY=/home/APIC-agents/public_key.pem
#CENTRAL_AUTH_KEYPASSWORD:
#CENTRAL_AUTH_TIMEOUT=10s

# Send output to Central Database
TRACEABILITY_HOST=ingestion-lumberjack.datasearch.axway.com:453
TRACEABILITY_PROTOCOL=tcp
#TRACEABILITY_PROXYURL=socks5://username:password@hostname:port
#TRACEABILITY_COMPRESSIONLEVEL=3
#TRACEABILITY_BULKMAXSIZE=100
#TRACEABILITY_TIMEOUT=300s

#logging
LOG_LEVEL=info
LOG_OUTPUT=stdout
LOG_PATH=logs
LOG_FILE_NAME=traceability_agent.log
```

### Running the binary Traceability Agent

Open a shell and run the following command to start up your agent:

#### Execute binary Traceability Agent in Foreground

Open a shell and run the following command to start up your agent:

```shell
cd /home/APIC-agents
./traceability_agent --envFile ta_env_vars.env
```

To stop your agent, press Ctrl+C within the shell.

#### Execute binary Traceability Agent in Background

When executing in the background, it is best to save your logging to a file rather than the console output. See [Customizing log section (logging)](#customizing-log-section-logging) above.

Open a shell and run the following command to start up your agent:

```shell
cd /home/APIC-agents
./traceability_agent --envFile ta_env_vars.env &
[1] 13186
```

Notice that the line after the execution returns the PID (Process Identifier).

Run the following commands to kill the PID and stop your agent:

```shell
# to find the PID, if you do not know it
ps -ef | grep traceability_agent
ubuntu     13186    4615 16 13:37 pts/1    00:00:02 ./bin/traceability_agent

# to stop the PID
kill 13186
```

#### Execute binary Traceability Agent as a Service

The agent can be installed as a Linux service, with systemd. The following commands will help you utilize the service. These commands install the service abilities and must be run as a root user.

When running as a service, it is best to save your logging to a file rather than the console output. See [Customizing log section (logging)](#customizing-log-section-logging) above.

* Install

  To install the service and have it execute as user axway and group axway:

  ```shell
  cd /home/APIC-agents
  sudo ./traceability_agent service install -u axway -g axway --envFile /path/to/ta_env_file.env
  ```

* Start

  To start the service:

  ```shell
  cd /home/APIC-agents
  sudo ./traceability_agent service start
  ```

* Logs

  To get all logs for the service, since the machine last booted:

  ```shell
  cd /home/APIC-agents
  ./traceability_agent service logs
  ```

* Stop

  To stop the service:

  ```shell
  cd /home/APIC-agents
  sudo ./traceability_agent service stop
  ```

* Enable

  To enable the service to start when the machine starts:

  ```shell
  cd /home/APIC-agents
  sudo ./traceability_agent service enable
  ```

* Name

  To get the name of the service:

  ```shell
  cd /home/APIC-agents
  sudo ./traceability_agent service name
  ```

* Remove

  To uninstall the service from the machine:

  ```shell
  cd /home/APIC-agents
  sudo ./traceability_agent service stop   # to ensure it is not running
  sudo ./traceability_agent service remove
  ```

#### Verify binary Traceability Agent is Running

To verify if the agent is up and running, open a shell command and run:

```shell
cd /home/APIC-agents
./traceability_agent status
```

##### Install and run Dockerized Traceability Agent

* See "To install the Dockerized Discovery Agent" section above for the `ta_env_vars.env` configuration.

1. Copy the `private_key.pem` and `public_key.pem` files that were originally created when you set up your Service Account to a keys directory. Make sure the directory is located on the machine being used for deployment.
2. Start the Traceability Agent pointing to the `ta_env_vars.env` file, `keys`, and the logging `events` directory. `pwd` relates to the local directory where the docker command is run. For Windows, the absolute path is preferred.

   ```shell
   docker run --env-file ./ta_env_vars.env -v <pwd>/keys:/keys -v <pwd>/events:/events axway.jfrog.io/ampc-public-docker-release/agent/v7-traceability:latest
   ```

   * See [Create and start API Gateway Docker container](/docs/apim_installation/apigw_containers/docker_script_gwimage/#mount-volumes-to-persist-logs-outside-the-api-gateway-container/) for more  information regarding the persistent API Gateway trace and event logs to a directory on your host machine.
   * Run the following health check command to ensure the agent is up and running:

   ```shell
   docker inspect --format='{{json .State.Health}}' <container>
   ```
