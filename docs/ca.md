# Certificate Authority API

[The Certificate Authority API](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate.htm) is useful for:

- Used internally by Puppet to manage agent certificates.

Communicates with Puppet Server on port 8140.

## GET /puppet-ca/v1/certificate/\<nodename>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate.htm)

Returns the certificate for the specified name, which might be either a standard certname or ca.

```ruby
client.puppet_ca_v1.certificate("elmo.mydomain.com")
# => "-----BEGIN CERTIFICATE-----
# MIIFujCCA6KgAwIBAgIBATANBgkqhkiG9w0BAQsFADBiMWAwXgYDVQQDDFdQdXBw
# ...
# tg1+DuYTn+d54OHi/GZEnvutgrDZyrJDrrb/Czm9
# -----END CERTIFICATE-----"
```

## GET /puppet-ca/v1/expirations

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_expirations.htm)

Returns the "not-after" date for all certificates in the CA bundle, and the "next-update" date of all CRLs in the chain.

```ruby
client.puppet_ca_v1.expirations
# => '"ca-certs":{"Puppet Enterprise CA generated at +2021-08-12 21:46:20 +0000":"2036-08-08T21:47:15UTC","Puppet Root CA: ca0627ba3b3ed9":"2036-08-08T21:47:13UTC"},
# "crls":{"Puppet Enterprise CA generated at +2021-08-12 21:46:20 +0000":"2027-06-16T22:40:32UTC","Puppet Root CA: ca0627ba3b3ed9":"2036-08-08T21:47:13UTC"}'
```

## PUT /puppet-ca/v1/clean

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_clean.htm)

Allows you to revoke and delete a list of certificates with a single request.

```ruby
client.puppet_ca_v1.clean(["agent1.example.net","agent2.example.net"])
# => "Successfully cleaned all certificates."
```

## Certificate Request Endpoints

The certificate request endpoint submits a Certificate Signing Request (CSR) to the primary server.
CSRs that have been submitted can then also be retrieved.
The returned CSR is always in the `.pem` format.

### GET /puppet-ca/v1/certificate_request/\<nodename>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_request.htm#find)

Get a submitted CSR

```ruby
client.puppet_ca_v1.certificate_request.get("agency")
# => "-----BEGIN CERTIFICATE REQUEST-----
# MIIBnzCCAQwCAQAwYzELMAkGA1UEBhMCVUsxDzANBgNVBAgTBkxvbmRvbjEPMA0G
# ...
# ZtUMUBLlh+gGFqOuH69979SJ2QmQC6FNomTkYI7FOHD/TG0=
# -----END CERTIFICATE REQUEST-----"
```

### PUT /puppet-ca/v1/certificate_request/\<nodename>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_request.htm#save)

Submit a CSR

```ruby
client.puppet_ca_v1.certificate_request.submit("agency", "-----BEGIN CERTIFICATE REQUEST-----...-----END CERTIFICATE REQUEST-----")
# => {}
```

### DELETE /puppet-ca/v1/certificate_request/\<nodename>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_request.htm#destroy)

Delete a submitted CSR

```ruby
client.puppet_ca_v1.certificate_request.delete("agency")
# => 1
```

## Certificate Status Endpoints

The certificate status endpoint allows a client to read or alter the status of a certificate or pending certificate request.

### GET /puppet-ca/v1/certificate_status/\<certname>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_status.htm#find)

Retrieve information about the specified certificate.

```ruby
client.puppet_ca_v1.certificate_status.get("mycertname")
# => {
#   "name" => "mycertname",
#   "state" => "signed",
#   "fingerprint" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#   "fingerprints" => {
#     "default" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#     "SHA1" => "77:E6:5A:7E:DD:83:78:DC:F8:51:E3:8B:12:71:F4:57:F1:C2:34:AE",
#     "SHA256" =>"A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#     "SHA512" => "CA:A0:8C:B9:FE:9D:C2:72:18:57:08:E9:4B:11:B7:BC:4E:F7:52:C8:9C:76:03:45:B4:B6:C5:D2:DC:E8:79:43:D7:71:1F:5C:97:FA:B2:F3:ED:AE:19:BD:A9:3B:DB:9F:A5:B4:8D:57:3F:40:34:29:50:AA:AA:0A:93:D8:D7:54"
#   },
#   "dns_alt_names" => ["DNS:puppet","DNS:mycertname"]
# }
```

### GET /puppet-ca/v1/certificate_statuses/\<any_key>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_status.htm#search)

Retrieve information about all known certificates.

