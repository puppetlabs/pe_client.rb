# Orchestrator API

[The Orchestrator API](https://help.puppet.com/pe/current/topics/orchestrator_api_v1_endpoints.htm) is useful for:

- Gathering details about the orchestrator jobs you run.
- Inspecting applications and applications instances in your Puppet environments.

Communicates with Puppet Enterprise on port 8143.

## Root Endpoints

Use the orchestrator endpoint to get orchestrator API metadata.

### GET /orchestrator/v1

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_orchestrator.htm)

Returns metadata about the orchestrator API, along with a list of links to application management resources.

```ruby
client.orchestrator_v1.get
# => {
#   "info" : {
#     "title" : "Application Management API (EXPERIMENTAL)",
#     "description" : "Multi-purpose API for performing application management operations",
#     "warning" : "This version of the API is experimental, and might change in backwards-incompatible ways in the future",
#     "version" : "0.1",
#     "license" : {
#       "name" : "Puppet Enterprise License",
#       "url" : "https://puppetlabs.com/puppet-enterprise-components-licenses"
#     }
#   },
#   "status" : {
#     "name" : "status",
#     "id" : "https://orchestrator.example.com:8143/orchestrator/v1/status"
#   },
#   "collections" : [ {
#     "name" : "environments",
#     "id" : "https://orchestrator.example.com:8143/orchestrator/v1/environments"
#   }, {
#     "name" : "jobs",
#     "id" : "https://orchestrator.example.com:8143/orchestrator/v1/jobs"
#   } ],
#   "commands" : [ {
#     "name" : "deploy",
#     "id" : "https://orchestrator.example.com:8143/orchestrator/v1/command/deploy"
#   }, {
#     "name" : "stop",
#     "id" : "https://orchestrator.example.com:8143/orchestrator/v1/command/stop"
#   } ]
# }
```

## Command Endpoints

Use the command endpoints to run Puppet, jobs, and plans on demand or stop in-progress jobs.
You can also create task-targets, which provide privilege escalation for users who would otherwise not be able to run certain tasks or run tasks on certain nodes or node groups.

### POST /command/deploy

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_command_deploy.htm)

Run Puppet on demand – run the orchestrator across all nodes in an environment.

```ruby
client.orchestrator_v1.command.deploy(
  environment: "",
  enforce_environment: false,
  noop: true,
  scope: {
    nodes: ["node1.example.com"]
  },
  userdata: {
    servicenow_ticket: "INC0011211"
  }
)
# => {
#   "job" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/81"
#     "name" => "81"
#   }
# }
```

### POST /command/stop

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_command_stop.htm)

Stop an orchestrator job that is currently in progress.

```ruby
client.orchestrator_v1.command.stop(
    job: "81",
    force: true
)
# => {
#   "job" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/81",
#     "name" => "81",
#     "nodes" => {
#       "new" => 5,
#       "running" => 8,
#       "failed"  => 3,
#       "errored" => 1,
#       "skipped" => 2,
#       "finished"=> 5
#     }
#   }
# }
```

### POST /command/stop_plan

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_command_stop_plan.htm)

Stop an orchestrator plan job that is currently in progress.
This command interrupts the thread that is running the plan.
If the plan doesn't have code to explicitly handle the interrupt, the plan finishes with an error.
If the plan can handle the interrupt, whether or not the plan stops depends on the plan's interruption handling.
If the plan is running a task (or otherwise) when interrupted, an error occurs and the plan stops, but the underlying in-progress task job finishes.
If you need to force stop an in-progress job, use [POST /command/stop](#post-commandstop).

```ruby
client.orchestrator_v1.command.stop_plan(plan_job: "82")
# => {
#   "name" => "82"
# }
```

### POST /command/task

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_command_task.htm)

Run a task on a set of nodes.
The task does not run on any nodes in the defined scope that you do not have permission to run tasks on.

```ruby
client.orchestrator_v1.command.task(
  environment: "test-env-1",
  task: "package",
  params: {
    action: "install",
    name: "httpd"
  },
  scope: {
    nodes: ["node1.example.com"]
  }
)
# => {
#   "job" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/81"
#     "name" => "81"
#   }
# }
```

### POST /command/task_target

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_command_task_target.htm)

Create a task-target, which is a set of tasks and nodes/node groups you can use to provide specific privilege escalation for users who would otherwise not be able to run certain tasks or run tasks on certain nodes or node groups.
When you grant a user permission to use a task-target, the user can run the task(s) in the task-target on the set of nodes defined in the task-target.

```ruby
client.orchestrator_v1.command.task_target(
  display_name: "task_target_example_1",
  tasks: ["task_1", "task_2"],
  nodes: ["node1" "node2"],
  node_groups: ["00000000-0000-4000-8000-000000000000"]
)
# => {
#   "task_target" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/scopes/task_targets/1",
#     "name" => "1"
#   }
# }
```

