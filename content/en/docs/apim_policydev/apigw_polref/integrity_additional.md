{
    "title": "Additional integrity filters",
    "linkTitle": "Additional integrity filters",
    "weight": 97,
    "date": "2019-10-17",
    "description": "Sign and verify JWT and SMIME messages."
}

## JWT Sign filter

You can use the **JWT Sign** filter to sign arbitrary content (for example, a JWT claims set). The result is called JSON Web Signature (JWS).

JWS represents digitally signed or MACed content using JSON data structures and base64url encoding.

A JWS represents the following logical values:

* JOSE header
* JWS payload
* JWS signature

The signed content is outputted in JWS Compact Serialization format, which is produced by base64 encoding the logical values and concatenating them with periods (`‘.’`) in between. For example:

```
{"iss":"joe",
"exp":1300819380,
"http://example.com/is_root":true}
```

When the JOSE header, JWS payload, and JWS signature is combined as follows:

```
BASE64URL(UTF8(JWS Protected Header)) '.'
BASE64URL(JWS Payload) '.'
BASE64URL(JWS Signature)
```

The following string is returned:

```
eyJhbGciOiJSUzI1NiJ9
.
eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFt
cGxlLmNvbS9pc19yb290Ijp0cnVlfQ
.
cC4hiUPoj9Eetdgtv3hF80EGrhuB__dzERat0XF9g2VtQgr9PJbu3XOiZj5RZmh7
AAuHIm4Bh-0Qc_lF5YKt_O8W2Fp5jujGbds9uJdbF9CUAr7t1dnZcAcQjbKBYNX4
BAynRFdiuB—f_nZLgrnbyTyWzO75vRK5h6xBArLIARNPvkSjtQBMHlb1L07Qe7K
0GarZRmB_eSN9383LcOLn6_dO—xi12jzDwusC-eOkHWEsqtFZESc6BfI7noOPqv
hJ1phCnvWh6IeYI2w9QOYEUipUTI8np6LbgGY9Fs98rqVt5AXLIhWkWywlVmtVrB
p0igcN_IoypGlUPQGe77Rw
```

Configure the following settings on the **JWT Sign** window:

* **Name**: Enter an appropriate name for the filter to display in a policy.
* **Token location**: Enter the selector expression to obtain the payload to be signed. The content can be JWT claims, encrypted token, or you can enter a different option.

### Signature Key and Algorithm

On the **Signature Key and Algorithm** tab, you can select either a symmetric or an asymmetric key to sign the JWT. Select the appropriate option and configure the fields in the corresponding section.

* **Key type**: Select whether to sign with a private key (asymmetric) or HMAC (symmetric key).

#### Asymmetric key type

If you selected the asymmetric key type, configure the following fields in the **Asymmetric** section:

* **Signing key**: Select a certificate with a private key from the certificate store. The private key is used to sign the payload, while the certificate is used to generate key related headers in the JOSE header.
* **Selector expression**: Alternatively, enter a selector expression to get the alias of the private key in the certificate store.
* **Algorithm**: Select one of the available algorithms to sign the JWT.

  | Algorithm | Description                                    |
  |-----------|------------------------------------------------|
  | ES256     | ECDSA using P-256 and SHA-256                  |
  | ES384     | ECDSA using P-384 and SHA-384                  |
  | ES512     | ECDSA using P-521 and SHA-512                  |
  | RS256     | RSASSA-PKCS1-v1_5 using SHA-256                |
  | RS384     | RSASSA-PKCS1-v1_5 using SHA-384                |
  | RS512     | RSASSA-PKCS1-v1_5 using SHA-512                |
  | PS256     | RSASSA-PSS using SHA-256 and MGF1 with SHA-256 |
  | PS384     | RSASSA-PSS using SHA-384 and MGF1 with SHA-384 |
  | PS512     | RSASSA-PSS using SHA-512 and MGF1 with SHA-512 |

  The selected algorithm must be compatible with the selected certificate. When a certificate is selected from the certificate store, this will be validated when the filter is saved. A selector based alias can only be validated at runtime, and an incompatible certificate will cause the filter to fail.

