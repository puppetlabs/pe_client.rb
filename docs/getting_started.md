# Getting Started

## Creating a Client

### Token Authentication

Below is a minimal example of how to create a client using an API Key generated from the [PE Console](https://help.puppet.com/pe/current/topics/rbac_token_auth_intro.htm).

`ca_file` is required to ensure the client can verify the server's SSL certificate. You can retrieve the CA certificate from the PE Server at: `/etc/puppetlabs/puppetserver/ca/ca_crt.pem`.

```ruby
require "pe_client"

client = PEClient.new(
  api_key:  "YOUR_API_KEY",
  base_url: "https://your-pe-server.example.com",
  ca_file:  "/path/to/ca_crt.pem"
)
```

### Certificate Authentication

When interacting with some API endpoints or with Puppet Core, certificate based authentication may be required.

```ruby
require "pe_client"
require "openssl"

client = PEClient.new(
  api_key: nil,
  base_url: "https://your-pe-server.example.com",
  ca_file:  "/path/to/ca_crt.pem"
) do |conn|
  conn.ssl[:client_cert] = OpenSSL::X509::Certificate.new(File.read("/path/to/client_cert.pem"))
  conn.ssl[:client_key]  = OpenSSL::PKey.read(File.read("/path/to/client_key.pem"))
end
```
