# Puppet Server API

[The Puppet Server API](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_api_index.htm) is useful for:

- Retrieving a catalog for a node.
- Accessing environment information.

Communicates with Puppet Server on port 8140.

## v3 Puppet Server Endpoints

### GET /puppet/v3/catalog/\<nodename>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_catalog.htm)

The catalog endpoint returns a catalog for the specified node name given the provided facts.

```ruby
client.puppet_v3.catalog(node_name: "elmo.mydomain.com", environment: "production")
# => {
#   "tags" => [
#     "settings",
#     "multi_param_class",
#     "class"
#   ],
#   "name" => "elmo.mydomain.com",
#   "version" => 1377473054,
#   "code_id" => nil,
#   "catalog_uuid" => "827a74c8-cf98-44da-9ff7-18c5e4bee41e",
#   "catalog_format" => 1,
#   "environment" => "production",
#   "resources" => [
#     {
#       "type" => "Stage",
#       "title" => "main",
#       "tags" => [
#         "stage"
#       ],
#       "exported" => false,
#       "parameters" => {
#         "name" => "main"
#       }
#     },
#     {
#       "type" => "Class",
#       "title" => "Settings",
#       "tags" => [
#         "class",
#         "settings"
#       ],
#       "exported" => false
#     },
#     {
#       "type" => "Class",
#       "title" => "main",
#       "tags" => [
#         "class"
#       ],
#       "exported" => false,
#       "parameters" => {
#         "name" => "main"
#       }
#     },
#     {
#       "type" => "Class",
#       "title" => "Multi_param_class",
#       "tags" => [
#         "class",
#         "multi_param_class"
#       ],
#       "line" => 10,
#       "exported" => false,
#       "parameters" => {
#         "one" => "hello",
#         "two" => "world"
#       }
#     },
#     {
#       "type" => "Notify",
#       "title" => "foo",
#       "tags" => [
#         "notify",
#         "foo",
#         "class",
#         "multi_param_class"
#       ],
#       "line" => 4,
#       "exported" => false,
#       "parameters" => {
#         "message" => "One is hello, two is world"
#       }
#     }
#   ],
#   "edges" => [
#     {
#       "source" => "Stage[main]",
#       "target" => "Class[Settings]"
#     },
#     {
#       "source" => "Stage[main]",
#       "target" => "Class[main]"
#     },
#     {
#       "source" => "Stage[main]",
#       "target" => "Class[Multi_param_class]"
#     },
#     {
#       "source" => "Class[Multi_param_class]",
#       "target" => "Notify[foo]"
#     }
#   ],
#   "classes" => [
#     "settings",
#     "multi_param_class"
#   ]
# }
```

### GET /puppet/v3/node/\<certname>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_node.htm)

The returned information includes the node name and environment, and optionally any classes set by an External Node Classifier and a hash of parameters which may include the node's facts.
The returned node may have a different environment from the one given in the request if Puppet is configured with an ENC.

```ruby
client.puppet_v3.node(
    environment: "production",
    transaction_uuid: "aff261a2-1a34-4647-8c20-ff662ec11c4c",
    configured_environment: "production"
)
# => {
#   "name" => "thinky.corp.puppetlabs.net",
#   "parameters" => {
#     "architecture" => "amd64",
#     "kernel" => "Linux",
#     "blockdevices" => "sda,sr0",
#     "clientversion" => "3.3.1",
#     "clientnoop" => "false",
#     "environment" => "production",
#     ...
#   },
#   "environment" => "production"
# }
```

### PUT /puppet/v3/facts/\<nodename>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_facts.htm)

Allows setting the facts for the specified node name.

```ruby
client.puppet_v3.facts(
    node_name: "elmo.mydomain.com",
    values: {
        architecture: "x86_64",
        kernel: "Darwin",
        domain: "local",
        macaddress: "70:11:24:8c:33:a9",
        osfamily: "Darwin",
        operatingsystem: "Darwin",
        facterversion: "1.7.2",
        fqdn: "elmo.mydomain.com",
    },
    timestamp: "2013-09-09 15:49:27 -0700",
    expiration: "2013-09-09 16:19:27 -0700"
)
# => {}
```

