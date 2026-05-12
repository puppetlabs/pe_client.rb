# Activity Service API

[The Activity Service API](https://help.puppet.com/pe/current/topics/activity_api.htm) is useful for:

- Querying PE service and user events logged by the activity service.

Communicates with Puppet Enterprise on port 4433.

## Events endpoints

Use the events endpoints to retrieve activity service events.

## GET /v1/events

[Reference](https://help.puppet.com/pe/current/topics/activity_api_get_events.htm)

Fetch information about events the activity service tracks.

```ruby
client.activity_v1.events(
    service_id: "classifier",
    subject_type: "users",
    subject_id: "kai"
)
# => {
#   "commits" => [
#     {
#       "object" => {
#         "id" => "415dfsvdf-dfgd45dfg-4dsfg54d",
#         "name" => "Default Node Group"
#       },
#       "subject" => {
#         "id" => "dfgdfc145-545dfg54f-fdg45s5s",
#         "name" => "Kai Evans"
#       },
#       "timestamp" => "2014-06-24T04:00:00Z",
#       "events" => [
#         {
#           "message" => "Create Node"
#         },
#         {
#           "message" => "Create Node Class"
#         }
#       ]
#     }
#   ],
#   "total-rows" => 1
# }
```

## GET /v2/events

[Reference](https://help.puppet.com/pe/current/topics/activity-api-v2-get-events.htm)

Fetches information about events the activity service tracks.
Allows filtering through query parameters and supports multiple objects for filtering results.

```ruby
client.activity_v2.events(
    service_id: "classifier",
    query: [
        {object_id: "415", object_type: "node_group"}
    ]
)
# => {
#   "commits" => [
#     {
#       "objects" => [{
#         "id" => "415dfsvdf-dfgd45dfg-4dsfg54d",
#         "name" => "Default Node Group"
#       }],
#       "subject" => {
#         "id" => "dfgdfc145-545dfg54f-fdg45s5s",
#         "name" => "Kai Evans"
#       },
#       "timestamp" => "2014-06-24T04:00:00Z",
#       "events" => [
#         {
#           "message" => "Create Node"
#         },
#         {
#           "message" => "Create Node Class"
#         }
#       ]
#     }
#   ],
#   "pagination" => {"total" => "1", "limit" => "1000", "offset" => "0"}
# }
```