* **Use Key ID (kid)**: Selecting this option will add a `kid` header parameter to the JOSE header part of the token. The `kid` header parameter is a hint indicating which public/private key pair was used to secure the JWS. The following options are available:
    * **Use Cert Alias**: The alias of the selected Certificate.
    * **Compute Cert x5t**: A Base64Url encoded SHA1 digest (thumbprint) of the DER encoded X509 Certificate.
    * **Compute Cert x5t#256**: A Base64Url encoded SHA256 digest (thumbprint) of the DER encoded X509 Certificate.
    * **Selector Expression**: A static string or selector expression can be used to set a custom key ID that has a contextual meaning.

#### Symmetric key type

If you selected the **Symmetric key type** option, complete the following fields in the **Symmetric** section:

* **Shared key**: Enter the shared key used to sign the payload. The key should be given as a base64-encoded byte array and must use the following minimum lengths depending on the selected algorithm used to sign:

  | Algorithm                  | Minimum key length  |
  |----------------------------|---------------------|
  | HMAC using SHA-256 (HS256) | 32 bytes (256 bits) |
  | HMAC using SHA-384 (HS384) | 48 bytes (384 bits) |
  | HMAC using SHA-512 (HS512) | 64 bytes (512 bits) |

* **Selector expression**: Alternatively, enter a selector expression to obtain the shared key. The value returned from the selector should contain:

    * Byte array (possibly produced by a different filter)
    * Base64-encoded byte array

* **Algorithm**: Select the algorithm used to protect the token.

* **Use Key ID (kid)**: Selecting this option will add a `kid` header parameter to the JOSE header part of the token. The `kid` header parameter is a hint indicating which public/private key pair was used to secure the JWS. This value can be defined as a static string or a selector expression.

### Signature JOSE Header

This tab configures which claims are present in the JWT header. The following header options can be enabled or disabled:

* **Generate 'typ' claim**.
* **JWK Set URL (jku)**: A selector can be used to specify the `jku`. If the selector evaluates as empty or null, the filter will fail.
* **Embed all key related claims in the 'jwk' claim (except for 'jku')**: If this is selected, all of the following header claims will be embedded in a JWK object within the header.
* **Generate 'x5t' thumbprint**: SHA1 thumbprint derived from the signing certificate.
* **Generate 'x5t#256' thumbprint**: SHA256 thumbprint derived from the signing certificate.
* **Include 'x5c' certificate chain**: Adds the PEM encoded certificate chain of the signing certificate.
* **Include 'x5u' certificate URL**: A selector can be used to specify the `x5u`. If the selector evaluates as empty or null, the filter will fail.

