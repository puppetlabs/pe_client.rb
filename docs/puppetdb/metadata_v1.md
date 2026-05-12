# Metadata v1 API

[The PuppetDB Metadata v1 API](https://help.puppet.com/pdb/current/topics/api_metadata.htm) is useful for:

- Retrieving the current PuppetDB server version.
- Retrieving information about the latest PuppetDB release.
- Retrieving the current time from the PuppetDB server.

Communicates with PuppetDB on port 8081.

## GET /pdb/meta/v1/version

[Reference](https://help.puppet.com/pdb/current/topics/version.htm)

Retrieve version information about the running PuppetDB server.

```ruby
client.puppet_db.metadata_v1.version
# => {
#   "version" => "7.12.1"
# }
```

This endpoint does not use any URL parameters or query strings.

## GET /pdb/meta/v1/version/latest

[Reference](https://help.puppet.com/pdb/current/topics/version.htm)

Retrieve information about the latest PuppetDB release known to the server.

```ruby
client.puppet_db.metadata_v1.version(latest: true)
# => {
#   "newer" => false,
#   "product" => "puppetdb",
#   "link" => "https://docs.puppetlabs.com/puppetdb/2.3/release_notes.markdown",
#   "message" => "Version 2.3.4 is now available!",
#   "version" => "2.3.4"
# }
```

## GET /pdb/meta/v1/server-time

[Reference](https://help.puppet.com/pdb/current/topics/server-time.htm)

Retrieve the current time from the PuppetDB server. This is useful when building time-based queries without depending on the local machine clock.

```ruby
client.puppet_db.metadata_v1.server_time
# => {
#   "server_time" => "2026-02-20T15:30:45.123Z"
# }
```

This endpoint does not use any URL parameters or query strings.