### POST /command/plan_run

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_command_plan_run.htm)

Use the plan executor to run a plan.

```ruby
client.orchestrator_v1.command.plan_run(
    plan_name: "canary",
    description: "Start the canary plan on node1 and node2",
    params: {
        nodes: ["node1.example.com", "node2.example.com"],
        command: "whoami",
        canary: 1
    }
)
# => {
#   "name" => "1234"
# }
```

### POST /command/environment_plan_run

[Reference](https://help.puppet.com/pe/current/topics/orchestrator-api-post-command-environment-plan-run.htm)

Use parameters to run a plan on specific nodes in a specific environment.

```ruby
client.orchestrator_v1.command.environment_plan_run(
    plan_name: "example_plan",
    description: "Output 'message' on the targets contained in 'targets' and 'more targets'",
    params: {
        message: {
            value: "hello"
        },
        example_object_param: {
            value: {
                value: "xyz"
            }
        },
        targets: {
            type: "query",
            value: "nodes[certname] { }"
        },
        more_targets: {
            type: "node_group",
            value: "<UUID>"
        }
    }
)
# => {
#   "name" => "1234"
# }
```

## Inventory Endpoints

Use the inventory endpoints to check whether the orchestrator can reach a node.

### GET /inventory

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_inventory.htm)

Retrieve a list of all nodes connected to the Puppet Communications Protocol (PCP) broker.

```ruby
client.orchestrator_v1.inventory.get
# => {
#   "items" => [
#     {
#       "name" => "node1.example.com",
#       "connected" => true,
#       "broker" => "pcp://broker1.example.com/server",
#       "timestamp" => "2016-010-22T13:36:41.449Z"
#     },
#     {
#       "name" => "node2.example.com",
#       "connected" => true,
#       "broker" => "pcp://broker2.example.com/server",
#       "timestamp" => "2016-010-22T13:39:16.377Z"
#     },
#     {
#       "name" => "node3.example.com",
#       "connected" => false
#     }
#   ]
# }
```

### GET /inventory/\<node>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_inventory_node.htm)

Retrieve information about a single node's connection to the Puppet Communications Protocol (PCP) broker.

```ruby
client.orchestrator_v1.inventory.get("node1.example.com")
# => {
#   "name" => "node1.example.com",
#   "connected" => true,
#   "broker" => "pcp://broker.example.com/server",
#   "timestamp" => "2017-03-29T21:48:09.633Z"
# }
```

### POST /inventory

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_inventory.htm)

Returns information about multiple nodes' connections to the Puppet Communications Protocol (PCP) broker.

```ruby
client.orchestrator_v1.inventory.get_multiple(["node1.example.com", "node2.example.com", "node3.example.com"])
# => {
#   "items" => [
#     {
#       "name" => "node1.example.com",
#       "connected" => true,
#       "broker" => "pcp://broker.example.com/server",
#       "timestamp" => "2017-07-14T15:57:33.640Z"
#     },
#     {
#       "name" => "node2.example.com",
#       "connected" => false
#     },
#     {
#       "name" => "node3.example.com",
#       "connected" => true,
#       "broker" => "pcp://broker.example.com/server",
#       "timestamp" => "2017-07-14T15:41:19.242Z"
#     }
#   ]
# }
```

## Jobs Endpoints

Use the jobs endpoints to examine jobs and their details.

### GET /jobs

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_jobs.htm)

Retrieve details about all jobs that the orchestrator knows about.