You can find a detailed explanation for each header at [JWS RFC 7515](https://tools.ietf.org/html/rfc7515#section-4).

Enabling all of the settings will produce a header with the following structure:

```
{
  "jku": "https://axway.com/api/jwk_uri",
  "typ": "JOSE",
  "jwk": {
    "kty": "RSA",
    "x5t#S256": "3WcxVjJWOUxIIgMmLOf20hj-lR2qn-mwXZHIU8D9CAk",
    "e": "AQAB",
    "x5t": "2pdrqe1djoNnHxebh_MfLYl3hFg",
    "kid": "CN=Change this for production",
    "x5c": [
      "MIICwzCCAasCBgE6HBsdpzANBgkqhkiG9w0BAQUFADAlMSMwIQYDVQQDExpDaGFuZ2UgdGhpcyBmb3IgcHJvZHVjdGlvbjAeFw0xMjEwMDExMTMyMDBaFw0zNzEwMDExMTMyMDBaMCUxIzAhBgNVBAMTGkNoYW5nZSB0aGlzIGZvciBwcm9kdWN0aW9uMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm2I2+GHcXXzwyjqMP6E4shjxfpAfgqbCY/nF5oTq0SkcRKvsdJzuLbmufkqx1rQqxwF/aZnbZppcVtR4TAhExmo2NnV7WjSwdd+EynQJrkWlsuK1UQ3JHMo5iAAEQ11xoMBIsUwfg5HYKCELmjnWetwhm5aUJ9Gq45v9kzeZki2oCoVe5LQfVVHEYssr+SfVrhi6+OffeefgCRse6vv5T4zlh4xXKDNUsBxYYB3Vg97tDcdgpfx8BudpBx+1ITk9Dazu8eegXN5KdRqJGgM5LSRIWjK+OumR1a2ReUcXlglWTVfsG43UUUby2bql3E3uc7XpxzQaPpt4aDqfOYMUxwIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQAl+yHca9jCZ/zVgtITGWGKQiNb8UqFJE+QxmLt+j2lEWpG3Fd1M40faRrDujbk8WvG4Iz/NamlvvkbpbMSRY67lPpjsZOKlezTTE2YQTtyuFT7QQTYHYPZWK4Dg8QisMI5vHnrzsPc9ZAHm+IZrxbuVXsZQoU7qyaMdG27WWVa6vJ4nXjuMO6sOtl+UnEXpn3vCpNzkkbJW2LvFCs0Ymnx7Wet3inskOKg//AGuv+m3rD/Byphd8Iblt3jSNDwMcG+Yhpi/Wd50iMFFkTnrkEmosvqWL5j6N7eJZszgdL7Zz9ztASutzU4a0YFpv111NxpBdNpphOVED85IbRHxTjL"
    ],
    "x5u": "https://axway.com/path/to/cert",
    "n": "m2I2-GHcXXzwyjqMP6E4shjxfpAfgqbCY_nF5oTq0SkcRKvsdJzuLbmufkqx1rQqxwF_aZnbZppcVtR4TAhExmo2NnV7WjSwdd-EynQJrkWlsuK1UQ3JHMo5iAAEQ11xoMBIsUwfg5HYKCELmjnWetwhm5aUJ9Gq45v9kzeZki2oCoVe5LQfVVHEYssr-SfVrhi6-OffeefgCRse6vv5T4zlh4xXKDNUsBxYYB3Vg97tDcdgpfx8BudpBx-1ITk9Dazu8eegXN5KdRqJGgM5LSRIWjK-OumR1a2ReUcXlglWTVfsG43UUUby2bql3E3uc7XpxzQaPpt4aDqfOYMUxw"
  }
  "alg": "RS256",
}
```

## JWT Verify filter

You can use the **JWT Verify** filter to verify a signed JSON Web Token (JWT) with the token payload. Upon successful verification, the **JWT Verify** filter removes the headers and signature of the incoming signed JWT and outputs the original JWT payload. For example, when you verify the following signed JWT payload input:

```
eyJhbGciOiJSUzI1NiJ9
.
eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFt
cGxlLmNvbS9pc19yb290Ijp0cnVlfQ
.
cC4hiUPoj9Eetdgtv3hF80EGrhuB__dzERat0XF9g2VtQgr9PJbu3XOiZj5RZmh7
AAuHIm4Bh-0Qc_lF5YKt_O8W2Fp5jujGbds9uJdbF9CUAr7t1dnZcAcQjbKBYNX4
BAynRFdiuB—f_nZLgrnbyTyWzO75vRK5h6xBArLIARNPvkSjtQBMHlb1L07Qe7K
0GarZRmB_eSN9383LcOLn6_dO—xi12jzDwusC-eOkHWEsqtFZESc6BfI7noOPqv
hJ1phCnvWh6IeYI2w9QOYEUipUTI8np6LbgGY9Fs98rqVt5AXLIhWkWywlVmtVrB
p0igcN_IoypGlUPQGe77Rw
```

The resulting payload output is:

```
{"iss":"joe",
"exp":1300819380,
"http://example.com/is_root":true}
```

{{< alert title="Note" color="primary" >}}The **JWT Verify** filter automatically detects whether the input JWT is signed with hash-based message authentication code (HMAC) or asymmetric key and uses the corresponding settings as appropriate. For example, you can configure verification with HMAC or certificate, depending on the type of JWT received as input.{{< /alert >}}

Configure the following settings on the **JWT Verify** dialog:

**Name**:
Enter an appropriate name for the filter to display in a policy.

**Token location**:
Enter the selector expression to retrieve the JWT to be verified. This must contain the value of token in the format of `HEADER.PAYLOAD.SIGNATURE`, but without the `Bearer` prefix. You can use a filter such as **Retrieve attribute from HTTP header** in your policy to get the token from any header. For example: `${http.headers["Authorization"].substring(7)}`

You can configure the following optional settings in the **Verify using RSA/EC public key** section:

**X509 certificate**:
Select the certificate that is used to verify the payload from the certificate store.

{{< alert title="Note" color="primary" >}}Asymmetric keys are associated with the x509 certificate, but for verification, you only need the public key, which is encoded in the certificate. Alternatively, you can use a JSON Web Key (JWK) with a **Connect to URL** filter to download the key from a known source.{{< /alert >}}

**Selector expression**:
Alternatively, enter a selector expression to retrieve the alias of the certificate from the certificate store.

You can configure the following optional settings in the **Verify using symmetric key** section:

**None**:
Select if you do not want to verify tokens signed with HMAC.

**Shared key**:
Enter the shared key that was used to sign the payload. The key should be provided as a base64-encoded byte array.

**Selector expression**:
Alternatively, enter a selector expression to obtain the shared key. The value returned by the selector should contain:

* Byte array (possibly produced by a different filter)
* Base64-encoded byte array

You can configure the following optional setting in the **JWK from external source** section:

**JSON web key**:
You can verify signed tokens using a selector expression containing the value of a `JSON Web Key (JWK)`. The return type of the selector expression must be of type String.

### Additional JWT verification steps

The **JWT Verify** filter verifies the JWT signature with the token payload only. The following additional verification steps are also typically required:

* Make sure that the certificate used to generate the signature is valid (for example, check that it is not blacklisted or expired). You can use the API Gateway CRL and OCSP filters in your policy for this step.
* Validate the JWT token claims. For example, this includes the following checks:
    * `aud`: Audience—check that the token has been created for the correct user.
    * `iss`: Issuer—check that the token was issued by a trusted token provider.
    * `exp`: Expiry time—check that the token has not already expired.

## Sign SMIME message filter

You can use the **SMIME Sign**
filter to digitally sign a multipart Secure/Multipurpose Internet Mail Extensions (SMIME) message when it passes through the API Gateway core pipeline. The recipient of the message can then verify the integrity of the SMIME message by validating the Public Key Cryptography Standards (PKCS) #7 signature.

Complete the following fields:

**Name**:
Enter an appropriate name for the filter to display in a policy.

**Sign Using Key**:
Select the certificate that contains the public key associated with the private signing key to be used to sign the message.

**Create Detached Signature in Attachment**:
Specifies whether to create a detached digital signature in the message attachment. This is selected by default. For example, this is useful when the software reading the message does not understand the PKCS#7 binary structure, because it can still display the signed content, but without verifying the signature.

If this is not selected, the message content is embedded with the PKCS#7 binary signature. This means that user agents that do not understand PKCS#7 cannot display the signed content. Intermediate systems between the sender and final recipient can modify the text content slightly (for example, line wrapping, whitespace, or text encoding). This might cause the message to fail signature validation due to changes in the signed text that are not malicious, nor necessarily affecting the meaning of the text.

## Verify SMIME message filter

You can use the **SMIME Verify**
filter to check the integrity of a Secure/Multipurpose Internet Mail Extensions (SMIME) message. This filter enables you to verify the Public Key Cryptography Standards (PKCS) #7 signature over the message.

You can select the certificates that contain the public keys to be used to verify the signature. Alternatively, you can specify a message attribute that contains the certificate with the public key to be used.

Complete the following fields:

**Name**:
Enter an appropriate name for the filter to display in a policy.

**Certificates from the following list**:
Select the certificates that contain the public keys to be used to verify the signature. This is the default option.

**Certificate in attribute**:
Alternatively, enter the message attribute that specifies the certificate that contains the public key to be used to verify the signature. Defaults to `${certificate}`.

**Remove Outer Envelope if Verification is Successful**:
Select this option to remove the PKCS#7 signature and all its associated data from the message if it verifies successfully.
