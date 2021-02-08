---
title: Administer AWS Gateway network traffic
linkTitle: Administer AWS Gateway network traffic
draft: false
weight: 30
description: Traffic is always initiated by the Agent to AWS and Amplify
  Central. No sessions are ever initiated back to the Agent.
---

## Data destinations

The destination for:

* Agent Authentication data is `login.axway.com`

* AWS API Gateway data is  `apicentral.axway.com`

* API Event data is `ingestion-lumberjack.datasearch.axway.com`
, `ingestion.datasearch.axway.com`, `ingestion-lumberjack.visibility.eu-fr.axway.com` or `ingestion.visibility.eu-fr.axway.com`

## Communication ports

All outbound traffic is sent over SSL via TCP / UDP.

Open the following ports to benefit from all the Agent functionalities:

**Outbound**:

| Region | Host                                                                                    | Port               | Protocol     | Data                               |
|--------|-----------------------------------------------------------------------------------------|--------------------|--------------|------------------------------------|
| US/EU  | platform.axway.com                                                                      | 443                | HTTPS        | Platform user info                 |
| US/EU  | login.axway.com                                                                         | 443                | HTTPS        | Authentication                     |
| US     | apicentral.axway.com                                                                    | 443                | HTTPS        | API definitions, Subscription info |
| EU     | central.eu-fr.axway.com                                                                 | 443                | HTTPS        | API definitions, Subscription info |
| US     | ingestion-lumberjack.datasearch.axway.com or ingestion.datasearch.axway.com             | 453 or 443         | TCP or HTTPS | API event data                     |
| EU     | ingestion-lumberjack.visibility.eu-fr.axway.com or ingestion.visibility.eu-fr.axway.com | 453 or 443         | TCP or HTTPS | API event data                     |

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
