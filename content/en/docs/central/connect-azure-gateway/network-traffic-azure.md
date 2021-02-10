---
title: Administer Azure network traffic
linkTitle: Administer Azure network traffic
draft: false
weight: 30
description: Traffic is always initiated by the Agent to Azure API Manager and Amplify Central. No sessions are ever initiated back to the
  Agent.
---

## Data destinations

The destination for:

* Agent Authentication data is `login.axway.com`
* API definition (Swagger or WSDL) and API documentation data is `apicentral.axway.com`
* API Event data, the transaction summary and headers, is `ingestion-lumberjack.datasearch.axway.com`
* Subscription notification for getting platform user information is `platform.axway.com`

## Data exchanged

### Discovery Agent

The Discovery Agent sends the following information to the Axway Amplify platform:

* API definition using Swagger or WSDL depending on the API type (REST vs SOAP)
* API documentation

### Traceability Agent

Only traffic related to discovered APIs is sent to the platform.

The agent reads the logs written on the file system (\[INSTALL_DIR]/apigateway/events/group-X_instance-Y.log) by the Gateway(s) to get the transaction summary:

* Transaction HTTP status
* Transction URLs (frontend / backend API)
* Transaction duration and timestamp
* Transaction service called: method (POST / GET...) + uri path

In order to submit details of the transaction, the Traceability Agent reads the Gateway system to get the transaction details:

* Request/response headers from each API call  

{{< alert title="Note" color="primary" >}}You can disable sending the headers by using the following property:  `traceability_agent.azure.getHeaders: false.` By default, the property is set to true. If collecting the headers is disabled, they will not be visible in Axway Amplify platform Observability module, as the Traceability Agent will send only the transaction summary data (status / url / duration / timestamp / transaction service called) to the platform.{{< /alert >}}

Once the information is extracted it is sent to the Axway platform using the TLS encryption.

## Communication ports

All outbound traffic is sent over SSL via TCP / UDP.

Open the following ports so that agents can communicate to the Amplify platform:

**Outbound**:

| Region | Host                                                                                    | IP address (static)  | Port               | Protocol     | Data                               |
|--------|-----------------------------------------------------------------------------------------|----------------------|--------------------|--------------|------------------------------------|
| US/EU  | platform.axway.com                                                                      | 34.211.114.227<br/>54.201.86.113 | 443                | HTTPS        | Platform user info                 |
| US/EU  | login.axway.com                                                                         | 52.58.132.2<br/>52.29.4.35<br/>54.93.140.145  | 443                | HTTPS        | Authentication                     |
| US     | apicentral.axway.com                                                                    | 3.94.245.118<br/>54.208.199.251<br/>3.212.78.217<br/>52.202.95.208<br/>107.23.176.64<br/>3.225.16.120  | 443                | HTTPS        | API definitions, Subscription info |
| EU     | central.eu-fr.axway.com                                                                 | 52.47.84.198<br/>13.36.25.69<br/>35.181.21.87<br/>13.36.2.143<br/>13.36.52.216<br/>15.236.7.112  | 443                | HTTPS        | API definitions, Subscription info |
| US     | ingestion-lumberjack.datasearch.axway.com<br/>or<br/>ingestion.datasearch.axway.com             | 54.225.171.111<br/>54.225.2.221<br/>54.146.97.250<br/>54.147.98.128<br/>52.206.193.184<br/>54.225.92.97    | 453<br/>or<br/>443         | TCP<br/>or<br/>HTTPS | API event data                     |
| EU     | ingestion-lumberjack.visibility.eu-fr.axway.com<br/>or<br/>ingestion.visibility.eu-fr.axway.com | 15.236.125.123<br/>35.180.77.202<br/>13.36.27.97<br/>13.36.33.229 | 453<br/>or<br/>443         | TCP<br/>or<br/>HTTPS | API event data                     |

Note: _Region_ column is representing the region where your Amplify organization is deployed. EU means deployed in European data center and US meaning deployed in US data center. Be sure to use the corresponding _Host_/_Port_ for your agents to operate correctly.

**Inbound**:

The docker container does not expose any ports outside of the container. Within the container the following listen:

| Host                                       | Port               | Protocol  | Data                                |
|--------------------------------------------|--------------------|-----------|-------------------------------------|
| Docker Container                           | 8989 (default)     | HTTPS     |Serves the status of the agent and its dependencies for monitoring  |

## Validation

### Direct Connection

**Connecting to Amplify Central and Login hosts:**

```shell
curl -s -o /dev/null -w "%{http_code}"  https://apicentral.axway.com
```

```shell
curl -s -o /dev/null -w "%{http_code}"  https://login.axway.com
```

A return of **"200"** validates the connection was established.

**Connecting to Amplify Central Event Traffic host, HTTPS:**

```shell
curl -s -o /dev/null -w "%{http_code}" https://ingestion.datasearch.axway.com
```

A return of **"200"** validates the connection was established.

**Connecting to Amplify Central Event Traffic host, Lumberjack:**

```shell
curl ingestion-lumberjack.datasearch.axway.com:453
```

A return of **"curl: (52) Empty reply from server"** validates the connection was established.

### Connection via Proxy

**Connecting to Amplify Central and Login hosts:**

```shell
curl -x {{proxy_host}}:{{proxy_port}} -s -o /dev/null -w "%{http_code}"  https://apicentral.axway.com
```

```shell
curl -x {{proxy_host}}:{{proxy_port}} -s -o /dev/null -w "%{http_code}"  https://login.axway.com
```

A return of **"200"** validates the connection was established.

**Connecting to Amplify Central Event Traffic host, HTTPS:**

```shell
curl -x {{proxy_host}}:{{proxy_port}} -s -o /dev/null -w "%{http_code}" https://ingestion.datasearch.axway.com
```

A return of **"200"** validates the connection was established.

**Connecting to Amplify Central Event Traffic host, Lumberjack:**

```shell
curl -x socks5://{{proxy_host}}:{{proxy_port}} ingestion-lumberjack.datasearch.axway.com:453
```

A return of **"curl: (52) Empty reply from server"** validates the connection was established.

## Troubleshooting

### Curl connection to ingestion-lumberjack.datasearch.axway.com

* **Error:**

  ```shell
  curl: (6) Could not resolve host: ingestion-lumberjack.datasearch.axway.com
  ```

    * **Cause:** The host making the call can’t resolve the ingestion-lumberjack DNS name.

    * **Possible Resolution:** Tell curl to resolve the hostname on the proxy:

      ```shell
      curl -x socks5h://{{proxy_host}}:{{proxy_port}} ingestion-lumberjack.datasearch.axway.com
      ```

* **Error:**

  ```shell
  curl: (7) No authentication method was acceptable.
  ```

    * **Cause:** The SOCKS proxy server expected an authentication type other than what was specified.

    * **Possible Resolution:** Provide authentication to the proxy:

      ```shell
      socks5://{{username}}:{{password}}@{{proxy_host}}:{{proxy_port}}
      ```

      The Agents only support the use of username/password authentication method for SOCKS connections.
