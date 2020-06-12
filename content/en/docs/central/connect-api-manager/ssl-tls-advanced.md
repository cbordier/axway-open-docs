---
title: SSL / TLS advanced
linkTitle: SSL / TLS advanced
draft: false
weight: 90
description: By default, the connection from the agents to AMPLIFY Central is
  SSL secured using TLS1.2 and the appropriate secured default Cipher Suite.
  However, you can choose to change the default behavior and use different variable values
  for protocols and supported Cipher Suites that meet your own requirements. See details below.
---
{{< alert title="Note" color="primary" >}}TLS 1.3 is not yet supported by AMPLIFY Central.{{< /alert >}}

## Supported TLS versions

TLS 1.0, TLS 1.1 and **TLS 1.2** (default).

These versions can be set up in any agent configuration variable referring to `ssl.minVersion` or `ssl.maxVersion`.\
If `ssl.minVersion` and `ssl.maxVersion` are incompatible, the agent will not start.

## Default Cipher Suites

ECDHE-ECDSA-AES-256-GCM-SHA384 \
ECDHE-RSA-AES-256-GCM-SHA384

ECDHE-ECDSA-CHACHA20-POLY1305\
ECDHE-RSA-CHACHA20-POLY1305

ECDHE-ECDSA-AES-128-GCM-SHA256\
ECDHE-RSA-AES-128-GCM-SHA256

ECDHE-ECDSA-AES-128-CBC-SHA256\
ECDHE-RSA-AES-128-CBC-SHA256

## Supported Cipher Suites

ECDHE-ECDSA-AES-128-CBC-SHA\
ECDHE-ECDSA-AES-128-CBC-SHA256\
ECDHE-ECDSA-AES-128-GCM-SHA256\
ECDHE-ECDSA-AES-256-CBC-SHA\
ECDHE-ECDSA-AES-256-GCM-SHA384\
ECDHE-ECDSA-CHACHA20-POLY1305\
ECDHE-ECDSA-RC4-128-SHA\
ECDHE-RSA-3DES-CBC3-SHA\
ECDHE-RSA-AES-128-CBC-SHA\
ECDHE-RSA-AES-128-CBC-SHA256\
ECDHE-RSA-AES-128-GCM-SHA256\
ECDHE-RSA-AES-256-CBC-SHA\
ECDHE-RSA-AES-256-GCM-SHA384\
ECDHE-RSA-CHACHA20-POLY1305\
ECDHE-RSA-RC4-128-SHA

RSA-RC4-128-SHA\
RSA-3DES-CBC3-SHA\
RSA-AES-128-CBC-SHA\
RSA-AES-128-CBC-SHA256\
RSA-AES-128-GCM-SHA256\
RSA-AES-256-CBC-SHA\
RSA-AES-256-GCM-SHA384

TLS-AES-128-GCM-SHA256\
TLS-AES-256-GCM-SHA384\
TLS-CHACHA20-POLY1305-SHA256

## Customize `ssl.InsecureSkipVerify` option

This option controls whether a client verifies the server’s certificate chain and host name. If true, then TLS accepts any certificate presented by the server and any host name in that certificate. In this mode, TLS is susceptible to man-in-the-middle attacks. If false (by default), then TLS accepts only the certificate containing the hostname that matches the server hostname.
