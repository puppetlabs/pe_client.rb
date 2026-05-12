# Query v4 API

[The PuppetDB Query v4 API](https://help.puppet.com/pdb/current/topics/api_query.htm) can retrieve data objects from PuppetDB for use in other applications.

Communicates with PuppetDB on port 8081.

## /pdb/query/v4

[Reference](https://help.puppet.com/pdb/current/topics/root_endpoint.htm)

The root query endpoint can be used to retrieve any known entities from a single endpoint.

```ruby
# AST Query
client.puppet_db.query_v4.root(query: ["from","nodes",["=","certname","macbook-pro.local"]])
# => [
#   {
#     "catalog_environment" => "production",
#     "catalog_timestamp" => "2015-11-23T19:25:25.561Z",
#     "certname" => "macbook-pro.local",
#     "deactivated" => nil,
#     "expired" => nil,
#     "facts_environment" => "production",
#     "facts_timestamp" => "2015-11-23T19:25:25.079Z",
#     "latest_report_hash" => "0b2aa3bbb1deb71a5328c1d934eadbba5f52d733",
#     "latest_report_status" => "unchanged",
#     "latest_report_noop" => true,
#     "cached_catalog_status" => "not_used",
#     "report_environment" => "production",
#     "report_timestamp" => "2015-11-23T19:25:23.394Z"
#   }
# ]

# PQL Query
client.puppet_db.query_v4.root(query: 'nodes { certname = "macbook-pro.local" }')
# => [
#   {
#     "catalog_environment" => "production",
#     "catalog_timestamp" => "2015-11-23T19:25:25.561Z",
#     "certname" => "macbook-pro.local",
#     "deactivated" => nil,
#     "expired" => nil,
#     "facts_environment" => "production",
#     "facts_timestamp" => "2015-11-23T19:25:25.079Z",
#     "latest_report_hash" => "0b2aa3bbb1deb71a5328c1d934eadbba5f52d733",
#     "latest_report_status" => "unchanged",
#     "latest_report_noop" => true,
#     "cached_catalog_status" => "not_used",
#     "report_environment" => "production",
#     "report_timestamp" => "2015-11-23T19:25:23.394Z"
#   }
# ]
```

## Nodes endpoint

Nodes can be queried by making an HTTP request to the /nodes endpoint.

### /pdb/query/v4/nodes

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodes)

This will return all nodes matching the given query.
Deactivated and expired nodes aren't included in the response.

```ruby
client.puppet_db.query_v4.nodes.get(query: ["=", "certname", "example.local"])
# => [
#   {
#    "certname" => <string>,
#    "deactivated" => <timestamp or nil>,
#    "expired" => <timestamp or nil>,
#    "catalog_timestamp" => <timestamp or nil>,
#    "facts_timestamp" => <timestamp or nil>,
#    "report_timestamp" => <timestamp or nil>,
#    "catalog_environment" => <string or nil>,
#    "facts_environment" => <string or nil>,
#    "report_environment" => <string or nil>,
#    "latest_report_status" => <string>,
#    "latest_report_noop" => <boolean>,
#    "latest_report_noop_pending" => <boolean>,
#    "latest_report_hash" => <string>,
#    "latest_report_job_id" => <string or nil>
#   }
# ]
```

### /pdb/query/v4/nodes/\<NODE>

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnode)

This will return status information for the given node, active or not. It behaves exactly like a call to [/pdb/query/v4/nodes](#pdbqueryv4nodes) with a query string of `["=", "certname", "<NODE>"]`.

```ruby
client.puppet_db.query_v4.nodes.get(node: "mbp.local")
# => {
#     "deactivated" => nil,
#     "facts_environment" => "production",
#     "report_environment" => "production",
#     "catalog_environment" => "production",
#     "facts_timestamp" => "2015-06-19T23:03:42.401Z",
#     "expired" => nil,
#     "report_timestamp" => "2015-06-19T23:03:37.709Z",
#     "certname" => "mbp.local",
#     "catalog_timestamp" => "2015-06-19T23:03:43.007Z",
#     "latest_report_status" => "success",
#     "latest_report_noop" => false,
#     "latest_report_noop_pending" => true,
#     "latest_report_hash" => "2625d1b601e98ed1e281ccd79ca8d16b9f74fea6",
#     "latest_report_job_id" => nil
# }
```

### /pdb/query/v4/nodes/\<NODE>/facts

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnodefacts)

