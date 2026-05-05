# Node Classifier Service API

[The Node Classifier Service API](https://help.puppet.com/pe/current/topics/node_classifier_service_api.htm) is useful for:

- Querying the groups that a node matches.
- Querying the classes, parameters, and variables that have been assigned to a node or group.
- Querying the environment that a node is in.

Communicates with Puppet Enterprise on port 4433.

## Groups Endpoints

The groups endpoints create, read, update, and delete groups.

### GET /v1/groups

[Reference](https://help.puppet.com/pe/current/topics/get_v1_groups.htm)

Retrieves groups.

```ruby
client.node_classifier_v1.groups.get
# => [
#     {
#         "environment_trumps" => false,
#         "parent" => "00000000-0000-4000-8000-000000000000",
#         "name" => "My Nodes",
#         "variables" => {},
#         "id" => "085e2797-32f3-4920-9412-8e9decf4ef65",
#         "environment" => "production",
#         "classes" => {}
#     }
# ]
```

### POST /v1/groups

[Reference](https://help.puppet.com/pe/current/topics/post_v1_groups.htm)

Create a node group with a randomly-generated ID.

```ruby
client.node_classifier_v1.groups.create(
    name: "My Nodes",
    parent: "00000000-0000-4000-8000-000000000000",
    environment: "production",
    classes: {}
)
# => {}
```

### GET /v1/groups/\<id>

[Reference](https://help.puppet.com/pe/current/topics/get_v1_groups_id.htm)

Retrieves a specific group.

```ruby
client.node_classifier_v1.groups.get("085e2797-32f3-4920-9412-8e9decf4ef65")
# => {
#    "environment_trumps" => false,
#    "parent" => "00000000-0000-4000-8000-000000000000",
#    "name" => "My Nodes",
#    "variables" => {},
#    "id" => "085e2797-32f3-4920-9412-8e9decf4ef65",
#    "environment" => "production",
#    "classes" => {}
# }
```

### PUT /v1/groups/\<id>

[Reference](https://help.puppet.com/pe/current/topics/put_v1_groups_id.htm)

Create a node group with a specific ID.

```ruby
client.node_classifier_v1.groups.create(
    id: "085e2797-32f3-4920-9412-8e9decf4ef65",
    name: "My Nodes",
    parent: "00000000-0000-4000-8000-000000000000",
    environment: "production",
    classes: {}
)
# => {}
```

### POST /v1/groups/\<id>

[Reference](https://help.puppet.com/pe/current/topics/post_v1_groups_id.htm)

Edit the name, environment, parent node group, rules, classes, class parameters, configuration data, and variables for a specific node group.

```ruby
client.node_classifier_v1.groups.update(
    "085e2797-32f3-4920-9412-8e9decf4ef65",
    {
        name: "New Name"
    }
)
# => {}
```

### DELETE /v1/groups/\<id>

[Reference](https://help.puppet.com/pe/current/topics/delete_v1_groups_id.htm)

Delete the node group with the given ID.

```ruby
client.node_classifier_v1.groups.delete("085e2797-32f3-4920-9412-8e9decf4ef65")
# => {}
```

### POST /v1/groups/\<id>/pin

[Reference](https://help.puppet.com/pe/current/topics/post_v1_groups_id_pin.htm)

Pin specific nodes to a node group.

```ruby
client.node_classifier_v1.groups.pin(
    "085e2797-32f3-4920-9412-8e9decf4ef65",
    ["node1.example.com", "node2.example.com"]
)
# => {}
```

### POST /v1/groups/\<id>/unpin

[Reference](https://help.puppet.com/pe/current/topics/post_v1_groups_id_unpin.htm)

Unpin specific nodes from a node group.

```ruby
client.node_classifier_v1.groups.unpin(
    "085e2797-32f3-4920-9412-8e9decf4ef65",
    ["node1.example.com", "node2.example.com"]
)
# => {}
```

### GET /v1/groups/\<id>/rules

[Reference](https://help.puppet.com/pe/current/topics/get-v1-groups-id-rules.htm)

Resolve the rules for a specific node group, and then translate those rules to work with the PuppetDB nodes and inventory endpoints.

```ruby
client.node_classifier_v1.groups.rules("085e2797-32f3-4920-9412-8e9decf4ef65")
# => {
#   "rule" => [
#     "=",
#     [
#       "fact",
#       "is_spaceship"
#     ],
#     "true"
#   ],
#   "rule_with_inherited" => [
#     "and",
#     [
#       "=",
#       [
#         "fact",
#         "is_spaceship"
#       ],
#       "true"
#     ],
#     [
#       "~",
#       "name",
#       ".*"
#     ]
#   ],
#   "translated" => {
#     "nodes_query_format" => [
#       "or",
#       [
#         "=",
#         [
#           "fact",
#           "is_spaceship"
#         ],
#         "true"
#       ],
#       [
#         "=",
#         [
#           "fact",
#           "is_spaceship",
#           true
#         ]
#       ]
#     ],
#     "inventory_query_format" => [
#       "or",
#       [
#         "=",
#         "facts.is_spaceship",
#         "true"
#       ],
#       [
#         "=",
#         "facts.is_spaceship",
#         true
#       ]
#     ]
#   }
# }
```

### GET /v1/groups/\<id>/nodes

[Reference](https://help.puppet.com/pe/current/topics/get-v1-groups-id-nodes.htm)

Resolve all the nodes associated with a node group.
This endpoint combines all the rules for the group and queries PuppetDB for the result.

```ruby
client.node_classifier_v1.groups.nodes("085e2797-32f3-4920-9412-8e9decf4ef65")
# => {"nodes": ["foo", "bar", "baz"]}
```

## Classes Endpoint

Use the classes endpoint to retrieve a list of all classes.

### GET /v1/classes

[Reference](https://help.puppet.com/pe/current/topics/get_v1_classes.htm)

Retrieve a list of all classes the node classifier knows about at the time of the request.

```ruby
client.node_classifier_v1.classes.get
# => [
#     {
#         "name": "apache",
#         "environment": "production",
#         "parameters": {
#             "default_mods": true,
#             "default_vhost": true
#         }
#     }
# ]
```

## Classification Endpoints

The classification endpoints accepts a node name and a set of facts, and then return information about how the specified node is classified.
The output can help you test your node group classification rules.

### POST /v1/classified/nodes/\<name>

[Reference](https://help.puppet.com/pe/current/topics/post_v1_classified_nodes_name.htm)

Retrieve a specific node's classification information based on facts supplied in the body of your request.

```ruby
client.node_classifier_v1.classification.get(
    "node1.example.com",
    fact: {
        is_spaceship: "true"
    },
    trusted: {
        pp_role: "spaceship"
    }
)
# => {
#   "name" => "foo.example.com",
#   "groups" => ["9c0c7d07-a199-48b7-9999-3cdf7654e0bf", "96d1a058-225d-48e2-a1a8-80819d31751d"],
#   "environment" => "staging",
#   "parameters" => {},
#   "classes" => {
#     "apache" => {
#       "keepalive_timeout" => 30,
#       "log_level" => "notice"
#     }
#   }
# }
```

### POST /v1/classified/nodes/\<name>/explanation

[Reference](https://help.puppet.com/pe/current/topics/post_v1_classified_nodes_name_explanation.htm)

Retrieve a detailed explanation about how a node is classified based on facts supplied in the body of your request.

```ruby
client.node_classifier_v1.classification.explanation(
    "node1.example.com",
    fact: {
        spunk: "0"
    },
    trusted: {
        pp_role: "staff"
    }
)
# => {
#   "node_as_received" => {
#     "name" => "Tuvok",
#     "trusted" => {
#       "pp_role" => "staff"
#     },
#     "fact" => {
#       "ear-tips" => "pointed",
#       "eyebrow pitch" => "30",
#       "blood oxygen transporter" => "hemocyanin",
#       "anterior tricuspids" => "2",
#       "hair" => "dark",
#       "resting bpm" => "200",
#       "appendices" => "0",
#       "spunk" => "0"
#     }
#   },
#   "match_explanations" => {
#     "00000000-0000-4000-8000-000000000000" => {
#       "value" => true,
#       "form" => ["~", {"path" => "name", "value" => "Tuvok"}, ".*"]
#     },
#     "8aeeb640-8dca-4b99-9c40-3b75de6579c2" => {
#       "value" => true,
#       "form" => ["and",
#                {
#                  "value" => true,
#                  "form" => [">=", {"path" => ["fact", "eyebrow pitch"], "value" => "30"}, "25"]
#                },
#                {
#                  "value" => true,
#                  "form" => ["=", {"path" => ["fact", "ear-tips"], "value" => "pointed"}, "pointed"]
#                },
#                {
#                  "value" => true,
#                  "form" => ["=", {"path" => ["fact", "hair"], "value" => "dark"}, "dark"]
#                },
#                {
#                  "value" => true,
#                  "form" => [">=", {"path" => ["fact", "resting bpm"], "value" => "200"}, "100"]
#                },
#                {
#                  "value" => true,
#                  "form" => ["=",
#                           {
#                             "path" => ["fact", "blood oxygen transporter"],
#                             "value" => "hemocyanin"
#                           },
#                           "hemocyanin"
#                  ]
#                }
#       ]
#     }
#   },
#   "leaf_groups" => {
#     "8aeeb640-8dca-4b99-9c40-3b75de6579c2" => {
#       "name" => "Vulcans",
#       "id" => "8aeeb640-8dca-4b99-9c40-3b75de6579c2",
#       "parent" => "00000000-0000-4000-8000-000000000000",
#       "rule" => ["and", [">=", ["fact", "eyebrow pitch"], "25"],
#                       ["=", ["fact", "ear-tips"], "pointed"],
#                       ["=", ["fact", "hair"], "dark"],
#                       [">=", ["fact", "resting bpm"], "100"],
#                       ["=", ["fact", "blood oxygen transporter"], "hemocyanin"]
#       ],
#       "environment" => "alpha-quadrant",
#       "variables" => {},
#       "classes" => {
#         "emotion" => {"importance" => "ignored"},
#         "logic" => {"importance" => "primary"}
#       },
#       "config_data" => {
#         "USS::Voyager" => {"designation" => "subsequent"}
#       }
#     }
#   },
#   "inherited_classifications" => {
#     "8aeeb640-8dca-4b99-9c40-3b75de6579c2" => {
#       "environment" => "alpha-quadrant",
#       "variables" => {},
#       "classes" => {
#         "logic" => {"importance" => "primary"},
#         "emotion" => {"importance" => "ignored"}
#       },
#       "config_data" => {
#         "USS::Enterprise" => {"designation" => "original"},
#         "USS::Voyager" => {"designation" => "subsequent"}
#       }
#     }
#   },
#   "individual_classification" => {
#     "classes" => {
#       "emotion" => {
#         "importance" => "secondary"
#       }
#     },
#     "variables" => {
#       "full_name" => "S'chn T'gai Spock"
#     }
#   },
#   "final_classification" => {
#     "environment" => "alpha-quadrant",
#     "variables" => {
#       "full_name" => "S'chn T'gai Spock"
#     },
#     "classes" => {
#       "logic" => {"importance" => "primary"},
#       "emotion" => {"importance" => "secondary"}
#     },
#     "config_data" => {
#       "USS::Enterprise" => {"designation" => "original"},
#       "USS::Voyager" => {"designation" => "subsequent"}
#     }
#   },
#   "classification_sources" => {
#     "environment" => {
#       "value" => "alpha-quadrant",
#       "sources" => ["8aeeb640-8dca-4b99-9c40-3b75de6579c2"]
#     },
#     "variables" => {},
#     "classes" => {
#       "emotion" => {
#         "puppetlabs.classifier/sources" => ["8aeeb640-8dca-4b99-9c40-3b75de6579c2"],
#         "importance" => {
#           "value" => "secondary",
#           "sources" => ["node"]
#         }
#       },
#       "logic" => {
#         "puppetlabs.classifier/sources" => ["8aeeb640-8dca-4b99-9c40-3b75de6579c2"],
#         "importance" => {
#           "value" => "primary",
#           "sources" => ["8aeeb640-8dca-4b99-9c40-3b75de6579c2"]
#         }
#       },
#       "config_data" => {
#         "USS::Enterprise" => {
#           "designation" => {
#             "value" => "original",
#             "sources" => ["00000000-0000-4000-8000-000000000000"]
#           }
#         },
#         "USS::Voyager" => {
#           "designation" => {
#             "value" => "subsequent",
#             "sources" => ["8aeeb640-8dca-4b99-9c40-3b75de6579c2"]
#           }
#         }
#       }
#     }
#   }
# }
```

## Commands Endpoint

Use the commands endpoint to unpin specified nodes from all node groups they’re pinned to.

### POST /v1/commands/unpin-from-all

[Reference](https://help.puppet.com/pe/current/topics/post_v1_commands_unpin_from_all.htm)

Unpin one or more specific nodes from all node groups they’re pinned to.
Unpinning has no effect on nodes that are assigned to node groups via dynamic rules.

```ruby
client.node_classifier_v1.commands.unpin_from_all(
    ["node1.example.com", "node2.example.com"]
)
# => {
#     "nodes": [
#         {
#             "name": "node1.example.com",
#             "groups": [{"id": "8310b045-c244-4008-88d0-b49573c84d2d",
#                         "name": "Webservers",
#                         "environment": "production"},
#                        {"id": "84b19b51-6db5-4897-9409-a4a3a94b7f09",
#                         "name": "Test",
#                         "environment": "test"}]
#         },
#         {
#             "name": "node2.example.com",
#             "groups": [{"id": "84b19b51-6db5-4897-9409-a4a3a94b7f09",
#                         "name": "Test",
#                         "environment": "test"}]
#         }
#     ]
# }
```

## Environments Endpoints

Use the environments endpoints to retrieve the node classifier's environment data.
The responses tell you which environments are available, whether a named environment exists, and which classes exist in a certain environment.

### GET /v1/environments

[Reference](https://help.puppet.com/pe/current/topics/get_v1_environments.htm)

Retrieve a list of all environments the node classifier knows about at the time of the request.

```ruby
client.node_classifier_v1.environments.get
# => [{"name" => "production", "sync_succeeded" => true}]
```

### GET /v1/environments/\<name>

[Reference](https://help.puppet.com/pe/current/topics/get_v1_environments_name.htm)

Retrieve information about a specific environment.

```ruby
client.node_classifier_v1.environments.get("production")
# => {"name" => "production", "sync_succeeded" => true}
```

### PUT /v1/environments/\<name>

[Reference](https://help.puppet.com/pe/current/topics/put_v1_environments_name.htm)

Create a new environment with a specific name.

```ruby
client.node_classifier_v1.environments.create("staging")
# => {}
```

### GET /v1/environments/\<environment>/classes

[Reference](https://help.puppet.com/pe/current/topics/get_v1_environments_environment_classes.htm)

Retrieve a list of all classes (that the node classifier knows about) in a specific environment.

```ruby
client.node_classifier_v1.environments.classes("production")
# => [
#     {
#         "name" => "apache",
#         "environment" => "production",
#         "parameters" => {
#             "default_mods" => true,
#             "default_vhost" => true,
#         }
#     }
# ]
```

### GET /v1/environments/\<environment>/classes/\<name>

[Reference](https://help.puppet.com/pe/current/topics/get_v1_environments_environment_classes_name.htm)

Retrieve a specific class in a specific environment.

```ruby
client.node_classifier_v1.environments.classes("production", "apache")
# => {
#     "name" => "apache",
#     "environment" => "production",
#     "parameters" => {
#         "default_mods" => true,
#         "default_vhost" => true,
#     }
# }
```

## Nodes Check-in History Endpoints

Use the nodes endpoints to retrieve records about nodes that have checked into the node classifier.

### GET /v1/nodes

[Reference](https://help.puppet.com/pe/current/topics/get_v1_nodes.htm)

Retrieve check-in history for all nodes that have checked in with the node classifier.

```ruby
client.node_classifier_v1.nodes.get(
    limit: 100,
    offset: 0
)
# => [
#     {
#         "name": "node.example.com",
#         "check_ins": [
#             {
#             "time": "2369-01-04T03:00:00Z",
#             "explanation": {
#                 "53029cf7-2070-4539-87f5-9fc754a0f041": {
#                 "value": true,
#                 "form": [
#                     "and",
#                     {
#                         "value": true,
#                         "form": [">=", {"path": ["fact", "pressure hulls"], "value": "3"}, "1"]
#                     },
#                     {
#                         "value": true,
#                         "form": ["=", {"path": ["fact", "warp cores"], "value": "0"}, "0"]
#                     },
#                     {
#                         "value": true,
#                         "form": [">", {"path": ["fact", "docking ports"], "value": "18"}, "9"]
#                     }
#                 ]
#                 }
#             }
#             }
#         ],
#         "transaction_uuid": "d3653a4a-4ebe-426e-a04d-dbebec00e97f"
#     }
# ]
```

### GET /v1/nodes/\<node>

[Reference](https://help.puppet.com/pe/current/topics/get_v1_nodes_node.htm)

Retrieve check-in history for a specific node that has checked in with the node classifier.

```ruby
client.node_classifier_v1.nodes.get(node: "node.example.com")
# => {
#     "name": "node.example.com",
#     "check_ins": [
#         {
#         "time": "2369-01-04T03:00:00Z",
#         "explanation": {
#             "53029cf7-2070-4539-87f5-9fc754a0f041": {
#             "value": true,
#             "form": [
#                 "and",
#                 {
#                     "value": true,
#                     "form": [">=", {"path": ["fact", "pressure hulls"], "value": "3"}, "1"]
#                 },
#                 {
#                     "value": true,
#                     "form": ["=", {"path": ["fact", "warp cores"], "value": "0"}, "0"]
#                 },
#                 {
#                     "value": true,
#                     "form": [">", {"path": ["fact", "docking ports"], "value": "18"}, "9"]
#                 }
#             ]
#             }
#         }
#         }
#     ],
#     "transaction_uuid": "d3653a4a-4ebe-426e-a04d-dbebec00e97f"
# }
```

## Group Children Endpoint

Use the group-children endpoint to retrieve a list of node groups descending from a specific node group.

### GET /v1/group-children/\<id>

[Reference](https://help.puppet.com/pe/current/topics/get_v1_group_children_id.htm)

Retrieve a list of node groups descending from a specific node group.

```ruby
client.node_classifier_v1.group_children.get("00000000-0000-4000-8000-000000000000")
# => [
#     {
#         "name" => "child-1",
#         "id" => "652227cd-af24-4fd8-96d4-b9b55ca28efb",
#         "parent" => "00000000-0000-4000-8000-000000000000",
#         "environment_trumps" => false,
#         "rule" => ["and", ["=", ["fact", "foo"], "bar"], ["not", ["<", ["fact", "uptime_days"], "31"]]],
#         "variables" => {},
#         "environment" => "test",
#         "classes" => {},
#         "children" => [
#             {
#                 "name" => "grandchild-1",
#                 "id" => "a3d976ad-51d3-4a29-af57-09990f3a2481",
#                 "parent" => "652227cd-af24-4fd8-96d4-b9b55ca28efb",
#                 "environment_trumps" => false,
#                 "rule" => ["and", ["=", ["fact", "foo"], "bar"], ["or", ["~", "name", "db"], ["<", ["fact", "processorcount"], "9"], ["=", ["fact", "operatingsystem"], "Ubuntu"]]],
#                 "variables" => {},
#                 "environment" => "test",
#                 "classes" => {},
#                 "children" => [],
#                 "immediate_child_count" => 0
#             },
#             {
#                 "name" => "grandchild-2",
#                 "id" => "71905c11-5295-41cf-a143-31b278cfc859",
#                 "parent" => "652227cd-af24-4fd8-96d4-b9b55ca28efb",
#                 "environment_trumps" => false,
#                 "rule" => ["and", ["=", ["fact", "foo"], "bar"], ["not", ["~", ["fact", "kernel"], "SunOS"]]],
#                 "variables" => {},
#                 "environment" => "test",
#                 "classes" => {},
#                 "children" => [],
#                 "immediate_child_count" => 0
#             }
#         ],
#         "immediate_child_count" => 2
#     },
#     {
#         "name" => "grandchild-5",
#         "id" => "0bb94f26-2955-4adc-8460-f5ce244d5118",
#         "parent" => "0960f75e-cdd0-4966-96f6-5e60948a7217",
#         "environment_trumps" => false,
#         "rule" => ["and", ["=", ["fact", "foo"], "bar"], ["and", ["<", ["fact", "processorcount"], "16"], [">=", ["fact", "kernelmajversion"], "2"]]],
#         "variables" => {},
#         "environment" => "test",
#         "classes" => {},
#         "children" => [],
#         "immediate_child_count" => 0
#     }
# ]
```

## Rules Endpoint

Use the rules endpoint to translate a node group rule condition into PuppetDB query syntax.

### POST /v1/rules/translate

[Reference](https://help.puppet.com/pe/current/topics/post_v1_rules_translate.htm)

Translate a node group rule condition into PuppetDB query syntax.

```ruby
client.node_classifier_v1.rules.translate(rule: ["fact", "is_spaceship", "true"])
# => "nodes { fact.is_spaceship = 'true' }"
```

## Import Hierarchy Endpoint

Use the import hierarchy endpoint to delete all existing node groups from the node classifier service and replace them with the node groups defined in the body of the request.

### POST /v1/import-hierarchy

[Reference](https://help.puppet.com/pe/current/topics/post_v1_import_hierarchy.htm)

Delete _all_ existing node groups from the node classifier service and replace them with the node groups defined in the body of the submitted request.

```ruby
client.node_classifier_v1.import_hierarchy.replace(
    [
        {
            environment_trumps: false,
            parent: "00000000-0000-4000-8000-000000000000",
            name: "My Nodes",
            variables: {},
            id: "085e2797-32f3-4920-9412-8e9decf4ef65",
            environment: "production",
            classes: {}
        }
    ]
)
# => {}
```

## Last Class Update Endpoint

Use the last-class-update endpoint to retrieve the time that classes were last updated from the primary server.

### GET /v1/last-class-update

[Reference](https://help.puppet.com/pe/current/topics/get_v1_last_class_update.htm)

Retrieve the time that classes were last updated from the primary server.

```ruby
client.node_classifier_v1.last_class_update.get
# => {"last_update" => "2024-01-01T00:00:00Z"}
```

## Update Classes Endpoint

Use the update-classes endpoint to trigger the node classifier to get updated class and environment definitions from the primary server.

### POST /v1/update-classes

[Reference](https://help.puppet.com/pe/current/topics/post_v1_update_classes.htm)

Trigger the node classifier to retrieve updated class and environment definitions from the primary server.
The classifier service also uses this endpoint when you refresh classes in the console.

```ruby
client.node_classifier_v1.update_classes.update
# => {}
```

## Validation Endpoint

Use the validation endpoint to validate groups in the node classifier.

### POST /v1/validate/group

[Reference](https://help.puppet.com/pe/current/topics/post_v1_validate_group.htm)

Validate groups in the node classifier.

```ruby
client.node_classifier_v1.validation.group(
    name: "My Nodes",
    parent: "00000000-0000-4000-8000-000000000000",
    environment: "production",
    classes: {}
)
# => {
#     "name" => "My Nodes",
#     "parent" => "00000000-0000-4000-8000-000000000000",
#     "environment" => "production",
#     "classes" => {}
# }
```