```ruby
client.puppet_ca_v1.certificate_status.list(state: "requested")
# => [
#     {
#       "name" => "mycertname1",
#       "state" => "requested",
#       "fingerprint" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#       "fingerprints" => {
#         "default" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#         "SHA1" => "77:E6:5A:7E:DD:83:78:DC:F8:51:E3:8B:12:71:F4:57:F1:C2:34:AE",
#         "SHA256" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#         "SHA512" => "CA:A0:8C:B9:FE:9D:C2:72:18:57:08:E9:4B:11:B7:BC:4E:F7:52:C8:9C:76:03:45:B4:B6:C5:D2:DC:E8:79:43:D7:71:1F:5C:97:FA:B2:F3:ED:AE:19:BD:A9:3B:DB:9F:A5:B4:8D:57:3F:40:34:29:50:AA:AA:0A:93:D8:D7:54"
#       },
#       "dns_alt_names" => []
#     },
#     {
#       "name" => "mycertname2",
#       "state" => "requested",
#       "fingerprint" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#       "fingerprints" => {
#         "default" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#         "SHA1" => "77:E6:5A:7E:DD:83:78:DC:F8:51:E3:8B:12:71:F4:57:F1:C2:34:AE",
#         "SHA256" => "A6:44:08:A6:38:62:88:5B:32:97:20:49:8A:4A:4A:AD:65:C3:3E:A2:4C:30:72:73:02:C5:F3:D4:0E:B7:FC:2F",
#         "SHA512" => "CA:A0:8C:B9:FE:9D:C2:72:18:57:08:E9:4B:11:B7:BC:4E:F7:52:C8:9C:76:03:45:B4:B6:C5:D2:DC:E8:79:43:D7:71:1F:5C:97:FA:B2:F3:ED:AE:19:BD:A9:3B:DB:9F:A5:B4:8D:57:3F:40:34:29:50:AA:AA:0A:93:D8:D7:54"
#       },
#       "dns_alt_names" => []
#     }
# ]
```

### PUT /puppet-ca/v1/certificate_status/\<certname>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_status.htm#save)

Change the status of the specified certificate.

```ruby
# Revoke a certificate
client.puppet_ca_v1.certificate_status.update("mycertname", "revoked")
# => {}

# Sign a certificate
client.puppet_ca_v1.certificate_status.update("mycertname", "signed", cert_ttl: "365d")
# => {}
```

### DELETE /puppet-ca/v1/certificate_status/\<hostname>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_status.htm#delete)

Cause the certificate authority to discard all SSL information regarding a host (including any certificates, certificate requests, and keys).
This does not revoke the certificate if one is present; if you wish to emulate the behavior of puppet cert --clean, you must use [PUT /puppet-ca/v1/certificate_status/\<certname>](#put-puppet-cav1certificate_statuscertname) with `desired_state` of  `"revoked"` before deleting the host’s SSL information.

```ruby
client.puppet_ca_v1.certificate_status.delete("mycertname")
# => "Deleted for mycertname: Puppet::SSL::Certificate, Puppet::SSL::Key"
```

## Certificate Revocation List Endpoints

### GET /puppet-ca/v1/certificate_revocation_list/ca

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_revocation_list.htm#find)

Get the submitted CRL

```ruby
client.puppet_ca_v1.certificate_revocation_list.get
# => "-----BEGIN X509 CRL-----
# MIICdzBhAgEBMA0GCSqGSIb3DQEBBQUAMB8xHTAbBgNVBAMMFFB1cHBldCBDQTog
# ...
# kEwcy38d6hYtUjs=
# -----END X509 CRL-----"
```

### PUT /puppet-ca/v1/certificate_revocation_list/ca

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_revocation_list.htm#UpdateupstreamCRLs)

Update upstream CRLs

```ruby
client.puppet_ca_v1.certificate_revocation_list.update("-----BEGIN X509 CRL-----...-----END X509 CRL-----")
```

## Bulk Certificate Sign Endpoints

Allows you to update a selection or all pending certificate requests to the signed state with a single request.

### POST /puppet-ca/v1/sign

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_sign.htm#POSTpuppetcav1sign)

Allows you to request the signing of CSRs that match the certnames included in the payload.

```ruby
client.puppet_ca_v1.bulk_certificate_sign.sign(["one.example.com", "two.example.com"])
# => {
#   "signed" => [
#     "one.example.com",
#     "two.example.com"
#   ],
#   "no-csr" => [],
#   "signing-errors" => []
# }
```

### POST /puppet-ca/v1/sign/all

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_sign.htm#POSTpuppetcav1signall)

Allows you to request the signing of all outstanding CSRs.

```ruby
client.puppet_ca_v1.bulk_certificate_sign.sign_all
# => {
#   "signed" => [
#     "one.example.com",
#     "two.example.com"
#   ],
#   "no-csr" => [],
#   "signing-errors" => [
#     "badextension.example.com",
#     "invalidsignature.example.com"
#   ]
# }
```