### File bucket file Endpoints

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_file_bucket_file.htm)

Manages the contents of files in the file bucket.
All access to files is managed with the md5 checksum of the file contents, represented as `:md5`.
Where used, `:filename` means the full absolute path of the file on the client system.
This is usually optional and used as an error check to make sure correct file is retrieved.
The environment is required in all requests but ignored, as the file bucket does not distinguish between environments.

#### GET /puppet/v3/file_bucket_file/\<md5>

Retrieve the contents of a file.

```ruby
client.puppet_v3.file_bucket.get(md5: "eb61eead90e3b899c6bcbe27ac581660", environment: "production")
# => "This is the file content"
```

#### GET /puppet/v3/file_bucket_file/\<md5>/\<original_path>

Retrieve the contents of a file.

```ruby
client.puppet_v3.file_bucket.get(md5: "eb61eead90e3b899c6bcbe27ac581660", original_path: "/home/user/myfile.txt", environment: "production")
# => "This is the file content"
```

#### HEAD /puppet/v3/file_bucket_file/\<md5>

Check if a file is present in the filebucket
This behaves identically to [GET /puppet/v3/file_bucket_file/\<md5>](#get-puppetv3file_bucket_filemd5), only returning headers.

```ruby
client.puppet_v3.file_bucket.head(md5: "eb61eead90e3b899c6bcbe27ac581660", environment: "production")
# => {
#   "Content-Length" => 24,
#   ...
# }
```

#### HEAD /puppet/v3/file_bucket_file/\<md5>/\<original_path>

Check if a file is present in the filebucket
This behaves identically to [GET /puppet/v3/file_bucket_file/\<md5>/\<original_path>](#get-puppetv3file_bucket_filemd5original_path), only returning headers.

```ruby
client.puppet_v3.file_bucket.head(md5: "eb61eead90e3b899c6bcbe27ac581660", original_path: "/home/user/myfile.txt", environment: "production")
# => {
#   "Content-Length" => 24,
#   ...
# }
```

#### PUT /puppet/v3/file_bucket_file/\<md5>

Save a file to the filebucket
The body should contain the file contents. This saves the file using the md5 sum of the file contents.
If the md5 sum in the request is incorrect, the file will be instead saved under the correct checksum.

```ruby
client.puppet_v3.file_bucket.put(md5: "eb61eead90e3b899c6bcbe27ac581660", file: "This is the file content", environment: "production")
# => {}
```

#### PUT /puppet/v3/file_bucket_file/\<md5>/\<original_path>

Save a file to the filebucket
The body should contain the file contents. This saves the file using the md5 sum of the file contents.
`:filename` adds the path to a list for the given file.
If the md5 sum in the request is incorrect, the file will be instead saved under the correct checksum.

```ruby
client.puppet_v3.file_bucket.put(md5: "eb61eead90e3b899c6bcbe27ac581660", file: "This is the file content", filename: "/home/user/myfile.txt", environment: "production")
# => {}
```

#### GET /puppet/v3/file_content/\<mount_point>/\<name>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_file_content.htm)

Returns the contents of the specified file.

```ruby
client.puppet_v3.file_content(mount_point: "modules", name: "example/myfile", environment: "env")
# => "this is my file"
```

### File metadata Endpoints

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_file_metadata.htm)

#### GET /puppet/v3/file_metadata/\<mount>/\<path_to_file>

Get file metadata for a single file.

```ruby
client.puppet_v3.file_metadata.find(mount: "modules/example", file_path: "just_a_file.txt", environment: "env")
# => {
#     "checksum" => {
#         "type" => "md5",
#         "value" => "{md5}d0a10f45491acc8743bc5a82b228f89e"
#     },
#     "destination" => nil,
#     "group" => 20,
#     "links" => "manage",
#     "mode" => 420,
#     "owner" => 501,
#     "path" => "/etc/puppetlabs/code/modules/example/files/just_a_file.txt",
#     "relative_path" => nil,
#     "type" => "file"
# }
```

#### GET /puppet/v3/file_metadatas/\<path_to_search>

Get a list of metadata for multiple files.

```ruby
client.puppet_v3.file_metadata.search(file_path: "modules/example", environment: "env", recurse: "yes")
# => [
#     {
#         "checksum" => {
#             "type" => "ctime",
#             "value" => "{ctime}2013-10-01 13:15:59 -0700"
#         },
#         "destination" => nil,
#         "group" => 20,
#         "links" => "manage",
#         "mode" => 493,
#         "owner" => 501,
#         "path" => "/etc/puppetlabs/code/modules/example/files",
#         "relative_path" => ".",
#         "type" => "directory"
#     },
#     {
#         "checksum" => {
#             "type" => "md5",
#             "value" => "{md5}d0a10f45491acc8743bc5a82b228f89e"
#         },
#         "destination" => nil,
#         "group" => 20,
#         "links" => "manage",
#         "mode" => 420,
#         "owner" => 501,
#         "path" => "/etc/puppetlabs/code/modules/example/files",
#         "relative_path" => "just_a_file.txt",
#         "type" => "file"
#     },
#     {
#         "checksum" => {
#             "type" => "md5",
#             "value" => "{md5}d0a10f45491acc8743bc5a82b228f89e"
#         },
#         "destination" => "/etc/puppetlabs/code/modules/example/files/just_a_file.txt",
#         "group" => 20,
#         "links" => "manage",
#         "mode" => 493,
#         "owner" => 501,
#         "path" => "/etc/puppetlabs/code/modules/example/files",
#         "relative_path" => "link_to_file.txt",
#         "type" => "link"
#     },
#     {
#         "checksum" => {
#             "type" => "ctime",
#             "value" => "{ctime}2013-10-01 13:15:59 -0700"
#         },
#         "destination" => nil,
#         "group" => 20,
#         "links" => "manage",
#         "mode" => 493,
#         "owner" => 501,
#         "path" => "/etc/puppetlabs/code/modules/example/files",
#         "relative_path" => "subdirectory",
#         "type" => "directory"
#     },
#     {
#         "checksum" => {
#             "type" => "md5",
#             "value" => "{md5}d41d8cd98f00b204e9800998ecf8427e"
#         },
#         "destination" => nil,
#         "group" => 20,
#         "links" => "manage",
#         "mode" => 420,
#         "owner" => 501,
#         "path" => "/etc/puppetlabs/code/modules/example/files",
#         "relative_path" => "subdirectory/another_file.txt",
#         "type" => "file"
#     }
# ]
```

### PUT /puppet/v3/report/\<nodename>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_report.htm)

```ruby
client.puppet_v3.report(node_name: "kermit.com", environment: "production")
# => {
#  "host" => "kermit.com",
#  "time" => "2013-09-12T03:50:59.009301000+02:00",
#  "configuration_version" => 1357986,
#  "transaction_uuid" => "df34516e-4050-402d-a166-05b03b940749",
#  "code_id" => nil,
#  "job_id" => nil,
#  "catalog_uuid" => "827a74c8-cf98-44da-9ff7-18c5e4bee41e",
#  "catalog_format" => 1,
#  "report_format" => 9,
#  "puppet_version" => "5.0.0",
#  "status" => "unchanged",
#  "transaction_completed" => true,
#  "noop" => false,
#  "noop_pending" => false,
#  "environment" => "test_environment",
#  "logs" =>
#   [{"level" => "warning",
#     "message" => "log message",
#     "source" => "Puppet",
#     "tags" => ["warning"],
#     "time" => "2013-09-12T03:50:59.009328000+02:00",
#     "file" => nil,
#     "line" => nil}],
#  "metrics" =>
#   {"resources" =>
#     {"name" => "resources",
#      "label" => "Resources",
#      "values" =>
#       [["total", "Total", 1],
#        ["skipped", "Skipped", 0],
#        ["failed", "Failed", 0],
#        ["failed_to_restart", "Failed to restart", 0],
#        ["restarted", "Restarted", 0],
#        ["changed", "Changed", 1],
#        ["out_of_sync", "Out of sync", 0],
#        ["scheduled", "Scheduled", 0]]},
#    "time" =>
#     {"name" => "time",
#      "label" => "Time",
#      "values" => [["timing", "Timing", 4], ["total", "Total", 4]]},
#    "changes" =>
#     {"name" => "changes", "label" => "Changes", "values" => [["total", "Total", 0]]},
#    "events" =>
#     {"name" => "events",
#      "label" => "Events",
#      "values" =>
#       [["total", "Total", 0],
#        ["failure", "Failure", 0],
#        ["success", "Success", 0]]}},
#  "resource_statuses" =>
#   {"Notify[a resource]" =>
#     {"title" => "a resource",
#      "file" => nil,
#      "line" => nil,
#      "resource" => "Notify[a resource]",
#      "resource_type" => "Notify",
#      "provider_used" => nil,
#      "containment_path" => ["Notify[a resource]"],
#      "evaluation_time" => nil,
#      "tags" => ["notify"],
#      "time" => "2013-09-12T03:50:59.009238000+02:00",
#      "failed" => false,
#      "changed" => true,
#      "out_of_sync" => false,
#      "skipped" => false,
#      "change_count" => 0,
#      "out_of_sync_count" => 0,
#      "events" => []}},
#   "cached_catalog_status" => "not_used"
# }
```

### GET /puppet/v3/environment_classes

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/environment_classes.htm)