```ruby
client.orchestrator_v1.jobs.get(
    limit: 20,
    offset: 0,
    order: "asc",
    order_by: "timestamp"
)
# => {
#   "items" => [
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1234",
#       "name" => "1234",
#       "state" => "finished",
#       "command" => "deploy",
#       "type" => "deploy",
#       "node_count" => 5,
#       "node_states" => {
#         "finished" => 2,
#         "errored" => 1,
#         "failed" => 1,
#         "running" => 1
#       },
#       "options" => {
#         "concurrency" => nil,
#         "noop" => false,
#         "trace" => false,
#         "debug" => false,
#         "scope" => {},
#         "enforce_environment" => true,
#         "environment" => "production",
#         "evaltrace" => false,
#         "target" => nil,
#         "description" => "deploy the web app"
#       },
#       "owner" => {
#         "email" => "admin@example.com",
#         "is_revoked" => false,
#         "last_login" => "2020-05-05T14:03:06.226Z",
#         "is_remote" => true,
#         "login" => "admin",
#         "inherited_role_ids" => [ 2 ],
#         "group_ids" => [ "9a588fd8-3daa-4fc2-a396-bf88945def1e" ],
#         "is_superuser" => false,
#         "id" => "751a8f7e-b53a-4ccd-9f4f-e93db6aa38ec",
#         "role_ids" => [ 1 ],
#         "display_name" => "Admin",
#         "is_group" => false
#       },
#       "description" => "deploy the web app",
#       "timestamp" => "2016-05-20T16:45:31Z",
#       "started_timestamp" => "2016-05-20T16:41:15Z",
#       "finished_timestamp" => "2016-05-20T16:45:31Z",
#       "duration" => "256.0",
#       "environment" => {
#         "name" => "production"
#       },
#       "report" => {
#         "id" => "https://localhost:8143/orchestrator/v1/jobs/375/report"
#       },
#       "events" => {
#         "id" => "https://localhost:8143/orchestrator/v1/jobs/375/events"
#       },
#       "nodes" => {
#         "id" => "https://localhost:8143/orchestrator/v1/jobs/375/nodes"
#       },
#       "userdata" => {
#         "servicenow_ticket" => "INC0011211"
#       }
#     },
#     {
#       "description" => "",
#       "report" => {
#         "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1235/report"
#       },
#       "name" => "1235",
#       "events" => {
#         "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1235/events"
#       },
#       "command" => "plan_task",
#       "type" => "plan_task",
#       "state" => "finished",
#       "nodes" => {
#         "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1235/nodes"
#       },
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1235",
#       "environment" => {
#         "name" => ""
#       },
#       "options" => {
#         "description" => "",
#         "plan_job" => 197,
#         "noop" => nil,
#         "task" => "facts",
#         "sensitive" => [],
#         "scheduled-job-id" => nil,
#         "params" => {},
#         "scope" => {
#           "nodes" => [
#             "orchestrator.example.com"
#           ]
#         },
#         "project" => {
#           "project_id" => "foo_id",
#           "ref" => "524df30f58002d30a3549c52c34a1cce29da2981"
#         }
#       },
#       "timestamp" => "2020-09-14T18:00:12Z",
#       "started_timestamp" =>  "2020-09-14T17:59:05Z",
#       "finished_timestamp" =>  "2020-09-14T18:00:12Z",
#       "duration" => "67.34",
#       "owner" => {
#         "email" => "",
#         "is_revoked" => false,
#         "last_login" => "2020-08-05T17:54:07.045Z",
#         "is_remote" => false,
#         "login" => "admin",
#         "is_superuser" => true,
#         "id" => "42bf351c-f9ec-40af-84ad-e976fec7f4bd",
#         "role_ids" => [
#           1
#         ],
#         "display_name" => "Administrator",
#         "is_group" => false
#       },
#       "node_count" => 1,
#       "node_states" => {
#         "finished" => 1
#       },
#       "userdata" => {}
#     }
#   ],
#   "pagination" => {
#     "limit" => 20,
#     "offset" => 0,
#     "order" => "asc",
#     "order_by" => "timestamp",
#     "total" => 2,
#     "type" => ""
#   }
# }
```

### GET /jobs/\<job-id>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_jobs_job_id.htm)

Retrieve details of a specific job, including the start and end times for each job state.

```ruby
client.orchestrator_v1.jobs.get(job_id: "1234")
# => {
#   "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1234",
#   "name" => "1234",
#   "command" => "deploy",
#   "type" => "deploy",
#   "state" => "finished",
#   "options" => {
#     "concurrency" => nil,
#     "noop" => false,
#     "trace" => false,
#     "debug" => false,
#     "scope" => {
#       "nodes" => ["node1.example.com", "node2.example.com"] },
#     "enforce_environment" => true,
#     "environment" => "production",
#     "evaltrace" => false,
#     "target" => nil
#   },
#   "node_count" => 2,
#   "owner" => {
#     "email" => "admin@example.com",
#     "is_revoked" => false,
#     "last_login" => "2020-05-05T14:03:06.226Z",
#     "is_remote" => true,
#     "login" => "admin",
#     "inherited_role_ids" => [ 2 ],
#     "group_ids" => [ "9a588fd8-3daa-4fc2-a396-bf88945def1e" ],
#     "is_superuser" => false,
#     "id" => "751a8f7e-b53a-4ccd-9f4f-e93db6aa38ec",
#     "role_ids" => [ 1 ],
#     "display_name" => "Admin",
#     "is_group" => false
#   },
#   "description" => "deploy the web app",
#   "timestamp" => "2016-05-20T16:45:31Z",
#   "started_timestamp" => "2016-05-20T16:41:15Z",
#   "finished_timestamp" => "2016-05-20T16:45:31Z",
#   "duration" => "256.0",
#   "environment" => {
#     "name" => "production"
#   },
#   "status" => [ {
#     "state" => "new",
#     "enter_time" => "2016-04-11T18:44:31Z",
#     "exit_time" => "2016-04-11T18:44:31Z"
#   }, {
#     "state" => "ready",
#     "enter_time" => "2016-04-11T18:44:31Z",
#     "exit_time" => "2016-04-11T18:44:31Z"
#   }, {
#     "state" => "running",
#     "enter_time" => "2016-04-11T18:44:31Z",
#     "exit_time" => "2016-04-11T18:45:31Z"
#   }, {
#     "state" => "finished",
#     "enter_time" => "2016-04-11T18:45:31Z",
#     "exit_time" => nil
#   } ],
#   "nodes" => { "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1234/nodes" },
#   "report" => { "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/1234/report" },
#   "userdata" => {}
# }
```