This will return the facts for the given node.
Facts from deactivated and expired nodes aren't included in the response.
This is a shortcut to the [/pdb/query/v4/facts](#pdbqueryv4facts) endpoint.
It behaves the same as a call to [/pdb/query/v4/facts](#pdbqueryv4facts) with a query string of `["=", "certname", "<NODE>"]`.
Facts from deactivated and expired nodes aren't included in the response.

```ruby
client.puppet_db.query_v4.nodes.facts(node: "a.example.com")
# => [
#   {"certname" => "a.example.com", "name" => "operatingsystem", "value" => "Debian"},
#   {"certname" => "a.example.com", "name" => "ipaddress", "value" => "192.168.1.105"},
#   {"certname" => "a.example.com", "name" => "uptime_days", "value" => "26 days"}
# ]
```

### /pdb/query/v4/nodes/\<NODE>/facts/\<NAME>

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnodefactsname)

This will return facts with the given name for the given node.
Facts from deactivated and expired nodes aren't included in the response.
It behaves the same as a call to [/pdb/query/v4/facts](#pdbqueryv4facts) with a query string of

```json
["and",
    ["=", "certname", "<NODE>"],
    ["=", "name", "<NAME>"]]
```

```ruby
client.puppet_db.query_v4.nodes.facts(node: "a.example.com", name: "operatingsystem")
# => [
#   {"certname" => "a.example.com", "name" => "operatingsystem", "value" => "Debian"}
# ]
```

### /pdb/query/v4/nodes/\<NODE>/facts/\<NAME>/\<VALUE>

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnodefactsnamevalue)

This will return facts with the given name and value for the given node.
Facts from deactivated and expired nodes aren't included in the response.
It behaves the same as a call to [/pdb/query/v4/facts](#pdbqueryv4facts) with a query string of

```json
["and",
    ["=", "certname", "<NODE>"],
    ["=", "name", "<NAME>"],
    ["=", "value", "<VALUE>"]]
```

```ruby
client.puppet_db.query_v4.nodes.facts(node: "a.example.com", name: "operatingsystem", value: "Debian")
# => [
#   {"certname" => "a.example.com", "name" => "operatingsystem", "value" => "Debian"}
# ]
```

### /pdb/query/v4/nodes/\<NODE>/resources

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnoderesources)

This will return the resources for the given node.
Resources from deactivated and expired nodes aren't included in the response.
This is a shortcut to the [/pdb/query/v4/resources](#pdbqueryv4resources) endpoint.
It behaves the same as a call to [/pdb/query/v4/resources](#pdbqueryv4resources) with a query string of `["=", "certname", "<NODE>"]`.

```ruby
client.puppet_db.query_v4.nodes.resources(node: "a.example.com")
# => [
#   {
#     "certname" => "the certname of the associated host",
#     "resource" => "the resource's unique hash",
#     "type" => "File",
#     "title" => "/etc/hosts",
#     "exported" => "true",
#     "tags" => ["foo", "bar"],
#     "file" => "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#     "line" => "1",
#     "environment" => "production",
#     "parameters" => {<parameter> => <value>,
#                     <parameter> => <value>,
#                     ...}
#   }
# ]
```

### /pdb/query/v4/nodes/\<NODE>/resources/\<TYPE>

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnoderesourcestype)

This will return the resources of the indicated type for the given node.
Resources from deactivated and expired nodes aren't included in the response.
This is a shortcut to the [/pdb/query/v4/resources](#pdbqueryv4resources) endpoint.
It behaves the same as a call to [/pdb/query/v4/resources](#pdbqueryv4resources) with a query string of

```json
["and",
    ["=", "certname", "<NODE>"],
    ["=", "type", "<TYPE>"]]
```

```ruby
client.puppet_db.query_v4.nodes.resources(node: "a.example.com", type: "File")
# => [
#   {
#     "certname" => "the certname of the associated host",
#     "resource" => "the resource's unique hash",
#     "type" => "File",
#     "title" => "/etc/hosts",
#     "exported" => "true",
#     "tags" => ["foo", "bar"],
#     "file" => "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#     "line" => "1",
#     "environment" => "production",
#     "parameters" => {<parameter> => <value>,
#                     <parameter> => <value>,
#                     ...}
#   }
# ]
```

### /pdb/query/v4/nodes/\<NODE>/resources/\<TYPE>/\<TITLE>

[Reference](https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnoderesourcestypetitle)

This will return the resource of the indicated type and title for the given node.
Resources from deactivated and expired nodes aren't included in the response.
This is a shortcut to the [/pdb/query/v4/resources](#pdbqueryv4resources) endpoint.
It behaves the same as a call to [/pdb/query/v4/resources](#pdbqueryv4resources) with a query string of

```json
["and",
    ["=", "certname", "<NODE>"],
    ["=", "type", "<TYPE>"],
    ["=", "title", "<TITLE>"]]
```

```ruby
client.puppet_db.query_v4.nodes.resources(node: "a.example.com", type: "File", title: "/etc/hosts")
# => [
#   {
#     "certname" => "the certname of the associated host",
#     "resource" => "the resource's unique hash",
#     "type" => "File",
#     "title" => "/etc/hosts",
#     "exported" => "true",
#     "tags" => ["foo", "bar"],
#     "file" => "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#     "line" => "1",
#     "environment" => "production",
#     "parameters" => {<parameter> => <value>,
#                     <parameter> => <value>,
#                     ...}
#   }
# ]
```

## Environments endpoint

Environments are semi-isolated groups of nodes managed by Puppet.
Nodes are assigned to environments by their own configuration, or by the Puppet Server's external node classifier.
When PuppetDB collects info about a node, it keeps track of the environment the node is assigned to.
PuppetDB also keeps a list of environments it has seen.
You can query this list by making an HTTP request to the environments endpoint.

### /pdb/query/v4/environments

[Reference](https://help.puppet.com/pdb/current/topics/environments.htm#pdbqueryv4environments)

This will return all environments known to PuppetDB.

```ruby
client.puppet_db.query_v4.environments
# => {"name": <string>}
```

### /pdb/query/v4/environments/\<ENVIRONMENT>

[Reference](https://help.puppet.com/pdb/current/topics/environments.htm#pdbqueryv4environmentsenvironment)

This will return the name of the environment if it currently exists in PuppetDB.

```ruby
client.puppet_db.query_v4.environments(environment: "production")
# => {"name": "production"}
```

### /pdb/query/v4/environments/\<ENVIRONMENT>/[events|facts|reports|resources]

[Reference](https://help.puppet.com/pdb/current/topics/environments.htm#pdbqueryv4environmentsenvironmenteventsfactsreportsresources)

These routes are identical to issuing a request to /pdb/query/v4/[events|facts|reports|resources], with a query parameter of `["=","environment","<ENVIRONMENT>"]`.
All query parameters and route suffixes from the original routes are supported.
The result format is also the same.

```ruby
client.puppet_db.query_v4.environments(environment: "production", type: "events")
client.puppet_db.query_v4.environments(environment: "production", type: "facts")
client.puppet_db.query_v4.environments(environment: "production", type: "reports")
client.puppet_db.query_v4.environments(environment: "production", type: "resources")
```

## Producers endpoint

Producers are the Puppet Servers that send reports, catalogs, and factsets to PuppetDB.
When PuppetDB stores a report, catalog, or factset, it keeps track of the producer of the report/catalog/factset.
PuppetDB also keeps a list of producers it has seen.
You can query this list by making an HTTP request to the producers endpoint.

### /pdb/query/v4/producers

[Reference](https://help.puppet.com/pdb/current/topics/producers.htm#pdbqueryv4producers)

This will return all producers known to PuppetDB.

```ruby
client.puppet_db.query_v4.producers
# => {"name": <string>}
```

### /pdb/query/v4/producers/\<PRODUCER>

[Reference](https://help.puppet.com/pdb/current/topics/producers.htm#pdbqueryv4producersproducer)

This will return the name of the producer if it currently exists in PuppetDB.

```ruby
client.puppet_db.query_v4.producers(producer: "server.example.com")
# => {"name": "server.example.com"}
```

### /pdb/query/v4/producers/\<PRODUCER>/[catalogs|factsets|reports]

[Reference](https://help.puppet.com/pdb/current/topics/producers.htm#pdbqueryv4producersproducercatalogsfactsetsreports)

These routes are identical to issuing a request to /pdb/query/v4/[catalogs|factsets|reports], with a query parameter of `["=","producer","<PRODUCER>"]`.
All query parameters and route suffixes from the original routes are supported.
The result format is also the same.
Additional query parameters are ANDed with the producer clause.

```ruby
client.puppet_db.query_v4.producers(producer: "server.example.com", type: "catalogs")
client.puppet_db.query_v4.producers(producer: "server.example.com", type: "factsets")
client.puppet_db.query_v4.producers(producer: "server.example.com", type: "reports")
```

## Factsets endpoint

The facts endpoint provides access to a representation of node factsets where a result is returned for each top-level key in the node's structured factset.
Note that the [/pdb/query/v4/inventory](#pdbqueryv4inventory) endpoint will often provide more flexible and efficient access to the same information.

### /pdb/query/v4/factsets

[Reference](https://help.puppet.com/pdb/current/topics/factsets.htm#pdbqueryv4factsets)

This will return all factsets matching the given query.

```ruby
client.puppet_db.query_v4.factsets.get
# => [
#   {
#     "certname" => <node name>,
#     "environment" => <node environment>,
#     "timestamp" => <time of last fact submission>,
#     "producer_timestamp" => <time of command submission from Puppet Server>,
#     "producer" => <Puppet Server certname>
#     "facts" => {
#       "href" => <url>,
#       "data" => [ {
#         "name" => <string>,
#         "value" => <any>
#       } ... ]
#     },
#     "hash" => <sha1 sum of "facts" value>
#   }
# ]
```

### /pdb/query/v4/factsets/\<NODE>

[Reference](https://help.puppet.com/pdb/current/topics/factsets.htm#pdbqueryv4factsetsnode)

This will return the most recent factset for the given node.
Supplying a node this way will restrict any given query to only apply to that node.

```ruby
client.puppet_db.query_v4.factsets.get(node: "kb.local")\
# => {
#   "certname" => "kb.local",
#   "environment" => "production",
#   "facts" => {...},
#   "hash" => "93253d31af6d718cf81f5bc028be2a671f23ed78",
#   "producer" => "foo.local",
#   "producer_timestamp" => "2015-06-04T15:27:56.893Z",
#   "timestamp" => "2015-06-04T15:27:56.979Z"
# }
```

### /pdb/query/v4/factsets/\<NODE>/facts

[Reference](https://help.puppet.com/pdb/current/topics/factsets.htm#pdbqueryv4factsetsnodefacts)

This will return all facts for a particular factset, designated by a node certname.
This is a shortcut to the [/pdb/query/v4/facts](#pdbqueryv4facts) endpoint.
It behaves the same as a call to [/pdb/query/v4/facts](#pdbqueryv4facts) with a query string of `["=", "certname", "<NODE>"]`, except results are returned even if the node is deactivated or expired.

```ruby
client.puppet_db.query_v4.factsets.facts(node: "kb.local")
# => [
#   {
#     "certname" => <node name>,
#     "name" => <fact name>,
#     "value" => <fact value>,
#     "environment" => <facts environment>
#   }
# ]
```

## Facts endpoint

The facts endpoint provides access to a representation of node factsets where a result is returned for each top-level key in the node's structured factset.
Note that the [/pdb/query/v4/inventory](#pdbqueryv4inventory) endpoint will often provide more flexible and efficient access to the same information.

### /pdb/query/v4/facts

[Reference](https://help.puppet.com/pdb/current/topics/facts.htm#pdbqueryv4facts)

This will return all facts matching the given query.
Facts for deactivated nodes are not included in the response.

```ruby
client.puppet_db.query_v4.facts
# => [
#   {
#     "certname" => <node name>,
#     "name" => <fact name>,
#     "value" => <fact value>,
#     "environment" => <facts environment>
#   }
# ]
```

### /pdb/query/v4/facts/\<FACT-NAME>

[Reference](https://help.puppet.com/pdb/current/topics/facts.htm#pdbqueryv4factsfact-name)

This will return all facts with the given fact name, for all nodes.
It behaves exactly like a call to [/pdb/query/v4/facts](#pdbqueryv4facts) with a query string of `["=", "name", "<FACT NAME>"]`.

```ruby
client.puppet_db.query_v4.facts(fact_name: "operatingsystem")
# => [{"certname" => "a.example.com", "name" => "operatingsystem", "value" => "Debian"},
#  {"certname" => "b.example.com", "name" => "operatingsystem", "value" => "Redhat"},
#  {"certname" => "c.example.com", "name" => "operatingsystem", "value" => "Ubuntu"}]
```

### /pdb/query/v4/facts/\<FACT-NAME>/\<VALUE>

[Reference](https://help.puppet.com/pdb/current/topics/facts.htm#pdbqueryv4factsfact-namevalue)

This will return all facts with the given fact name and value, for all nodes.
That is, only the certname field will differ in each result.
It behaves exactly like a call to [/pdb/query/v4/facts](#pdbqueryv4facts) with a query string of:

```ruby
client.puppet_db.query_v4.facts(fact_name: "operatingsystem", value: "Debian")
# => [{"certname" => "a.example.com", "name" => "operatingsystem", "value" => "Debian"},
#  {"certname" => "b.example.com", "name" => "operatingsystem", "value" => "Debian"}]
```

## /pdb/query/v4/fact-names

[Reference](https://help.puppet.com/pdb/current/topics/fact-names.htm)

The fact-names endpoint can be used to retrieve all known fact names.

```ruby
client.puppet_db.query_v4.fact_names
# => ["kernel", "operatingsystem", "osfamily", "uptime"]
```

## /pdb/query/v4/fact-paths

[Reference](https://help.puppet.com/pdb/current/topics/fact-paths.htm)

The fact-paths endpoint retrieves the set of all known fact paths for all known nodes, and is intended as a counterpart to the [/pdb/query/v4/fact-names](#pdbqueryv4fact-names) endpoint, providing increased granularity around structured facts.
The endpoint may be useful for building autocompletion in GUIs or for other applications that require a basic top-level view of fact paths.

```ruby
client.puppet_db.query_v4.fact_paths(query: ["~>", "path", ["partitions", "sda3.*", ".*"]])
# => [ {
#   "path" => [ "partitions", "sda3", "mount" ],
#   "type" => "string"
# }, {
#   "path" => [ "partitions", "sda3", "size" ],
#   "type" => "string"
# }, {
#   "path" => [ "partitions", "sda3", "uuid" ],
#   "type" => "string"
# } ]
```

## /pdb/query/v4/fact-contents

[Reference](https://help.puppet.com/pdb/current/topics/fact-contents.htm)

The fact_contents endpoint provides selective access to factset subtrees via fact paths.
Note that the [/pdb/query/v4/inventory](#pdbqueryv4inventory) endpoint will often provide more flexible and efficient access to the same information.

```ruby
client.puppet_db.query_v4.fact_contents(query: ["=", "path", [ "mountpoints", "/", "options", 0 ]])
# => [ {
#     "certname" => "desktop.localdomain",
#     "environment" => "production",
#     "name" => "mountpoints",
#     "path" => [ "mountpoints", "/", "options", 0 ],
#     "value" => "rw"
# } ]
```

## /pdb/query/v4/inventory

[Reference](https://help.puppet.com/pdb/current/topics/inventory.htm)

The inventory endpoint provides an alternate and potentially more efficient way to access structured facts as compared to the [/pdb/query/v4/facts/\<FACT-NAME>](#pdbqueryv4factsfact-name), [/pdb/query/v4/fact-contents](#pdbqueryv4fact-contents), and [/pdb/query/v4/factsets](#pdbqueryv4factsets) endpoints.

```ruby
client.puppet_db.query_v4.inventory(query: ["=", "facts.operatingsystem", "Darwin"])
# => [ {
#     "certname" => "mbp.local",
#         "timestamp" => "2016-07-11T20:02:33.190Z",
#         "environment" => "production",
#         "facts" => {
#             "kernel" => "Darwin",
#             "operatingsystem" => "Darwin",
#             "memoryfree" => "3.51 GB",
#             "macaddress_p2p0" => "0e:15:c2:d6:f8:4e",
#             "system_uptime" => {
#                 "days" => 0,
#                 "hours" => 1,
#                 "uptime" => "1:52 hours",
#                 "seconds" => 6733
#             },
#             "netmask_lo0" => "255.0.0.0",
#             "sp_physical_memory" => "16 GB",
#             "operatingsystemrelease" => "14.4.0",
#             "macosx_productname" => "Mac OS X",
#             "sp_boot_mode" => "normal_boot",
#             "macaddress_awdl0" => "6e:31:ef:e6:36:54",
#             ...
#         },
#         "trusted" => {
#             "domain" => "local",
#             "certname" => "mbp.local",
#             "hostname" => "mbp",
#             "extensions" => { },
#             "authenticated" => "remote"
#         }
# } ]
```

## Catalogs endpoint

You can query catalogs by making an HTTP request to the catalogs endpoint.

### /pdb/query/v4/catalogs

[Reference](https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogs)

This will return a JSON array containing the most recent catalog for each node or for a given node in your infrastructure.

```ruby
client.puppet_db.query_v4.catalogs.get
# => [ {
#   "certname" => "yo.delivery.puppetlabs.net",
#   "hash" => "62cdc40a78750144b1e1ee06638ac2dd0eeb9a46",
#   "version" => "e4c339f",
#   "transaction_uuid" => "53b72442-3b73-11e3-94a8-1b34ef7fdc95",
#   "code_id" => nil,
#   "producer_timestamp" => "2014-10-13T20:46:00.000Z",
#   "producer" => "dad.puppetlabs.net",
#   "environment" => "production",
#   "edges" => {...},
#   "resources" => {...}
# },
# {
#   "certname" => "foo.delivery.puppetlabs.net",
#   "hash" => "e1a4610ecbb3483fa5e637f42374b2cc46d06474",
#   "version" => "449720",
#   "transaction_uuid" => "9a3c8da6-f48c-4567-b24e-ddae5f80a6c6",
#   "code_id" => nil,
#   "producer_timestamp" => "2014-11-20T02:15:20.861Z",
#   "producer" => "mom.puppetlabs.net",
#   "environment" => "production",
#   "edges" => {...},
#   "resources" => {...}
# } ]
```

### /pdb/query/v4/catalogs/\<NODE>

[Reference](https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogsnode)

This will return the most recent catalog for the given node.
Supplying a node this way will restrict any given query to only apply to that node, but in practice this endpoint is typically used without a query string or URL parameters.

```ruby
client.puppet_db.query_v4.catalogs.get(node: "yo.delivery.puppetlabs.net")
# => {
#  "certname" => "yo.delivery.puppetlabs.net",
#  "hash" => "62cdc40a78750144b1e1ee06638ac2dd0eeb9a46",
#  "version" => "e4c339f",
#  "transaction_uuid" => "53b72442-3b73-11e3-94a8-1b34ef7fdc95",
#  "code_id" => nil,
#  "catalog_uuid" => nil,
#  "producer_timestamp" => "2014-10-13T20:46:00.000Z",
#  "producer" => "dad.puppetlabs.net",
#  "environment" => "production",
#  "edges" => {...},
#  "resources" => {...}
# }
```

### /pdb/query/v4/catalogs/\<NODE>/edges

[Reference](https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogsnodeedges)

This will return all edges for a particular catalog, designated by a node certname.
This is a shortcut to the [/pdb/query/v4/edges](#pdbqueryv4edges) endpoint.
It behaves the same as a call to [/pdb/query/v4/edges](#pdbqueryv4edges) with `query: ["=", "certname", "<NODE>"]`.
Except results are returned even if the node is deactivated or expired.

```ruby
client.puppet_db.query_v4.catalogs.edges(node: "yo.delivery.puppetlabs.net")
# => {
#   "certname" => "yo.delivery.puppetlabs.net",
#   "relationship" => "required-by",
#   "source_title" => "httpd",
#   "source_type" => "Package",
#   "target_title" => "authn_file.load",
#   "target_type" => "File"
# }
```

### /pdb/query/v4/catalogs/\<NODE>/resources

[Reference](https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogsnoderesources)

This will return all resources for a particular catalog, designated by a node certname.
This is a shortcut to the [/pdb/query/v4/resources](#pdbqueryv4resources) endpoint.
It behaves the same as a call to [/pdb/query/v4/resources](#pdbqueryv4resources) with `query: ["=", "certname", "<NODE>"]`.
Except results are returned even if the node is deactivated or expired.

```ruby
client.puppet_db.query_v4.catalogs.resources(node: "yo.delivery.puppetlabs.net")
# => [ {
#   "certname" => "yo.delivery.puppetlabs.net",
#   "resource" => "the resource's unique hash",
#   "type" => "File",
#   "title" => "/etc/hosts",
#   "exported" => "true",
#   "tags" => ["foo", "bar"],
#   "file" => "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#   "line" => "1",
#   "environment" => "production",
#   "parameters" => {<parameter> => <value>,
#                    <parameter> => <value>,
#                    ...}
# } ]
```

## Resources endpoint

You can query resources by making an HTTP request to the resources endpoint.

### /pdb/query/v4/resources

[Reference](https://help.puppet.com/pdb/current/topics/resources.htm#pdbqueryv4resources)

This will return all resources matching the given query.
Resources for deactivated nodes are not included in the response.

```ruby
client.puppet_db.query_v4.resources
# => [ {
#   "certname" => "the certname of the associated host",
#   "resource" => "the resource's unique hash",
#   "type" => "File",
#   "title" => "/etc/hosts",
#   "exported" => "true",
#   "tags" => ["foo", "bar"],
#   "file" => "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#   "line" => "1",
#   "environment" => "production",
#   "parameters" => {<parameter> => <value>,
#                    <parameter> => <value>,
#                    ...}
# } ]
```

### /pdb/query/v4/resources/\<TYPE>

[Reference](https://help.puppet.com/pdb/current/topics/resources.htm#pdbqueryv4resourcestype)

This will return all resources for all nodes with the given type.
Resources from deactivated nodes aren't included in the response.
This behaves exactly like a call to [/pdb/query/v4/resources](#pdbqueryv4resources) with a query string of `["=", "type", "<TYPE>"]`.

```ruby
client.puppet_db.query_v4.resources(type: "User")
# => [
#   {
#     "parameters" => {
#       "uid" => "1000,
#       "shell" => "/bin/bash",
#       "managehome" => false,
#       "gid" => "1000,
#       "home" => "/home/foo,
#       "groups" => "users,
#       "ensure" => "present"
#     },
#     "line" => 10,
#     "file" => "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#     "exported" => false,
#     "environment" => "production",
#     "tags" => [ "foo", "bar" ],
#     "title" => "foo",
#     "type" => "User",
#     "certname" => "host1.mydomain.com"
#   },
#   {
#     "parameters" => {
#       "uid" => "1001,
#       "shell" => "/bin/bash",
#       "managehome" => false,
#       "gid" => "1001,
#       "home" => "/home/bar,
#       "groups" => "users,
#       "ensure" => "present"
#     },
#     "line" => 20,
#     "resource" => "514cc3d67baf20c1c5e053e6a74b249558031311",
#     "file" => "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#     "exported" => false,
#     "environment" => "production",
#     "tags" => [ "foo", "bar" ],
#     "title" => "bar",
#     "type" => "User",
#     "certname" => "host2.mydomain.com"
#   }
# ]
```

### /pdb/query/v4/resources/\<TYPE>/\<TITLE>

[Reference](https://help.puppet.com/pdb/current/topics/resources.htm#pdbqueryv4resourcestypetitle)

This will return all resources for all nodes with the given type and title.
Resources from deactivated nodes aren't included in the response.
This behaves exactly like a call to [/pdb/query/v4/resources](#pdbqueryv4resources) with a query string of:

```json
["and",
    ["=", "type", "<TYPE>"],
    ["=", "title", "<TITLE>"]]
```

```ruby
client.puppet_db.query_v4.resources(type: "User", title: "foo")
# => [
#   {
#     "parameters" : {
#       "uid" : "1000,
#       "shell" : "/bin/bash",
#       "managehome" : false,
#       "gid" : "1000,
#       "home" : "/home/foo,
#       "groups" : "users,
#       "ensure" : "present"
#     },
#     "line" : 10,
#     "resource" : "514cc3d67baf20c1c5e053e6a74b249558031311",
#     "file" : "/etc/puppetlabs/code/environments/production/manifests/site.pp",
#     "exported" : false,
#     "environment": "production",
#     "tags" : [ "foo", "bar" ],
#     "title" : "foo",
#     "type" : "User",
#     "certname" : "host1.mydomain.com"
#   }
# ]
```

## /pdb/query/v4/edges

[Reference](https://help.puppet.com/pdb/current/topics/edges.htm)

Catalog edges are relationships formed between two resources.
They represent the edges inside the catalog graph, whereas resources represent the nodes in the graph.
You can query edges by making a request to the edges endpoint.

```ruby
client.puppet_db.query_v4.edges
# => [
#   {
#     "certname" => "host-5",
#     "relationship" => "required-by",
#     "source_title" => "httpd",
#     "source_type" => "Package",
#     "target_title" => "authn_file.load",
#     "target_type" => "File"
#   }, {
#     "certname" => "host-5",
#     "relationship" => "contains",
#     "source_title" => "/etc/apache2/ports.conf",
#     "source_type" => "Concat",
#     "target_title" => "concat_/etc/apache2/ports.conf",
#     "target_type" => "Exec"
#   }
# ]
```

## Reports endpoint

Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB.
Each report includes:

- Data about the entire run
- Metadata about the report
- Many events, describing what happened during the run

After this information is stored in PuppetDB, it can be queried in various ways.

- You can query data about the run and report metadata by making an HTTP request to the reports endpoint.
- You can query data about individual events by making an HTTP request to the [/pdb/query/v4/events](#pdbqueryv4events) endpoint.
- You can query summaries of event data by making an HTTP request to the [/pdb/query/v4/event-counts](#pdbqueryv4event-counts) or [/pdb/query/v4/aggregate-event-counts](#pdbqueryv4aggregate-event-counts) endpoints.

### /pdb/query/v4/reports

[Reference](https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reports)

Returns all reports.

```ruby
client.puppet_db.query_v4.reports.get
# => [ {
#   "receive_time" => "2015-02-19T16:23:11.034Z",
#   "hash" => "32c821673e647b0650717db467abc51d9949fd9a",
#   "transaction_uuid" => "9a7070e9-840f-446d-b756-6f19bf2e2efc",
#   "puppet_version" => "3.7.4",
#   "noop" => false,
#   "noop_pending"=> true,
#   "report_format" => 4,
#   "start_time" => "2015-02-19T16:23:09.810Z",
#   "end_time" => "2015-02-19T16:23:10.287Z",
#   "producer_timestamp" => "2015-02-19T16:23:11.000Z",
#   "producer" => "server.localdomain",
#   "resource_events" => {
#     "href" => "/pdb/query/v4/reports/32c821673e647b0650717db467abc51d9949fd9a/events",
#     "data" => [ {
#       "new_value" => "hi world",
#       "property" => "message",
#       "name" => "define message",
#       "file" => "/home/wyatt/.puppet/manifests/site.pp",
#       "old_value" => "absent",
#       "line" => 7,
#       "resource_type" => "Notify",
#       "status" => "success",
#       "resource_title" => "hiloo",
#       "timestamp" => "2015-02-19T16:23:10.768Z",
#       "containment_path" => [ "Stage[main]", "Main", "Notify[hiloo]" ],
#       "message" => "defined 'message' as 'hi world'"
#     }, {
#       "new_value" => "hi world",
#       "property" => "message",
#       "name" => "define message",
#       "file" => "/home/wyatt/.puppet/manifests/site.pp",
#       "old_value" => "absent",
#       "line" => 3,
#       "resource_type" => "Notify",
#       "status" => "success",
#       "resource_title" => "hi",
#       "timestamp" => "2015-02-19T16:23:10.767Z",
#       "containment_path" => [ "Stage[main]", "Main", "Notify[hi]" ],
#       "message" => "defined 'message' as 'hi world'"
#     } ]
#   },
#   "status" => "changed",
#   "configuration_version" => "1424362990",
#   "environment" => "production",
#   "certname" => "desktop.localdomain",
#   "metrics" => {
#     "href" => "/pdb/query/v4/reports/32c821673e647b0650717db467abc51d9949fd9a/metrics",
#     "data" => [ {
#       "category" => "resources",
#       "name" => "changed",
#       "value" => 2
#     }, {
#       "category" => "resources",
#       "name" => "failed",
#       "value" => 0
#     },
#     ...
#     {
#       "category" => "events",
#       "name" => "success",
#       "value" => 2
#     }, {
#       "category" => "events",
#       "name" => "total",
#       "value" => 2
#     } ]
#   },
#   "logs" => {
#     "href" => "/pdb/query/v4/reports/32c821673e647b0650717db467abc51d9949fd9a/logs",
#     "data" => [ {
#       "file" => null,
#       "line" => null,
#       "level" => "info",
#       "message" => "Caching catalog for mbp.local",
#       "source" => "//mbp.local/Puppet",
#       "tags" => [ "info" ],
#       "time" => "2015-02-26T16:27:48.416642000-08:00"
#     },
#     ...
#     {
#       "file" => null,
#       "line" => null,
#       "level" => "notice",
#       "message" => "Finished catalog run in 0.01 seconds",
#       "source" => "//mbp.local/Puppet",
#       "tags" => [ "notice" ],
#       "time" => "2015-02-26T16:27:48.483317000-08:00"
#     } ]
#   }
# } ]
```

### /pdb/query/v4/reports/\<HASH>/events

[Reference](https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reportshashevents)

Returns all events for a particular report, designated by its unique hash.
This is a shortcut to the [/pdb/query/v4/events](#pdbqueryv4events) endpoint.
It behaves the same as a call to [/pdb/query/v4/events](#pdbqueryv4events) with a query string of `["=", "report", "<HASH>"]`.

```ruby
client.puppet_db.query_v4.reports.events(hash: "38ff2aef3ffb7800fe85b322280ade2b867c8d27")
# => {
#   "certname" => "foo.localdomain",
#   "old_value" => "absent",
#   "property" => "ensure",
#   "name" => "reporting file",
#   "timestamp" => "2012-10-30T19:01:05.000Z",
#   "resource_type" => "File",
#   "resource_title" => "/tmp/reportingfoo",
#   "new_value" => "file",
#   "message" => "defined content as '{md5}49f68a5c8493ec2c0bf489821c21fc3b'",
#   "report" => "38ff2aef3ffb7800fe85b322280ade2b867c8d27",
#   "status" => "success",
#   "file" => "/home/user/path/to/manifest.pp",
#   "line" => 6,
#   "containment_path" => [ "Stage[main]", "Foo", "File[/tmp/reportingfoo]" ],
#   "containing_class" => "Foo",
#   "corrective_change" => true,
#   "run_start_time" => "2012-10-30T19:00:00.000Z",
#   "run_end_time" => "2012-10-30T19:05:00.000Z",
#   "report_receive_time" => "2012-10-30T19:06:00.000Z"
# }
```

### /pdb/query/v4/reports/\<HASH>/metrics

[Reference](https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reportshashmetrics)

Returns all metrics for a particular report, designated by its unique hash.
This endpoint does not currently support querying or paging.

```ruby
client.puppet_db.query_v4.reports.metrics(hash: "38ff2aef3ffb7800fe85b322280ade2b867c8d27")
# => [
#   {"name" => "changed", "value" => 0, "category" => "resources"},
#   {"name" => "corrective_change", "value" => 0, "category" => "resources"},
#   {"name" => "failed", "value" => 0, "category" => "resources"},
#   {"name" => "failed_to_restart", "value" => 0, "category" => "resources"},
#   {"name" => "out_of_sync", "value" => 0, "category" => "resources"},
#   {"name" => "restarted", "value" => 0, "category" => "resources"},
#   {"name" => "scheduled", "value" => 0, "category" => "resources"},
#   {"name" => "skipped", "value" => 0, "category" => "resources"},
#   {"name" => "total", "value" => 41, "category" => "resources"},
#   {"name" => "catalog_application", "value" => 4.259047022089362, "category" => "time"},
#   {"name" => "config_retrieval", "value" => 7.284232784062624, "category" => "time"},
#   {"name" => "convert_catalog", "value" => 0.25486180698499084, "category" => "time"},
#   {"name" => "cron", "value" => 0.018384165, "category" => "time"},
#   {"name" => "exec", "value" => 0.000994518, "category" => "time"},
#   {"name" => "fact_generation", "value" => 28.260485873091966, "category" => "time"},
#   {"name" => "file", "value" => 0.018063933, "category" => "time"},
#   {"name" => "filebucket", "value" => 0.000257037, "category" => "time"},
#   {"name" => "package", "value" => 0.0035870340000000002, "category" => "time"},
#   {"name" => "pe_anchor", "value" => 0.000289438, "category" => "time"},
#   {"name" => "pe_ini_setting", "value" => 0.002444713, "category" => "time"},
#   {"name" => "plugin_sync", "value" => 2.151832254137844, "category" => "time"},
#   {"name" => "schedule", "value" => 0.001107219, "category" => "time"},
#   {"name" => "service", "value" => 0.231842391, "category" => "time"},
#   {"name" => "total", "value" => 43.260605614, "category" => "time"},
#   {"name" => "transaction_evaluation", "value" => 4.212102255783975, "category" => "time"},
#   {"name" => "total", "value" => 0, "category" => "changes"},
#   {"name" => "failure", "value" => 0, "category" => "events"},
#   {"name" => "success", "value" => 0, "category" => "events"},
#   {"name" => "total", "value" => 0, "category" => "events"}
# ]
```

### /pdb/query/v4/reports/\<HASH>/logs

[Reference](https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reportshashlogs)

Returns all logs for a particular report, designated by its unique hash.
This endpoint does not currently support querying or paging.

```ruby
client.puppet_db.query_v4.reports.logs(hash: "38ff2aef3ffb7800fe85b322280ade2b867c8d27")
# => [
#   {"file" => nil,
#    "line" => nil,
#    "tags" => ["notice"],
#    "time" => "2026-04-28T00:28:10.659+00:00",
#    "level" => "notice",
#    "source" => "Puppet",
#    "message" => "Requesting catalog from puppet.example.com:8140 (10.0.0.254)"},
#   {"file" => nil,
#    "line" => nil,
#    "tags" => ["notice"],
#    "time" => "2026-04-28T00:28:17.750+00:00",
#    "level" => "notice",
#    "source" => "Puppet",
#    "message" => "Catalog compiled by puppet.example.com"},
#   {"file" => nil, "line" => nil, "tags" => ["notice"], "time" => "2026-04-28T00:28:22.824+00:00", "level" => "notice", "source" => "Puppet", "message" => "Applied catalog in 4.26 seconds"}
# ]
```

## /pdb/query/v4/events

[Reference](https://help.puppet.com/pdb/current/topics/events.htm)

Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB.
Each report includes:

- Data about the entire run
- Metadata about the report
- Many events, describing what happened during the run

After this information is stored in PuppetDB, it can be queried in various ways.

- You can query data about the run and report metadata by making an HTTP request to the [/pdb/query/v4/reports](#pdbqueryv4reports) endpoint.
- You can query data about individual events by making an HTTP request to the [/pdb/query/v4/events](#pdbqueryv4events) endpoint.
- You can query summaries of event data by making an HTTP request to the [/pdb/query/v4/event-counts](#pdbqueryv4event-counts) or [/pdb/query/v4/aggregate-event-counts](#pdbqueryv4aggregate-event-counts) endpoints.

```ruby
client.puppet_db.query_v4.events
# => [
#   {
#     "certname" => "foo.localdomain",
#     "old_value" => "absent",
#     "property" => "ensure",
#     "name" => "reporting file",
#     "timestamp" => "2012-10-30T19:01:05.000Z",
#     "resource_type" => "File",
#     "resource_title" => "/tmp/reportingfoo",
#     "new_value" => "file",
#     "message" => "defined content as '{md5}49f68a5c8493ec2c0bf489821c21fc3b'",
#     "report" => "38ff2aef3ffb7800fe85b322280ade2b867c8d27",
#     "status" => "success",
#     "file" => "/home/user/path/to/manifest.pp",
#     "line" => 6,
#     "containment_path" => [ "Stage[main]", "Foo", "File[/tmp/reportingfoo]" ],
#     "containing_class" => "Foo",
#     "corrective_change" => true,
#     "run_start_time" => "2012-10-30T19:00:00.000Z",
#     "run_end_time" => "2012-10-30T19:05:00.000Z",
#     "report_receive_time" => "2012-10-30T19:06:00.000Z"
#   },
#   {
#     "certname" => "foo.localdomain",
#     "old_value" => "absent",
#     "property" => "message",
#     "name" => nil,
#     "timestamp" => "2012-10-30T19:01:05.000Z",
#     "resource_type" => "Notify",
#     "resource_title" => "notify, yo",
#     "new_value" => "notify, yo",
#     "message" => "defined 'message' as 'notify, yo'",
#     "report" => "38ff2aef3ffb7800fe85b322280ade2b867c8d27",
#     "status" => "success",
#     "file" => "/home/user/path/to/manifest.pp",
#     "line" => 10,
#     "containment_path" => [ "Stage[main]", "", "Node[default]", "Notify[notify, yo]" ],
#     "containing_class" => nil,
#     "corrective_change" => true,
#     "run_start_time" => "2012-10-30T19:00:00.000Z",
#     "run_end_time" => "2012-10-30T19:05:00.000Z",
#     "report_receive_time" => "2012-10-30T19:06:00.000Z"
#   }
# ]
```

## /pdb/query/v4/event-counts

[Reference](https://help.puppet.com/pdb/current/topics/event-counts.htm)

The event_counts endpoint is designated as experimental. It may be altered or removed in a future release.
Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB.
Each report includes:

- Data about the entire run
- Metadata about the report
- Many events, describing what happened during the run

After this information is stored in PuppetDB, it can be queried in various ways.

- You can query data about the run and report metadata by making an HTTP request to the [/pdb/query/v4/reports](#pdbqueryv4reports) endpoint.
- You can query data about individual events by making an HTTP request to the [/pdb/query/v4/events](#pdbqueryv4events) endpoint.
- You can query summaries of event data by making an HTTP request to the [/pdb/query/v4/event-counts](#pdbqueryv4event-counts) or [/pdb/query/v4/aggregate-event-counts](#pdbqueryv4aggregate-event-counts) endpoints.

```ruby
client.puppet_db.query_v4.event_counts
# => [
#   {
#     "subject_type" => "certname",
#     "subject" => { "title" => "foo.local" },
#     "failures" => 0,
#     "successes" => 2,
#     "noops" => 0,
#     "skips" => 1
#   },
#   {
#     "subject_type" => "certname",
#     "subject" => { "title" => "bar.local" },
#     "failures" => 1,
#     "successes" => 0,
#     "noops" => 0,
#     "skips" => 1
#   }
# ]
```

## /pdb/query/v4/aggregate-event-counts

The aggregate_event_counts endpoint is designated as experimental. It may be altered or removed in a future release.
Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB.
Each report includes:

- Data about the entire run.
- Metadata about the report.
- Many events, describing what happened during the run.

After this information is stored in PuppetDB, it can be queried in various ways.

- You can query data about the run and report metadata by making an HTTP request to the [/pdb/query/v4/reports](#pdbqueryv4reports) endpoint.
- You can query data about individual events by making an HTTP request to the [/pdb/query/v4/events](#pdbqueryv4events) endpoint.
- You can query summaries of event data by making an HTTP request to the [/pdb/query/v4/event-counts](#pdbqueryv4event-counts) or [/pdb/query/v4/aggregate-event-counts](#pdbqueryv4aggregate-event-counts) endpoints.

```ruby
client.puppet_db.query_v4.aggregate_event_counts(summarize_by: "containing_class", query: ["=", "certname", "foo.local"])
# => [
#   {
#     "summarize_by" => "containing_class",
#     "successes" => 2,
#     "failures" => 0,
#     "noops" => 0,
#     "skips" => 0,
#     "total" => 2
#   }
# ]
```

## Package endpoints

### /pdb/query/v4/packages

[Reference](https://help.puppet.com/pdb/current/topics/packages.htm#pdbqueryv4packages)

Returns all installed packages, across all nodes.
One record is returned for each (package_name, version, provider) combination that exists in your infrastructure.

```ruby
client.puppet_db.query_v4.packages
# => [
#   {
#     "package_name" => <string>,
#     "version" => <string>,
#     "provider" => <string>
#   }
# ]
```

### /pdb/query/v4/package-inventory

[Reference](https://help.puppet.com/pdb/current/topics/packages.htm#pdbqueryv4package-inventory)

Returns all installed packages along with the certname of the nodes they are installed on.

```ruby
client.puppet_db.query_v4.package_inventory
# => [
#   {
#     "certname" => <string>,
#     "package_name" => <string>,
#     "version" => <string>,
#     "provider" => <string>
#   }
# ]
```

### /pdb/query/v4/package-inventory/\<CERTNAME>

[Reference](https://help.puppet.com/pdb/current/topics/packages.htm#pdbqueryv4package-inventorycertname)

This will return all packages installed on the provided certname.
It behaves exactly like a call to [/pdb/query/v4/packages](#pdbqueryv4package-inventory) with a query string of `["=", "certname", <CERTNAME>]`.

```ruby
client.puppet_db.query_v4.package_inventory(certname: "foo.local")
# => [
#   {
#     "certname" => "foo.local",
#     "package_name" => <string>,
#     "version" => <string>,
#     "provider" => <string>
#   }
# ]
```
