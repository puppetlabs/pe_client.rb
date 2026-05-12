# Metrics API

[The Metrics API](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/metrics-api/metrics_api_endpoints.htm) is useful for:

- Querying Puppet Server performance and usage metrics.

Communicates with Puppet Server on port 8140.

## v1 Metrics Endpoints

> [!CAUTION]
> DEPRECATED: Use [v2 (Jolokia) Metrics Endpoints](#v2-jolokia-metrics-endpoints) instead.

Puppet Enterprise (PE) includes an optional web endpoint for Java Management Extension (JMX) metrics managed beans (MBeans).

### GET /metrics/v1/mbeans

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/metrics-api/v1/metrics_api.htm#GETmetricsv1mbeans)

Lists available MBeans.

```ruby
client.metrics_v1.mbeans
# => [
#   {
#     "ObjectPendingFinalizationCount" => 0,
#     "HeapMemoryUsage" => {
#       "committed" => 807403520,
#       "init" => 268435456,
#       "max" => 3817865216,
#       "used" => 129257096
#     },
#     "NonHeapMemoryUsage" => {
#       "committed" => 85590016,
#       "init" => 24576000,
#       "max" => 184549376,
#       "used" => 85364904
#     },
#     "Verbose" => false,
#     "ObjectName" => "java.lang:type=Memory"
#   },
#   { ... }
# ]
```

### POST /metrics/v1/mbeans

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/metrics-api/v1/metrics_api.htm#POSTmetricsv1mbeans)

Retrieves requested MBean metrics.

```ruby
client.metrics_v1.get(["java.lang:type=Memory"])
# => [
#   {
#     "ObjectPendingFinalizationCount" => 0,
#     "HeapMemoryUsage" => {
#       "committed" => 807403520,
#       "init" => 268435456,
#       "max" => 3817865216,
#       "used" => 129257096
#     },
#     "NonHeapMemoryUsage" => {
#       "committed" => 85590016,
#       "init" => 24576000,
#       "max" => 184549376,
#       "used" => 85364904
#     },
#     "Verbose" => false,
#     "ObjectName" => "java.lang:type=Memory"
#   }
# ]
```

### GET /metrics/v1/mbeans/\<name>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/metrics-api/v1/metrics_api.htm#GETmetricsv1mbeansname)

Retrieves requested MBean metrics.

```ruby
client.metrics_v1.get("java.lang:type=Memory")
# => {
#   "ObjectPendingFinalizationCount" => 0,
#   "HeapMemoryUsage" => {
#     "committed" => 807403520,
#     "init" => 268435456,
#     "max" => 3817865216,
#     "used" => 129257096
#   },
#   "NonHeapMemoryUsage" => {
#     "committed" => 85590016,
#     "init" => 24576000,
#     "max" => 184549376,
#     "used" => 85364904
#   },
#   "Verbose" => false,
#   "ObjectName" => "java.lang:type=Memory"
# }
```

## v2 (Jolokia) Metrics Endpoints

The Metrics v2 endpoints use the Jolokia library for Java Management Extension (JMX) metrics to query Orchestrator service metrics.

### GET /metrics/v2/list

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/metrics-api/v2/metrics_api.htm)

Get a list of all valid MBeans

```ruby
client.metrics_v2.list
# => {
#   "request" => {
#     "type" => "list"
#   },
#   "value" => {
#     "java.util.logging" => {
#       "type=Logging" => {
#         "op" => {
#           "getLoggerLevel" => {
#             ...
#           },
#           ...
#         },
#         "attr" => {
#           "LoggerNames" => {
#             "rw" => false,
#             "type" => "[Ljava.lang.String;",
#             "desc" => "LoggerNames"
#           },
#           "ObjectName" => {
#             "rw" => false,
#             "type" => "javax.management.ObjectName",
#             "desc" => "ObjectName"
#           }
#         },
#         "desc" => "Information on the management interface of the MBean"
#       }
#     },
#     ...
#   }
# }
```

### GET /metrics/v2/read/\<mbean_names>/\<attributes>

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/metrics-api/v2/metrics_api.htm)

Retrieve orchestrator service metrics data or metadata.

```ruby
client.metrics_v2.read(
    mbean_names: "java.util.logging:type=Logging",
    attributes: "LoggerNames"
)
# => {
#   "request" => {
#     "mbean" => "java.util.logging:type=Logging",
#     "attribute" => "LoggerNames",
#     "type" => "read"
#   },
#   "value" => [
#     "javax.management.snmp",
#     "global",
#     "javax.management.notification",
#     "javax.management.modelmbean",
#     "javax.management.timer",
#     "javax.management",
#     "javax.management.mlet",
#     "javax.management.mbeanserver",
#     "javax.management.snmp.daemon",
#     "javax.management.relation",
#     "javax.management.monitor",
#     "javax.management.misc",
#     ""
#   ],
#   "timestamp" => 1497977258,
#   "status" => 200
# }
```

### POST /metrics/v2/read

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/metrics-api/v2/metrics_api.htm)

Use more complicated queries to retrieve orchestrator service metrics data or metadata.

```ruby
client.metrics_v2.complex_read(
    {
        type: "read",
        mbean: "java.lang:type=Memory",
        attribute: "HeapMemoryUsage",
        path: "used"
    }
)
# => {
#   "request" => {
#     "type" => "read",
#     "mbean" => "java.lang:type=Memory",
#     "attribute" => "HeapMemoryUsage",
#     "path" => "used"
#   },
#   "value" => 1000000,
#   "status" => 200
# }
```

See the [Jolokia protocol documentation](https://jolokia.org/reference/html/manual/jolokia_protocol.html#post-requests)
and [read request documentation](https://jolokia.org/reference/html/manual/protocol/read.html#post-read-request)
for the full POST schema.