### GET /jobs/\<job-id>/nodes

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_jobs_job_id_nodes.htm)

Retrieve information about nodes associated with a specific job.

```ruby
client.orchestrator_v1.jobs.nodes("3")
# => {
#   "next-events" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/3/events?start=10",
#     "event" => "10"
#   },
#   "items" => [ {
#     "timestamp" => "2015-07-13T20:37:01Z",
#     "start_timestamp" => "2015-07-13T20:36:13Z",
#     "finish_timestamp" => "2015-07-13T20:37:01Z",
#     "duration" => 48.0,
#     "state" => "finished",
#     "transaction_uuid" => <UUID>,
#     "name" => "node1.example.com",
#     "details" => {
#       "message" => "Message from latest event"
#     },
#     "result" => {
#       "output_1" => "success",
#       "output_2" => [1, 1, 2, 3,]
#     }
#   } ]
# }
```

### GET /jobs/\<job-id>/report

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_jobs_job_id_report.htm)

Returns a report that summarizes a specific job.

```ruby
client.orchestrator_v1.jobs.report("3")
# => {
#   "items" => [ {
#     "node" => "node1.example.com",
#     "state" => "running",
#     "timestamp" => "2015-07-13T20:37:01Z",
#     "events" => [ ]
#   } ]
# }
```

### GET /jobs/\<job-id>/events

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_jobs_job_id_events.htm)

Retrieve a list of events that occurred during a specific job.

```ruby
client.orchestrator_v1.jobs.events("3")
# => {
#   "next-events" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/jobs/352/events?start=1272"
#   },
#   "items" => [ {
#     "id" => "1272",
#     "type" => "node_running",
#     "timestamp" => "2016-05-05T19:50:08Z",
#     "details" => {
#       "node" => "puppet-agent.example.com",
#       "detail" => {
#         "noop" => false
#       }
#     },
#     "message" => "Started puppet run on puppet-agent.example.com ..."
#   } ]
# }
```

## Scheduled Jobs Endpoints

Use the scheduled_jobs endpoints to query, edit, and delete scheduled orchestrator jobs.

### GET /scheduled_jobs/environment_jobs

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_sch_jobs_env_jobs.htm)

Retrieve information about scheduled environment jobs, which are deployments, tasks, or plans that run in a specific environment.
Use parameters to narrow the response scope.

```ruby
client.orchestrator_v1.scheduled_jobs.get(
    limit: 50,
    offset: 0,
    order: "asc",
    order_by: "next_run_time",
)
# => {
#   "items" => [
#     {
#       "id" => "https://host.example.com:8143/orchestrator/v1/scheduled_jobs/environment_jobs/2",
#       "name" => "2",
#       "environment" =>  "plan_testing_env",
#       "owner" => {
#         "email" => "fred@example.com",
#         "login" => "fred",
#         "display_name" => "Fred",
#         "id" => "784beba4-8cc8-414f-aab0-e9a29c9b65c2",
#         "is_revoked" => false,
#         "last_login" => "2020-05-08T15:57:28.444Z",
#         "is_remote" => true,
#         "is_group" => false,
#         "is_superuser" => false,
#         "role_ids" => [
#           1
#         ],
#         "inherited_role_ids" => [
#           2
#         ],
#         "group_ids" => [
#           "9a588fd8-3daa-4fc2-a396-bf88945def1e"
#         ]
#       },
#       "description" => "Fred's scheduled environment plan",
#       "type" => "plan",
#       "next_run" => {
#         "time" => "2021-12-12T19:50:08Z"
#       },
#       "last_run" => {
#         "time" => "2021-11-12T19:50:08Z",
#         "job" => {
#           "id" => "https://host.example.com:8143/orchestrator/v1/plan_jobs/42",
#           "name" => 42
#         }
#       },
#       "schedule" => {
#         "start_time" => "2018-10-05T19:50:08Z",
#         "interval" => {
#           "value" => 3600,
#           "units" => "seconds"
#         }
#       },
#       "input" => {
#         "name" => "plan_testing_env::example_plan",
#         "parameters" => {
#           "param_1" => "foo"
#         },
#         "sensitive_parameters" => ["password"]
#       },
#       "userdata" => {
#         "ticket" => "TICKET-123"
#       }
#     },
#     {
#       "id" => "https://host.example.com:8143/orchestrator/v1/scheduled_jobs/environment_jobs/1",
#       "name" => "1",
#       "environment" => "plan_testing_env",
#       "owner" => {
#         "email" => "user@example.com",
#         "login" => "user",
#         "display_name" => "User",
#         "id" => "06990bb9-df3a-4150-964f-88b9cf0f8eec",
#         "last_login" => "2019-07-08T15:57:28.444Z",
#         "is_revoked" => false,
#         "is_remote" => true,
#         "is_group" => false,
#         "is_superuser" => false,
#         "role_ids" => [
#           1
#         ],
#         "inherited_role_ids" => [
#           2
#         ],
#         "group_ids" => [
#           "9a588fd8-3daa-4fc2-a396-bf88945def1e"
#         ]
#       },
#       "description" => "",
#       "type" => "plan",
#       "schedule" => {
#         "start_time" => "2018-10-05T19:50:08Z",
#         "interval" => nil
#       },
#       "input" => {
#         "name" => "plan_testing_env::example_plan",
#         "parameters" => {
#           "param_1" => "foo"
#         },
#         "sensitive_parameters" => []
#       },
#       "userdata" => {
#         "approval_reference" => "442"
#       },
#       "start_time" => "2020-10-05T19:50:08Z",
#       "next_run" => {
#         "time" => "2021-12-12T19:50:08Z"
#       },
#       "last_run" => {
#         "time" => "2021-11-12T19:50:08Z",
#         "job" => {
#           "submission_error" => {
#               "kind" => "puppetlabs.orchestrator/unknown-environment",
#               "msg" => "Unknown environment doesnotexist",
#               "details" => {
#                 "environment" => "doesnotexist"
#             }
#           },
#           "name" => 33
#         }
#       }
#     }
#   ],
#   "pagination" => {
#     "limit" => 50,
#     "offset" => 0,
#     "order" => "asc",
#     "order_by" => "next_run_time",
#     "total" => 2,
#   }
# }
```

