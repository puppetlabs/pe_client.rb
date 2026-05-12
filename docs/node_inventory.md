# Node Inventory API

[The Node Inventory API](https://help.puppet.com/pe/current/topics/node_inventory_api.htm) is useful for:

- Making requests to the Puppet inventory service API.
- Creating and deleting connection entries in the inventory service database.
- Listing the connections entries in the inventory database.

Communicates with Puppet Enterprise on port 8143.

## Command Endpoints

### POST /command/create-connection

[Reference](https://help.puppet.com/pe/current/topics/inventory_api_post_command_create-connection.htm)

Create a new connection entry in the node inventory service database.

```ruby
client.node_inventory_v1.create_connections(
    certnames: [
        "sshnode1.example.com",
        "sshnode2.example.com"
    ], 
    type: "ssh", 
    parameters: {
        port: 1234, 
        "connect-timeout": 90, 
        user: "inknowahorse", 
        "run-as": "fred"
    },
    sensitive_parameters: {
        password: "password", 
        "sudo-password": "xtheowl"
    }, 
    duplicates: "replace"
)
# => {
#   "connection_id" => "3c4df64f-7609-4d31-9c2d-acfa52ed66ec"
# }
```

### POST /command/delete-connection

[Reference](https://help.puppet.com/pe/current/topics/inventory_api_post_command_delete-connection.htm)

Remove specified certnames from all associated connection entries in the inventory service database.
In PuppetDB, removed certnames are replaced with preserve: false.

```ruby
client.node_inventory_v1.delete_connections(["mynode5", "mynode6"])
# => {}
```

## Query Endpoints

Use the query endpoints to retrieve lists of inventory service connections.

### POST /query/connections

[Reference](https://help.puppet.com/pe/current/topics/inventory_api_post_query_connections.htm)

List all the connections entries in the inventory database or request information about a specific connection.

```ruby
client.node_inventory_v1.connections(
  certnames: ["averygood.device"],
  sensitive: true,
  extract: ["certnames", "sensitive_parameters"]
)
# => {
#   "items" => [
#     {
#       "connection_id" => "3c4df64f-7609-4d31-9c2d-acfa52ed66ec",
#       "certnames" => ["averygood.device"],
#       "type" => "ssh",
#       "sensitive_parameters" => {
#         "username" => "<USERNAME>",
#         "password" => "<PASSWORD>"
#       }
#     }
#   ]
# }
```