The environment classes API serves as a replacement for the Puppet resource type API for classes, which was removed in Puppet.

```ruby
client.puppet_v3.environment_classes(environment: "env")
# => {
#   "files" => [
#     {
#       "path" => "/etc/puppetlabs/code/environments/env/manifests/site.pp",
#       "classes" => []
#     },
#     {
#       "path" => "/etc/puppetlabs/code/environments/env/modules/mymodule/manifests/init.pp",
#       "classes" => [
#         {
#           "name" => "mymodule",
#           "params" => [
#             {
#               "default_literal" => "this is a string",
#               "default_source" => "\"this is a string\"",
#               "name" => "a_string",
#               "type" => "String"
#             },
#             {
#               "default_literal" => 3,
#               "default_source" => "3",
#               "name" => "an_integer",
#               "type" => "Integer"
#             }
#           ]
#         }
#       ]
#     },
#     {
#       "error" => "Syntax error at '=>' at /etc/puppetlabs/code/environments/env/modules/mymodule/manifests/other.pp:20:19",
#       "path" => "/etc/puppetlabs/code/environments/env/modules/mymodule/manifests/other.pp"
#     }
#   ],
#   "name" => "env"
# }
```

### GET /puppet/v3/environment_modules

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/environment_modules.htm)

The environment modules API returns information about what modules are installed for the requested environment.