### GET /scheduled_jobs/environment_jobs/\<job-id>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_sch_jobs_env_jobs_jid.htm)

Retrieve information about a specific scheduled environment job.

```ruby
client.orchestrator_v1.scheduled_jobs.get(job_id: "2")
# => {
#   "name" => "https://host.example.com:8143/orchestrator/v1/scheduled_jobs/environment_jobs/2",
#   "id" => "2",
#   "environment" => "production",
#   "owner" => {
#     "email" => "fred@example.com",
#     "login" => "fred",
#     "display_name" => "Fred",
#     "id" => "784beba4-8cc8-414f-aab0-e9a29c9b65c2",
#     "is_revoked" => false,
#     "last_login" => "2020-05-08T15:57:28.444Z",
#     "is_remote" => true,
#     "is_group" => false,
#     "is_superuser" => false,
#     "role_ids" => [
#       1
#     ],
#     "inherited_role_ids" => [
#       2
#     ],
#     "group_ids" => [
#       "9a588fd8-3daa-4fc2-a396-bf88945def1e"
#     ]
#   },
#   "description" => "Fred's scheduled environment plan",
#   "type" => "plan",
#   "next_run" => {
#     "time" => "2021-12-12T19:50:08Z"
#   },
#   "last_run" => {
#     "time" => "2021-11-12T19:50:08Z",
#     "job" => {
#       "id" => "https://host.example.com:8143/orchestrator/v1/plan_jobs/42",
#       "name" => 42
#     }
#   },
#   "schedule" => {
#     "start_time" => "2018-10-05T19:50:08Z",
#     "interval" => {
#       "value" => 3600,
#       "units" => "seconds"
#     }
#   },
#   "input" => {
#     "name" => "example_module::example_plan",
#     "parameters" => {
#       "param_1" => "foo"
#     },
#     "sensitive_parameters" => ["password"]
#   },
#   "userdata" => {
#     "ticket" => "TICKET-123"
#   }
# }
```

### POST /scheduled_jobs/environment_jobs

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_post_sch_jobs_env_jobs.htm)

Create an environment job to run in the future.
An environment job is a deployment, task, or plan that runs in a specific environment, such as a Puppet run on nodes in your production environment.

```ruby
client.orchestrator_v1.scheduled_jobs.create(
    description: "run facts plan once on node1 in my_environment",
    input: {
    name: "sensitive_params::scheduled_jobs_storage",
    parameters: {
        primary: {
        value: "example.delivery.puppetlabs.net"
        },
        param_one: {
        value: "first_value"
        }
    }
    },
    environment: "my_environment",
    schedule: {
    start_time: "2022-01-28T09:35:56-08:00",
    interval: nil
    },
    userdata: {
        snow_ticket: "INC0011211"
    },
    type: "plan"
)
# => {
#   "scheduled_job" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/scheduled_jobs/environment_jobs/2",
#     "name" => "2"
#   }
# }
```

### PUT /scheduled_jobs/environment_jobs/\<job-id>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_put_sch_jobs_env_jobs_jid.htm)

