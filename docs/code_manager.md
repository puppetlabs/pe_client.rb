# Code Manager API

[The Code Manager API](https://help.puppet.com/pe/current/topics/code_manager_api.htm) is useful for:

- Creating a webhook to trigger Code Manager.
- Queueing Puppet code deployments.
- Checking Code Manager and file sync status.

Communicates with Puppet Enterprise on port 8170.

## POST /v1/deploys

[Reference](https://help.puppet.com/pe/current/topics/code_mgr_post_deploys.htm)

Trigger Code Manager to deploy code to a specific environment or all environments, or use the dry-run parameter to test your control repo connection.

```ruby
# Don't wait for the deployment to finish
client.code_manager_v1.deploys(
    deploy_all: true,
    wait: false,
)
# => [
#   {
#     "environment" => "production",
#     "id" => 1,
#     "status" => "queued"
#   },
#   {
#     "environment" => "testing",
#     "id" => 2,
#     "status" => "queued"
#   }
# ]

# Wait for the deployment to finish
client.code_manager_v1.deploys(
    environments: ["production"],
    wait: true,
)
# => [
#   {
#     "deploy-signature" => "482f8d3adc76b5197306c5d4c8aa32aa8315694b",
#     "file-sync" => {
#       "environment-commit" => "6939889b679fdb1449545c44f26aa06174d25c21",
#       "code-commit" => "ce5f7158615759151f77391c7b2b8b497aaebce1"},
#     "environment" => "production",
#     "id" => 3,
#     "status" => "complete"
#   }
# ]
```

## POST /v1/webhook

[Reference](https://help.puppet.com/pe/current/topics/code_mgr_post_webhook.htm)

Deploy code by triggering your Code Manager webhook.

```ruby
client.code_manager_v1.webhook(
    type: "github",
    token: "<TOKEN>"
)
# => {}
```

## GET /v1/deploys/status

[Reference](https://help.puppet.com/pe/current/topics/code_mgr_get_deploysstatus.htm)

Get the status of code deployments that Code Manager is currently processing for each environment.
You can specify an id query parameter to get the status of a particular deployment.

```ruby
client.code_manager_v1.status
# => {  
#    "deploys-status" => {
#       "queued" => [ 
#          {  
#             "environment" => "dev",
#             "id" => 3,
#             "queued-at" => "2018-05-15T17:42:34.988Z"
#          }
#       ],
#       "deploying" => [  
#          {  
#             "environment" => "test",
#             "id" => 1,
#             "queued-at" => "2018-05-15T17:42:34.988Z"
#          },
#          {  
#             "environment" => "prod",
#             "id" => 2,
#             "queued-at" => "2018-05-15T17:42:34.988Z"
#          }
#       ],
#       "new" => [  

#       ],
#       "failed" => [  
#          {
#             "environment" => "test14",
#             "error" => {
#                 "details" => {
#                     "corrected-name" => "test14"
#                 },
#                 "kind" => "puppetlabs.code-manager/deploy-failure",
#                 "msg" => "Errors while deploying environment 'test14' (exit code: 1):\nERROR\t -> Authentication failed for Git remote \"https://github.com/puppetlabs/puffppetlabs-apache\".\n"
#             },
#             "queued-at" => "2018-06-01T21:28:18.292Z"
#          }
#      ]
#    },
#    "file-sync-storage-status" => {
#       "deployed" => [
#          {
#             "environment" => "prod",
#             "date" => "2018-05-10T21:44:24.000Z",
#             "deploy-signature" => "66d620604c9465b464a3dac4884f96c43748b2c5"
#          },
#          {
#             "environment" => "test",
#             "date" => "2018-05-10T21:44:25.000Z",
#             "deploy-signature" => "24ecc7bac8a4d727d6a3a2350b6fda53812ee86f"
#          },
#          {
#             "environment" => "dev",
#             "date" => "2018-05-10T21:44:21.000Z",
#             "deploy-signature" => "503a335c99a190501456194d13ff722194e55613"
#          }
#       ]
#    },
#    "file-sync-client-status" => {
#       "all-synced" => false,
#       "file-sync-clients" => {
#          "chihuahua" => {
#             "last_check_in_time" => nil,
#             "synced-with-file-sync-storage" => false,
#             "deployed" => [

#             ]
#          },
#          "localhost" => {
#             "last_check_in_time" => "2018-05-11T22:41:20.270Z",
#             "synced-with-file-sync-storage" => true,
#             "deployed" => [
#                {
#                   "environment" => "prod",
#                   "date" => "2018-05-11T22:40:48.000Z",
#                   "deploy-signature" => "66d620604c9465b464a3dac4884f96c43748b2c5"
#                },
#                {
#                   "environment" => "test",
#                   "date" => "2018-05-11T22:40:48.000Z",
#                   "deploy-signature" => "24ecc7bac8a4d727d6a3a2350b6fda53812ee86f"
#                },
#                {
#                   "environment" => "dev",
#                   "date" => "2018-05-11T22:40:50.000Z",
#                   "deploy-signature" => "503a335c99a190501456194d13ff722194e55613"
#                }
#             ]
#          }
#       }
#    }
# }
```
