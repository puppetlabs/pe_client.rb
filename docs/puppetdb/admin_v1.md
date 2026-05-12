# Admin v1 API

[The PuppetDB Admin v1 API](https://help.puppet.com/pdb/current/topics/api_admin.htm) is useful for:

- Importing PuppetDB archives.
- Exporting PuppetDB archives.
- Triggering PuppetDB maintenance operations.
- Deleting all PuppetDB data for a node.
- Collecting PostgreSQL usage statistics for support and diagnostics.

Communicates with PuppetDB on port 8081.

## POST /pdb/admin/v1/cmd

[Reference](https://help.puppet.com/pdb/current/topics/cmd.htm)

Trigger synchronous PuppetDB admin commands. The client passes the `payload` through to PuppetDB unchanged, so the request body can match the command format documented by Puppet.

### Clean v1

Run one or more PuppetDB maintenance operations. An empty payload requests all maintenance operations.

```ruby
client.puppet_db.admin_v1.cmd(
  command: "clean",
  version: 1,
  payload: ["expire_nodes", "purge_nodes", "purge_reports", "gc_packages", "other"]
)
# => {
#   "ok" => true
# }
```

If another maintenance operation is already in progress, PuppetDB returns HTTP 409 and the client raises `PEClient::ConflictError`.

### Delete v1

Delete all PuppetDB data associated with a certname.

```ruby
client.puppet_db.admin_v1.cmd(
  command: "delete",
  version: 1,
  payload: {certname: "node-1.example.com"}
)
# => {
#   "deleted" => "node-1.example.com"
# }
```

If the command name or payload is invalid, PuppetDB returns HTTP 400 and the client raises `PEClient::BadRequestError`.

## GET /pdb/admin/v1/summary-stats

[Reference](https://help.puppet.com/pdb/current/topics/summary-stats.htm)

Generate diagnostic information about how PuppetDB is using PostgreSQL. This endpoint is experimental and may take several minutes to complete.

```ruby
client.puppet_db.admin_v1.summary_stats
# => {
#   "table_usage" => [
#     {
#       "relname" => "catalogs",
#       "seq_scan" => 12,
#       "idx_scan" => 482
#     }
#   ],
#   "index_usage" => [
#     {
#       "relname" => "catalogs_pkey",
#       "idx_scan" => 482
#     }
#   ],
#   "database_usage" => {
#     "datname" => "puppetdb"
#   },
#   "node_activity" => {
#     "active" => 123,
#     "inactive" => 4
#   },
#   ...
# }
```

## POST /pdb/admin/v1/archive

[Reference](https://help.puppet.com/pdb/current/topics/archive.htm#post-pdbadminv1archive)

Import a PuppetDB archive from a local tar.gz file. The client builds the multipart request for you.

```ruby
client.puppet_db.admin_v1.archive.import(
  archive: "/tmp/puppetdb-export.tgz"
)
# => {
#   "ok" => true
# }
```

The archive must include `puppetdb-bak/metadata.json` as the first entry in the tarball, with a `command_versions` map as documented by PuppetDB.

## GET /pdb/admin/v1/archive

[Reference](https://help.puppet.com/pdb/current/topics/archive.htm#get-pdbadminv1archive)

Export a tarred, gzipped PuppetDB archive to a local file. The response body is streamed directly to disk, and the method returns the output path.

```ruby
client.puppet_db.admin_v1.archive.export(
  path: "/tmp/puppetdb-export.tgz"
)
# => "/tmp/puppetdb-export.tgz"

client.puppet_db.admin_v1.archive.export(
  path: "/tmp/puppetdb-export-anonymized.tgz",
  anonymization_profile: "moderate"
)
# => "/tmp/puppetdb-export-anonymized.tgz"
```

Use `anonymization_profile` to request an anonymized export when supported by your PuppetDB installation.