```ruby
client.orchestrator_v1.scheduled_jobs.update(
    job_id: "2",
    description: "run facts plan once on node1 in my_environment",
    input: {
    name: "sensitive_params::scheduled_jobs_storage",
    parameters: {
        primary: {
        value: "example.delivery.puppetlabs.net"
        },
        param_one: {
        value: "first_value"
        }
    }
    },
    environment: "my_environment",
    schedule: {
    start_time: "2022-01-28T09:35:56-08:00",
    interval: nil
    },
    userdata: {
        snow_ticket: "INC0011211"
    },
    enabled: true
)
# => {
#   "scheduled_job" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/scheduled_jobs/environment_jobs/2",
#     "name" => "2"
#   }
# }
```

## Plans Endpoints

Use the plans endpoints to get information about plans.

### GET /plans

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_plans.htm)

Lists all known plans in a specific environment.

```ruby
client.orchestrator_v1.plans.get
# => {
#   "environment" => {
#     "name" => "production",
#     "code_id" => nil
#   },
#   "items" => [
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plans/profile/firewall",
#       "name" => "profile::firewall",
#       "permitted" => true
#     },
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plans/profile/rolling_update",
#       "name" => "profile::rolling_update",
#       "permitted" => true
#     },
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plans/canary/random",
#       "name" => "canary::random",
#       "permitted" => false
#     }
#   ]
# }
```

### GET /plans/\<module>/\<plan-name>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_plans_module_planname.htm)

Get information about a specific plan, including metadata.

```ruby
client.orchestrator_v1.plans.get(module_name: "canary", plan_name: "random")
# => {
#   "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plans/canary/random",
#   "name" => "canary::random",
#   "environment" => {
#     "name" => "production",
#     "code_id" => nil
#   },
#   "metadata" => {},
#   "permitted" => true
# }
```

## Plan Jobs Endpoints

Use the plan_jobs endpoints to examine plan jobs and their details.

### GET /plan_jobs

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_plan_jobs.htm)

Retrieve details about all plan jobs that the orchestrator knows about.

```ruby
client.orchestrator_v1.plan_jobs.get(
    limit: 6,
    offset: 3,
)
# => {
#   "items" => [
#     {
#       "finished_timestamp" => "2020-09-23T18:00:13Z",
#       "name" => "38",
#       "events" => {
#         "id" => "https://orchestrator.example.com:8143:8143/orchestrator/v1/plan_jobs/38/events"
#       },
#       "state" => "success",
#       "result" => [
#         "orchestrator.example.com: CentOS 7.2.1511 (RedHat)"
#       ],
#       "id" => "https://orchestrator.example.com:8143:8143/orchestrator/v1/plan_jobs/38",
#       "created_timestamp" => "2020-09-23T18:00:08Z",
#       "duration" => 123.456,
#       "options" => {
#         "description" => "just the facts",
#         "plan_name" => "facts::info",
#         "parameters" => {
#           "targets" => "orchestrator.example.com"
#         },
#         "sensitive" => [],
#         "scheduled_job_id" => "116",
#         "project" => {
#           "project_id" => "myproject_id",
#           "ref" => "524df30f58002d30a3549c52c34a1cce29da2981"
#         }
#       },
#       "owner" => {
#         "email" => "",
#         "is_revoked" => false,
#         "last_login" => "2020-08-05T17:54:07.045Z",
#         "is_remote" => false,
#         "login" => "admin",
#         "is_superuser" => true,
#         "id" => "42bf351c-f9ec-40af-84ad-e976fec7f4bd",
#         "role_ids" => [
#           1
#         ],
#         "display_name" => "Administrator",
#         "is_group" => false
#       },
#       "userdata" => {
#         "servicenow_ticket" => "INC0011211"
#       }
#     },
#     {
#       "finished_timestamp" => nil,
#       "name" => "37",
#       "events" => {
#         "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plan_jobs/37/events"
#       },
#       "state" => "running",
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plan_jobs/37",
#       "created_timestamp" => "2018-06-06T20:22:08Z",
#       "duration" => 123.456,
#       "options" => {
#         "description" => "Testing myplan",
#         "plan_name" => "myplan",
#         "parameters" => {
#           "nodes" => [
#             "orchestrator.example.com"
#           ]
#         },
#         "sensitive" => ["secret"],
#         "environment" => "production",
#         "scheduled_job_id" => nil
#       },
#       "owner" => {
#         "email" => "",
#         "is_revoked" => false,
#         "last_login" => "2018-06-06T20:22:06.327Z",
#         "is_remote" => false,
#         "login" => "admin",
#         "is_superuser" => true,
#         "id" => "42bf351c-f9ec-40af-84ad-e976fec7f4bd",
#         "role_ids" => [
#           1
#         ],
#         "display_name" => "Administrator",
#         "is_group" => false
#       },
#       "result" => nil,
#       "userdata" => {}
#     },
#   ],
#   "pagination" => {
#     "limit" => 6,
#     "offset" => 3,
#     "total" => 40
#   }
# }
```

