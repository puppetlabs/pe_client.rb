# Status API

[The Status API](https://help.puppet.com/pe/current/topics/status_api.htm) is useful for:

- Checking the health status of PE services.

It communicates across multiple ports, depending on the service:

| Service | Port |
| --- | --- |
| Console Services | 4433 |
| PuppetDB | 8081 |
| Puppet Server | 8140 |
| Orchestrator | 8143 |
| Advanced Patching | 8146 |

## Services Endpoints

The services endpoints provide machine-consumable information about running services.
They are intended for scripting and integration with other services.

### GET /status/v1/services

[Reference](https://help.puppet.com/pe/current/topics/status_api_get_status_services.htm)

The services endpoints provide machine-consumable information about running services.
They are intended for scripting and integration with other services.

```ruby
# Console Services
client.status_v1.console_services
# => {
#   "activity-service" => {
#     "service_version" => "2019.8.0.0",
#     "service_status_version" => 1,
#     "detail_level" => "info",
#     "state" => "running",
#     "status" => {
#       "db_up" => true,
#       "db_pool" => {
#         "state" => "ready"
#       },
#       "replication" => {
#         "mode" => "none",
#         "status" => "none"
#       }
#     },
#     "active_alerts" => []
#   },
#   "classifier-service" => {
#     "service_version" => "2019.8.0.0",
#     "service_status_version" => 1,
#     "detail_level" => "info",
#     "state" => "running",
#     "status" => {
#       "db_up" => true,
#       "db_pool" => {
#         "state" => "ready"
#       },
#       "rbac_up" => true,
#       "activity_up" => true,
#       "replication" => {
#         "mode" => "none",
#         "status" => "none"
#       }
#     },
#     "active_alerts" => []
#   },
#   "rbac-service" => {
#     "service_version" => "2019.8.0.0",
#     "service_status_version" => 1,
#     "detail_level" => "info",
#     "state" => "running",
#     "status" => {
#       "db_up" => true,
#       "db_pool" => {
#         "state" => "ready"
#       },
#       "activity_up" => true,
#       "replication" => {
#         "mode" => "none",
#         "status" => "none"
#       }
#     },
#     "active_alerts" => []
#   },
#   "status-service" => {
#     "service_version" => "1.1.0",
#     "service_status_version" => 1,
#     "detail_level" => "info",
#     "state" => "running",
#     "status" => {},
#     "active_alerts" => []
#   }
# }

# PuppetDB
client.status_v1.puppetdb_services

# Puppet Server
client.status_v1.puppet_server_services

# Orchestrator
client.status_v1.orchestrator_services
```

### GET /status/v1/services/\<SERVICE NAME>

[Reference](https://help.puppet.com/pe/current/topics/status_api_get_status_services_name.htm)

```ruby
client.status_v1.console_services("rbac-service")
# => {
#   "rbac-service" => 
#     {"service_version" => "1.8.11-SNAPSHOT", 
#      "service_status_version" => 1, 
#      "detail_level" => "info", 
#      "state" => "running", 
#      "status" => {
#                 "activity_up" => true, 
#                 "db_up" => true,
#                 "db_pool" => { "state" => "ready" },
#                 "replication" => { "mode" => "none", "status" => "none" }
#                }, 
#       "active_alerts" => [] 
#     }
# }
```

## Services Plaintext Endpoints

The status service plaintext endpoints are intended for load balancers that don't support JSON parsing or parameter setting.
These endpoints return simple string bodies (either the service's state or a simple error message) and a relevant status code.

### GET /status/v1/simple

[Reference](https://help.puppet.com/pe/current/topics/status_api_get_status_simple.htm)

```ruby
# Console Services
client.status_v1.console_services_simple
# => {}

# PuppetDB
client.status_v1.puppetdb_services_simple

# Puppet Server
client.status_v1.puppet_server_services_simple

# Orchestrator
client.status_v1.orchestrator_services_simple
```

### GET /status/v1/simple/\<SERVICE NAME>

[Reference](https://help.puppet.com/pe/current/topics/status_api_status_simple_name.htm)

```ruby
client.status_v1.console_services_simple("activity-service")
# => {}
```

## Metrics Endpoints

Puppet Server can track advanced metrics to give you additional insight into its performance and health.

### GET /status/v1/services/pe-jruby-metrics

[Reference](https://help.puppet.com/pe/current/topics/status_api_get_status_services_pe-jruby-metrics.htm)

Returns information about the JRuby pools from which Puppet Server fulfills agent requests.

```ruby
client.status_v1.pe_jruby_metrics
# => {
#     "pe-jruby-metrics" => {
#     "detail_level" => "debug",
#     "service_status_version" => 1,
#     "service_version" => "2.2.22",
#     "state" => "running",
#     "status" => {
#         "experimental" => {
#             "jruby-pool-lock-status" => {
#                 "current-state" => ":not-in-use",
#                 "last-change-time" => "2015-12-03T18:59:12.157Z"
#             },
#             "metrics" => {
#                 "average-borrow-time" => 292,
#                 "average-free-jrubies" => 0.4716243097301104,
#                 "average-lock-held-time" => 1451,
#                 "average-lock-wait-time" => 0,
#                 "average-requested-jrubies" => 0.21324752542875958,
#                 "average-wait-time" => 156,
#                 "borrow-count" => 639,
#                 "borrow-retry-count" => 0,
#                 "borrow-timeout-count" => 0,
#                 "borrowed-instances" => [
#                     {
#                         "duration-millis" => 3972,
#                         "reason" => {
#                             "request" => {
#                                 "request-method" => "post",
#                                 "route-id" => "puppet-v3-catalog-/*/",
#                                 "uri" => "/puppet/v3/catalog/hostname.example.com"
#                             }
#                         },
#                         "time" => 1448478371406
#                     }
#                 ],
#                 "num-free-jrubies" => 0,
#                 "num-jrubies" => 1,
#                 "num-pool-locks" => 2849,
#                 "requested-count" => 640,
#                 "requested-instances" => [
#                     {
#                         "duration-millis" => 3663,
#                         "reason" => {
#                             "request" => {
#                                 "request-method" => "put",
#                                 "route-id" => "puppet-v3-report-/*/",
#                                 "uri" => "/puppet/v3/report/hostname.example.com"
#                             }
#                         },
#                         "time" => 1448478371715
#                     }
#                 ],
#                 "return-count" => 638
#             }
#         }
#     }
# }
```

### GET /status/v1/services/pe-master

[Reference](https://help.puppet.com/pe/current/topics/status_api_get_status_services_pe-master.htm)

Returns information about the routes that agents use to connect to the primary server.

```ruby
client.status_v1.pe_master
# => {
#     "service_version" => "2025.9.0.5",
#     "service_status_version" => 1,
#     "detail_level" => "debug",
#     "state" => "running",
#     "status" => {
#         "experimental" => {
#             "http-metrics" => [
#                 {"route-id" => "puppet-v3-catalog-/*/", "count" => 995, "mean" => 7524, "aggregate" => 7486380},
#                 {"route-id" => "puppet-v3-file_metadatas-/*/", "count" => 2985, "mean" => 127, "aggregate" => 379095},
#                 {"route-id" => "total", "count" => 11395, "mean" => 13, "aggregate" => 148135},
#                 {"route-id" => "puppet-v3-report-/*/", "count" => 996, "mean" => 114, "aggregate" => 113544},
#                 {"route-id" => "puppet-v3-file_metadata-/*/", "count" => 1992, "mean" => 44, "aggregate" => 87648},
#                 {"route-id" => "puppet-v3-environments", "count" => 2490, "mean" => 28, "aggregate" => 69720},
#                 {"route-id" => "puppet-v3-file_content-/*/", "count" => 4, "mean" => 1578, "aggregate" => 6312},
#                 {"route-id" => "puppet-v3-environment_classes-/*/", "count" => 1904, "mean" => 3, "aggregate" => 5712},
#                 {"route-id" => "puppet-v3-facts-/*/", "count" => 17, "mean" => 99, "aggregate" => 1683},
#                 {"route-id" => "puppet-v3-environment_modules-/*/", "count" => 12, "mean" => 114, "aggregate" => 1368},
#                 {"route-id" => "puppet-v3-static_file_content-/*/", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-tasks-:module-name-:task-name", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "other", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-tasks", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-compile", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-node-/*/", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-plans-:module-name-:plan-name", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-file_bucket_file-/*/", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v4-catalog", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-plans", "count" => 0, "mean" => 0, "aggregate" => 0},
#                 {"route-id" => "puppet-v3-environment_transports-/*/", "count" => 0, "mean" => 0, "aggregate" => 0}
#             ],
#             "http-client-metrics" => [
#                 {"count" => 6453, "mean" => 52, "aggregate" => 335556, "metric-name" => "puppetlabs.puppet.http-client.experimental.with-metric-id.puppetdb.query.full-response", "metric-id" => ["puppetdb", "query"]},
#                 {"count" => 995, "mean" => 183, "aggregate" => 182085, "metric-name" => "puppetlabs.puppet.http-client.experimental.with-metric-id.puppetdb.command.replace_catalog.full-response", "metric-id" => ["puppetdb", "command", "replace_catalog"]},
#                 {"count" => 1012, "mean" => 105, "aggregate" => 106260, "metric-name" => "puppetlabs.puppet.http-client.experimental.with-metric-id.puppetdb.command.replace_facts.full-response", "metric-id" => ["puppetdb", "command", "replace_facts"]},
#                 {"count" => 995, "mean" => 105, "aggregate" => 104475, "metric-name" => "puppetlabs.puppet.http-client.experimental.with-metric-id.classifier.nodes.full-response", "metric-id" => ["classifier", "nodes"]},
#                 {"count" => 996, "mean" => 94, "aggregate" => 93624, "metric-name" => "puppetlabs.puppet.http-client.experimental.with-metric-id.puppetdb.command.store_report.full-response", "metric-id" => ["puppetdb", "command", "store_report"]}
#             ]
#         }
#     },
#     "active_alerts" => [],
#     "service_name" => "pe-master"
# }
```

### GET /status/v1/services/pe-puppet-profiler

[Reference](https://help.puppet.com/pe/current/topics/status_api_get_status_services_pe-puppet-profiler.htm)

Returns statistics about catalog compilation.
You can use this data to discover which functions or resources are consuming the most resources or are most frequently used.

```ruby
client.status_v1.pe_puppet_profiler
# => {
#     "pe-puppet-profiler": {
#     {...},
#     "status": {
#         "experimental": {
#             "function-metrics": [
#                 {
#                     "aggregate": 1628,
#                     "count": 407,
#                     "function": "include",
#                     "mean": 4
#                 },
#                 {...},
#             "resource-metrics": [
#                 {
#                     "aggregate": 3535,
#                     "count": 5,
#                     "mean": 707,
#                     "resource": "Class[Puppet_enterprise::Profile::Console]"
#                 },
#                 {...},
#             ]
#         }
#     }
# }
```
