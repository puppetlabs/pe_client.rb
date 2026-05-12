# Puppet Admin API

[The Puppet Admin API](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/admin-api/v1/admin-api.htm) is useful for:

- Deleting environment caches created by a primary server.
- Deleting and refreshing the Puppet Server pool of JRuby instances.
- Retrieving JRuby thread dumps for troubleshooting Puppet Server.

Communicates with Puppet Server on port 8140.

## DELETE /puppet-admin-api/v1/environment-cache

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/admin-api/v1/environment-cache.htm)

When using directory environments, Puppet Server caches the data it loads from disk for each environment. This endpoint clears that cache.

```ruby
client.puppet_admin_v1.environment_cache
# => {}

client.puppet_admin_v1.environment_cache(environment: "production")
# => {}
```

## DELETE /puppet-admin-api/v1/jruby-pool

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/admin-api/v1/jruby-pool.htm)

Remove the existing JRuby interpreters from the pool so the JVM can reclaim their memory and Puppet Server can refill the pool with fresh instances.

```ruby
client.puppet_admin_v1.jruby_pool
# => {}
```

## GET /puppet-admin-api/v1/jruby-pool/thread-dump

[Reference](https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/admin-api/v1/jruby-pool.htm)

Retrieve a Ruby thread dump for each JRuby instance registered to the pool.

```ruby
client.puppet_admin_v1.jruby_thread_dump
# => {
#   "pool" => "jruby-pool",
#   "threads" => []
# }
```