### GET /plan_jobs/\<job-id>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_plan_jobs_id.htm)

Retrieve details of a specific plan job, including the start and end times for each job state.

```ruby
client.orchestrator_v1.plan_jobs.get(job_id: "1234")
# => {
#   "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plan_jobs/1234",
#   "name" => "1234",
#   "state" => "success",
#   "options" => {
#     "description" => "This is a plan run",
#     "plan_name" => "package::install",
#     "parameters" => {
#       "foo" => "bar"
#     }
#   },
#   "result" => {
#     "output" => "test\n"
#   },
#   "owner" => {
#     "email" => "",
#     "is_revoked" => false,
#     "last_login" => "YYYY-MM-DDT17:06:48.170Z",
#     "is_remote" => false,
#     "login" => "admin",
#     "is_superuser" => true,
#     "id" => "42bf351c-f9ec-40af-84ad-e976fec7f4bd",
#     "role_ids" => [
#       1
#     ],
#     "display_name" => "Administrator",
#     "is_group" => false
#   },
#   "timestamp" => "YYYY-MM-DDT16:45:31Z",
#   "status" => {
#     "1" => [
#       {
#         "state" => "running",
#         "enter_time" => "YYYY-MM-DDT18:44:31Z",
#         "exit_time" => "YYYY-MM-DDT18:45:31Z"
#       },
#       {
#         "state" => "finished",
#         "enter_time" => "YYYY-MM-DDT18:45:31Z",
#         "exit_time" => nil
#       }
#     ],
#     "2" => [
#       {
#         "state" => "running",
#         "enter_time" => "YYYY-MM-DDT18:44:31Z",
#         "exit_time" => "YYYY-MM-DDT18:45:31Z"
#       },
#       {
#         "state" => "failed",
#         "enter_time" => "YYYY-MM-DDT18:45:31Z",
#         "exit_time" => nil
#       }
#     ]
#   },
#   "events" => {
#     "id" => "https://localhost:8143/orchestrator/v1/plan_jobs/1234/events"
#   },
#   "userdata" => {}
# }
```

### GET /plan_jobs/\<job-id>/events

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_plan_jobs_job_id_events.htm)

Retrieve a list of events that occurred during a specific plan job.

```ruby
client.orchestrator_v1.plan_jobs.events(job_id: "352")
# => {
#   "next-events" => {
#     "id" => "https://orchestrator.example.com:8143/orchestrator/v1/plan_jobs/352/events?start=1272",
#     "event" => "1272"
#   },
#   "items" => [ {
#     "id" => "1273",
#     "type" => "task_start",
#     "timestamp" => "2016-05-05T19:50:08Z",
#     "details" => {
#       "job-id" => "8765"
#     }
#   },
#   {
#     "id" => "1274",
#     "type" => "plan_finished",
#     "timestamp" => "2016-05-05T19:50:14Z",
#     "details" => {
#       "plan-id" => "1234",
#       "result" => {
#         "Plan output"
#       },
#     },
#   }]
# }
```

### GET /plan_jobs/\<job-id>/event/\<event-id>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_plan_jobs_job_id_event_id.htm)

Retrieve the details of a specific event for a specific plan job.

```ruby
client.orchestrator_v1.plan_jobs.events(job_id: "352", event_id: "1265")
# => {    
#     "id" => "1265",
#     "type" => "out_message",
#     "timestamp" => "2016-05-05T19:50:06Z",
#     "details" => {
#         "message" => "this is an output message"
#     }
# }
```

## Tasks Endpoints

Use the tasks endpoints to get information about tasks you've installed and tasks included with Puppet Enterprise (PE).

### GET /tasks

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_tasks.htm)

Lists all tasks in a specific environment.

```ruby
client.orchestrator_v1.tasks.get
# => {
#   "environment" => {
#     "name" => "production",
#     "code_id" => "urn:puppet:code-id:1:a86da166c30f871823f9b2ea224796e834840676;production"
#   },
#   "items" => [
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/tasks/package/install",
#       "name" => "package::install"
#     },
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/tasks/package/upgrade",
#       "name" => "package::upgrade"
#     },
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/tasks/exec/init",
#       "name" => "exec"
#     }
#   ]
# }
```

### GET /tasks/\<module>/\<task-name>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_tasks_module_taskname.htm)

Get information about a specific task, including metadata and file information.

