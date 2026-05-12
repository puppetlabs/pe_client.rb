# PuppetDB API

[The PuppetDB API](https://help.puppet.com/pdb/current/topics/api.htm) is useful for:

- Querying the data that PuppetDB collects from Puppet.
- Importing and exporting PuppetDB archives.
- Changing the PuppetDB model of a population.
- Querying information about the PuppetDB server.
- Querying PuppetDB metrics.

Communicates with PuppetDB on port 8081.

## GET /pdb/ext/v1/state-overview

[Reference](https://help.puppet.com/pdb/current/topics/state-overview.htm)

The state overview endpoint returns counts of nodes based on the status of their last report, or whether nodes are unresponsive or have not reported.

```ruby
client.puppet_db.state_overview(unresponsive_threshold: 3600)
# => {
#   "events" => {"failure" => 1, "success" => 10},
#   "resources" => {"failed" => 1, "changed" => 2, "unchanged" => 8},
#   "nodes" => {"unresponsive" => 0, "no_report" => 1}
# }
```

## GET /status/v1/services/puppetdb-status

[Reference](https://help.puppet.com/pdb/current/topics/status.htm)

The status endpoint implements the Puppet Status API for monitoring PuppetDB.

```ruby
client.puppet_db.status
# => {
#   "puppetdb-status" => {
#     "state" => "running",
#     "status" => {}
#   }
# }
```

## Query v4 API

[API Documentation](puppetdb/query_v4.md)

## Admin v1 API

[API Documentation](puppetdb/admin_v1.md)

## Metadata v1 API

[API Documentation](puppetdb/metadata_v1.md)