```ruby
client.puppet_v3.environment_modules
# => [{
#     "modules" => [
#         {
#             "name" => "puppetlabs/ntp",
#             "version" => "6.0.0"
#         },
#         {
#             "name" => "puppetlabs/stdlib",
#             "version" => "4.14.0"
#         }
#     ],
#     "name" => "env"
# },
# {
#     "modules" => [
#         {
#             "name" => "puppetlabs/stdlib",
#             "version" => "4.14.0"
#         },
#         {
#             "name" => "puppetlabs/azure",
#             "version" => "1.1.0"
#         }
#     ],
#     "name" => "production"
# }]

client.puppet_v3.environment_modules(environment: "env")
# => {
#     "modules" => [
#         {
#             "name" => "puppetlabs/ntp",
#             "version" => "6.0.0"
#         },
#         {
#             "name" => "puppetlabs/stdlib",
#             "version" => "4.14.0"
#         }
#     ],
#     "name" => "env"
# }
```

### GET /puppet/v3/static_file_content/\<FILE-PATH>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/static_file_content.htm)

The static_file_content endpoint returns the standard output of a `code-content-command` script, which should output the contents of a specific version of a `file resource` that has a source attribute with a `puppet:///` URI value.
That source must be a file from the files or tasks directory of a module in a specific environment.

```ruby
client.puppet_v3.static_file_content(
    file_path: "modules/example/files/data.txt",
    code_id: "urn:puppet:code-id:1:67eb71417fbd736a619c8b5f9bfc0056ea8c53ca",
    environment: "production"
)
# => "Puppet test"
```
