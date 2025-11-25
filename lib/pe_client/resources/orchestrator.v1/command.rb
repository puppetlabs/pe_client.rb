# frozen_string_literal: true

# Copyright 2025 Perforce Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative "../base"

module PEClient
  module Resource
    class OrchestratorV1
      # Use the command endpoints to run Puppet, jobs, and plans on demand or stop in-progress jobs.
      # You can also create task-targets, which provide privilege escalation for users who would otherwise not be able to run certain tasks or run tasks on certain nodes or node groups.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/orchestrator_api_commands_endpoint.htm
      class Command < Base
        # The base path for OrchestratorV1 API v1 Command endpoints.
        BASE_PATH = "#{OrchestratorV1::BASE_PATH}/command".freeze

        # Run Puppet on demand – run the orchestrator across all nodes in an environment.
        #
        # @param environment [String] The name of the environment to deploy or an empty string.
        #   If you supply an empty string, you must set enforce_environment to false.
        # @param scope [Hash{Symbol, String => Any}] Contains exactly one key defining the deployment target:
        #   "nodes" => A list of node names to target.
        #   "query" => A PuppetDB or PQL query to use to discover nodes. The target is built from certname values collected at the top level of the query.
        #   "node_group" =>  The ID of a classifier node group that has defined rules. The node group itself must have defined rules – It is not sufficient for only the node group's parent groups to define rules. The user submitting the request must also have permissions to view the specified node group.
        #   Required if environment is an empty string.
        # @param concurrency [Integer] The maximum number of nodes to run at one time.
        #   The default is a range between 1 and the value of the global_concurrent_compiles parameter.
        #   For information about global_concurrent_compiles, refer to (Orchestrator and pe-orchestration-services parameters)[https://help.puppet.com/pe/2025.6/topics/config_orchestration_services.htm].
        # @param debug [Boolean] Whether to use the --debug flag on Puppet agent runs.
        # @param description [String] A description of the job.
        # @param enforce_environment [Boolean] Whether to force agents to run in the specified environment.
        #   This key must be false if environment is an empty string.
        # @param evaltrace [Boolean] Whether to use the --evaltrace flag on Puppet agent runs.
        # @param filetimeout [Integer] The value for the --filetimeout flag on Puppet agent runs.
        # @param http_connect_timeout [Integer] The value for the --http_connect_timeout flag on Puppet agent runs.
        # @param http_keepalive_timeout [Integer] The value for the --http_keepalive_timeout flag on Puppet agent runs.
        # @param http_read_timeout [Integer] The value for the --http_read_timeout flag on Puppet agent runs.
        # @param noop [Boolean] Whether to run the agent in no-op mode.
        #   The default is false.
        # @param no_noop [Boolean] Whether to run the agent in enforcement mode.
        #   The default is false.
        #   This flag overrides noop = true if set in the agent's puppet.conf file.
        #   This flag can't be set to true if the noop flag is also set to true.
        # @param ordering [String] Sets the --ordering flag on Puppet agent runs.
        # @param skip_tags [String] Sets the --skip_tags flag on Puppet agent runs.
        # @param tags [String] Sets the --tags flag on Puppet agent runs.
        # @param timeout [Integer] The maximum number of seconds a deploy job can take to execute on any individual node.
        #   Job execution on a node is forcibly ended if the timeout limit is reached.
        #   If unspecified, this key takes the value of default-deploy-node-timeout, which is one of the (Orchestrator and pe-orchestration-services parameters)[https://help.puppet.com/pe/2025.6/topics/config_orchestration_services.htm].
        # @param trace [Boolean] Whether to use the --trace flag on Puppet agent runs.
        # @param use_cached_catalog [Boolean] Whether to use the --use_cached_catalog flag on Puppet agent runs.
        # @param usecacheonfailure [Boolean] Whether to use the --usecacheonfailure flag on Puppet agent runs.
        # @param userdata [Hash{Symbol, String => Any}] Arbitrary key/value data supplied to the job.
        #
        # @return [Hash]
        def deploy(environment:, scope: nil, concurrency: nil, debug: nil, description: nil, enforce_environment: nil,
          evaltrace: nil, filetimeout: nil, http_connect_timeout: nil, http_keepalive_timeout: nil, http_read_timeout: nil,
          noop: nil, no_noop: nil, ordering: nil, skip_tags: nil, tags: nil, timeout: nil, trace: nil,
          use_cached_catalog: nil, usecacheonfailure: nil, userdata: nil)
          @client.post("#{BASE_PATH}/deploy", body: {
            environment:, scope:, concurrency:, debug:, description:, enforce_environment:, evaltrace:, filetimeout:,
            http_connect_timeout:, http_keepalive_timeout:, http_read_timeout:, noop:, no_noop:, ordering:, skip_tags:,
            tags:, timeout:, trace:, use_cached_catalog:, usecacheonfailure:, userdata:
          }.compact)
        end

        # Stop an orchestrator job that is currently in progress.
        #
        # @param job [String] The ID of the job to stop.
        # @param force [Boolean] Whether to forcibly stop the job.
        #
        # @return [Hash]
        def stop(job:, force: nil)
          @client.post("#{BASE_PATH}/stop", body: {job:, force:}.compact)
        end

        # Stop an orchestrator plan job that is currently in progress.
        # This command interrupts the thread that is running the plan.
        # If the plan doesn't have code to explicitly handle the interrupt, the plan finishes with an error.
        # If the plan can handle the interrupt, whether or not the plan stops depends on the plan's interruption handling.
        # If the plan is running a task (or otherwise) when interrupted, an error occurs and the plan stops, but the underlying in-progress task job finishes.
        # If you need to force stop an in-progress job, use {#stop}.
        #
        # @param plan_job [String] The ID of the plan job to stop.
        #
        # @return [Hash]
        def stop_plan(plan_job:)
          @client.post("#{BASE_PATH}/stop_plan", body: {plan_job:})
        end

        # Run a task on a set of nodes.
        # The task does not run on any nodes in the defined scope that you do not have permission to run tasks on.
        #
        # @param environment [String] The name of the environment to load the task from.
        #   The default is production.
        # @param scope [Hash{Symbol, String => Any}] Contains exactly one key defining the nodes to run the task on:
        #   "nodes" => An array of node names to target.
        #   "query" => A PuppetDB or PQL query to use to discover nodes. The target is built from certname values collected at the top level of the query.
        #   "node_group" => The ID of a classifier node group that has defined rules. The node group itself must have defined rules – It is not sufficient for only the node group's parent groups to define rules. The user submitting the request must also have permissions to view the specified node group.
        #   The task does not run on any nodes specified in the scope that the user does not have permission to run the task on.
        # @param params [Hash{Symbol, String => Any}] Parameters to pass to the task. Can be an empty object.
        # @param targets [Array<Hash{Symbol, String => Any}>] A collection of keys used to run the task on nodes through SSH or WinRM via Bolt server, such as user account information, run-as specifications, or a designated temporary directory.
        # @param task [String] The task to run on the target nodes.
        #   Use the {Tasks#get} to get task names.
        # @param timeout [Integer] The maximum number of seconds a task can take to execute on any individual node.
        #   Task execution on a node is forcibly ended if the timeout limit is reached.
        #   If unspecified, this key takes the value of default-task-node-timeout, which is one of the (Orchestrator and pe-orchestration-services parameters)[https://help.puppet.com/pe/2025.6/topics/config_orchestration_services.htm].
        # @param description [String] A description of the job.
        # @param noop [Boolean] Whether to run the job in no-op mode.
        #   The default is false.
        # @param userdata [Hash{Symbol, String => Any}] Arbitrary key/value data supplied to the job.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/2025.6/topics/orchestrator_api_post_command_task.htm
        def task(environment:, scope:, params:, targets:, task:, timeout: nil, description: nil, noop: nil, userdata: nil)
          @client.post("#{BASE_PATH}/task", body: {
            environment:, scope:, params:, targets:, task:, timeout:, description:, noop:, userdata:
          }.compact)
        end

        # Create a task-target, which is a set of tasks and nodes/node groups you can use to provide specific privilege escalation for users who would otherwise not be able to run certain tasks or run tasks on certain nodes or node groups.
        # When you grant a user permission to use a task-target, the user can run the task(s) in the task-target on the set of nodes defined in the task-target.
        #
        # @param display_name [String] The task-target name.
        #   There are no uniqueness requirements.
        # @param tasks [Array<String>] You must specify either tasks or all_tasks.
        #   If you want to include specific tasks in the task-target, use tasks to supply an array of relevant task names.
        #   This key can be empty.
        #   If tasks is omitted or empty, you must set all_tasks to true.
        #   This key is required if all_tasks is omitted.
        # @param all_tasks [Boolean] You must specify either tasks or all_tasks.
        #   all_tasks indicates whether any tasks can be run on designated node targets.
        #   The default is false and expects you to define specific tasks in the tasks key. However:
        #     If tasks is omitted or empty, you must set all_tasks to true.
        #     If all_tasks is omitted, you must provide a valid tasks key.
        #     If all_tasks is true, omit tasks. If you specify tasks and set all_tasks to true, the endpoint ignores tasks and takes the all_tasks value.
        # @param nodes [Array<String>] Use nodes, node_groups, and pql_query to identify nodes users can run tasks against when using this task-target.
        #   The endpoint combines these keys to form a total node pool.
        #   If you specified tasks, the user can run only those specific tasks against the specified nodes.
        #   `nodes` must be either empty array or an array of certnames identifying specific agent nodes or agentless nodes to associate with this task-target.
        # @param node_groups [Array<String>] Use nodes, node_groups, and pql_query to identify nodes users can run tasks against when using this task-target.
        #   The endpoint combines these keys to form a total node pool.
        #   If you specified tasks, the user can run only those specific tasks against the specified nodes.
        #   `node_groups` must be either an empty array or an array of node group IDs describing node groups associated with this task-target.
        # @param pql_query [String] Use `nodes`, `node_groups`, and `pql_query` to identify nodes users can run tasks against when using this task-target.
        #   The endpoint combines these keys to form a total node pool.
        #   If you specified tasks, the user can run only those specific tasks against the specified nodes.
        #   `pql_query` is an optional string specifying a single PQL query to use to fetch nodes for this task-target.
        #   Query results must contain the certnames key to identify the nodes.
        #
        # @return [Hash]
        #
        # @note While `pql_query` is optional, if you only use `pql_query` to define the nodes in the task-target, you must supply nodes and node_groups as empty arrays.
        def task_target(display_name:, tasks: nil, all_tasks: nil, nodes: [], node_groups: [], pql_query: nil)
          raise ArgumentError, "Either `tasks` or `all_tasks` must be provided" if tasks.nil? && all_tasks.nil?

          @client.post("#{BASE_PATH}/task_target", body: {
            display_name:, tasks:, all_tasks:, nodes:, node_groups:, pql_query:
          }.compact)
        end

        # Use the plan executor to run a plan.
        #
        # @param plan_name [String] The name of the plan to run.
        # @param params [Hash{Symbol, String => Any}] The parameters you want the plan to use.
        # @param environment [String] The environment to load the plan from.
        #   The default is production.
        # @param description [String] A description of the plan job.
        # @param timeout [Integer] The maximum number of seconds allowed for the plan to run. Reaching the timeout limit cancels queued plan actions and attempts to interrupt in-progress actions.
        #   If unspecified, this key takes the value of default-plan-timeout, which is one of the (Orchestrator and pe-orchestration-services parameters)[https://help.puppet.com/pe/2025.6/topics/config_orchestration_services.htm].
        # @param userdata [Hash{Symbol, String => Any}] Arbitrary key/value data supplied to the job.
        #
        # @return [Hash]
        def plan_run(plan_name:, params: nil, environment: nil, description: nil, timeout: nil, userdata: nil)
          @client.post("#{BASE_PATH}/plan_run", body: {
            plan_name:, params:, environment:, description:, timeout:, userdata:
          }.compact)
        end

        # Use parameters to run a plan on specific nodes in a specific environment.
        #
        # @param plan_name [String] The name of the plan to run.
        # @param params [Hash{Symbol, String => Any}] The parameters you want the plan to use.
        #   Use the type key to identify whether a parameter is a query or a node group.
        # @param environment [String] The environment to load the plan from.
        #   The default is production.
        # @param description [String] A description of the plan job.
        # @param timeout [Integer] The maximum number of seconds allowed for the plan to run. Reaching the timeout limit cancels queued plan actions and attempts to interrupt in-progress actions.
        #   If unspecified, this key takes the value of default-plan-timeout, which is one of the (Orchestrator and pe-orchestration-services parameters)[https://help.puppet.com/pe/2025.6/topics/config_orchestration_services.htm].
        # @param userdata [Hash{Symbol, String => Any}] Arbitrary key/value data supplied to the job.
        #
        # @return [Hash]
        def environment_plan_run(plan_name:, params:, environment: nil, description: nil, timeout: nil, userdata: nil)
          @client.post("#{BASE_PATH}/environment_plan_run", body: {
            plan_name:, params:, environment:, description:, timeout:, userdata:
          }.compact)
        end
      end
    end
  end
end
