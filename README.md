# PEClient Ruby Gem

PEClient is a Ruby client library for interacting with Puppet Enterprise (PE) API endpoints.
It provides convenient access to PE's HTTP APIs.

> [!NOTE]
> This gem may not cover all Puppet API endpoints.
> The specification for this gem focuses on PE 2025.6, Puppet Core 8.16 and newer APIs.
> If you use different versions of PE or Puppet Core, some endpoints may not be available or may behave differently.

## Features

Supported endpoints:

- Node Inventory v1
- Node Classifier v1
- RBAC v1 and v2
- Orchestrator v1
- Code Manager v1
- Status v1
- Activity v1 and v2
- Metrics v1 and v2
- Puppet Admin v1
- Puppet v3
- Puppet CA v1
- PuppetDB
  - Admin v1
  - Metadata v1
  - Query v4

## Installation

Use the latest released gem from GitHub Packages:

```bash
bundle config https://rubygems.pkg.github.com/puppetlabs <USERNAME>:<TOKEN>
```

Then add the released gem to your application's Gemfile:

```ruby
source "https://rubygems.pkg.github.com/puppetlabs" do
  gem "pe_client"
end
```

If bundler is not being used to manage dependencies, install a released version directly:

```bash
gem install pe_client --version "<VERSION>" --source "https://<USERNAME>:<TOKEN>@rubygems.pkg.github.com/puppetlabs/"
```

You can also download the `.gem` artifact from a GitHub Release and install it locally:

```bash
gem install ./pe_client-<VERSION>.gem
```

To install a specific tagged version from GitHub instead of a packaged release, add the gem to the application's Gemfile by executing:

```bash
bundle add pe_client --git https://github.com/puppetlabs/pe_client.rb --tag v<VERSION>
```

If bundler is not being used to manage dependencies and you want a specific tag from GitHub, install the gem by executing:

```bash
gem install specific_install
gem specific_install -l https://github.com/puppetlabs/pe_client.rb -t v<VERSION>
```

## Usage

### Basic Usage with API Key

```ruby
require "pe_client"

client = PEClient.new(
  api_key:  "YOUR_API_KEY",
  base_url: "https://your-pe-server.example.com",
  ca_file:  "/path/to/ca_crt.pem" # Can be retrieved from the PE Server at: /etc/puppetlabs/puppetserver/ca/ca_crt.pem
)

# Access Node Classifier v1 resources
## List Groups
groups = client.node_classifier_v1.groups.get

# Access RBAC v1 resources
## List all users
users = client.rbac_v1.users.get

# Error handling
begin
  users = client.rbac_v1.users.get("Invalid SID")
rescue PEClient::HTTPError => e
  puts "HTTP #{e.response.code} error: #{e.response.body}"
rescue PEClient::Error => e
  puts "General errors: #{e.message}"
end
```

See [Puppet Enterprise API documentation](https://help.puppet.com/pe/current/topics/api_index.htm) for details on available endpoints and data models.

### Client Certificate Authentication

To use client certificate authentication with Faraday, pass a block to configure the SSL settings:

```ruby
require "pe_client"

client = PEClient.new(
  api_key: nil,
  base_url: "https://your-pe-server.example.com",
  ca_file:  "/path/to/ca_crt.pem"
) do |conn|
  conn.ssl[:client_cert] = "/path/to/client_cert.pem"
  conn.ssl[:client_key]  = "/path/to/client_key.pem"
end
```

## Development

After checking out the repo, run:

```bash
bin/setup
```

To run tests:

```bash
bundle exec rake spec
```

To experiment with the code:

```bash
bin/console
```

To install this gem onto your local machine:

```bash
bundle exec rake install
```

## Support

This gem is not covered by Puppet Support.
It is provided as-is for interacting with Puppet APIs.
While bug reports and contributions are welcome, please use this library at your own risk and adapt it as needed for your environment.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/puppetlabs/pe_client.rb](https://github.com/puppetlabs/pe_client.rb).

## License

Apache-2.0 © Perforce Software, Inc.