```ruby
client.orchestrator_v1.tasks.get(module_name: "package", task_name: "install")
# => {
#   "id" => "https://orchestrator.example.com:8143/orchestrator/v1/tasks/package/install",
#   "name" => "package::install",
#   "environment" => {
#     "name" => "production",
#     "code_id" => "urn:puppet:code-id:1:a86da166c30f871823f9b2ea224796e834840676;production"
#   },
#   "metadata" => {
#     "description" => "Install a package",
#     "supports_noop" => true,
#     "input_method" => "stdin",
#     "parameters" => {
#       "name" => {
#         "description" => "The package to install",
#         "type" => "String[1]"
#       },
#       "provider" => {
#         "description" => "The provider to use to install the package",
#         "type" => "Optional[String[1]]"
#       },
#       "version" => {
#         "description" => "The version of the package to install, defaults to latest",
#         "type" => "Optional[String[1]]"
#       }
#     }
#   },
#   "files" => [
#     {
#       "filename" => "install",
#       "uri" => {
#         "path" => "/package/tasks/install",
#         "params" => {
#           "environment" => "production"
#         }
#       },
#       "sha256" => "a9089b5b9720dca38a49db6f164cf8a053a7ea528711325da1c23de94672980f",
#       "size_bytes" => 693
#     }
#   ]
# }
```

## Usage Endpoint

Use the usage endpoint to view details about your deployment's active nodes.

### GET /usage

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_usage.htm)

Retrieves information about the orchestrator's daily node usage, Puppet events activity on nodes, and nodes that are present in PuppetDB.

```ruby
client.orchestrator_v1.usage(
    start_date: "2018-06-05",
    end_date: "2018-06-08",
    events: "exclude"
)
# => {
#   "items" => [
#       {
#         "date" => "2018-06-08",
#         "total_nodes" => 100,
#         "nodes_with_agent" => 95,
#         "nodes_without_agent" => 5
#       }, {
#         "date" => "2018-06-07",
#         "total_nodes" => 100,
#         "nodes_with_agent" => 95,
#         "nodes_without_agent" => 5
#       }, {
#         "date" => "2018-06-06",
#         "total_nodes" => 100,
#         "nodes_with_agent" => 95,
#         "nodes_without_agent" => 5
#       }, {
#         "date" => "2018-06-05",
#         "total_nodes" => 100,
#         "nodes_with_agent" => 95,
#         "nodes_without_agent" => 5
#       }
#   ],
#   "pagination" => {
#      "start_date" => "2018-06-01",
#      "end_date" => "2018-06-30"
#   }
# }
```

## Scopes Endpoints

Use the scopes endpoints to retrieve information about task-targets.

### GET /scopes/task_targets

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_scopes_task_targets.htm)

Retrieve information about all orchestrator task-targets.

```ruby
client.orchestrator_v1.scopes.get
# => {
#  "items" => [
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/scopes/task_targets/1",
#       "name" => "1",
#       "tasks" => [
#         "package::install",
#         "exec"
#       ],
#       "all_tasks" => "false",
#       "nodes" => [
#         "wss6c3w9wngpycg",
#         "jjj2h5w8gpycgwn"
#       ],
#       "node_groups" => [
#         "3c4df64f-7609-4d31-9c2d-acfa52ed66ec",
#         "4932bfe7-69c4-412f-b15c-ac0a7c2883f1"
#       ],
#       "pql_query" => "nodes[certname] { catalog_environment = \"production\" }"
#     },
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/scopes/task_targets/2",
#       "name" => "2",
#       "tasks" => [
#         "imaginary::task"
#       ],
#       "all_tasks" => "false",
#       "nodes" => [
#         "mynode"
#       ],
#       "node_groups" => [
#       ]
#     },
#     {
#       "id" => "https://orchestrator.example.com:8143/orchestrator/v1/scopes/task_targets/3",
#       "name" => "3",
#       "all_tasks" => true,
#       "nodes" => [
#         "xxx6c3w9wngpycg",
#         "bbb2h5w8gpycgwn"
#       ],
#       "node_groups" => [
#         "3c4df64f-7609-4d31-9c2d-acfa52ed66ec",
#         "4932bfe7-69c4-412f-b15c-ac0a7c2883f1"
#       ]
#     }
#   ]
# }
```

### GET /scopes/task_targets/\<task-target-id>

[Reference](https://help.puppet.com/pe/current/topics/orchestrator_api_get_scopes_task_targets_id.htm)

Get information about a specific task-target.

```ruby
client.orchestrator_v1.scopes.get(task_target_id: "1")
# => {
#   "id" => "https://orchestrator.example.com:8143/orchestrator/v1/scopes/task_targets/1",
#   "name" => "1",
#   "tasks" => [
#     "package::install",
#     "exec"
#   ],
#   "all_tasks" => "false",
#   "nodes" => [
#     "wss6c3w9wngpycg",
#     "jjj2h5w8gpycgwn"
#   ],
#   "node_groups" => [
#     "3c4df64f-7609-4d31-9c2d-acfa52ed66ec",
#     "4932bfe7-69c4-412f-b15c-ac0a7c2883f1"
#   ],
#   "pql_query" => "nodes[certname] { catalog_environment = \"production\" }"
# }
```
