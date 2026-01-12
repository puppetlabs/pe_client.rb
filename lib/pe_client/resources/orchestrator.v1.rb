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

require_relative "base_with_port"

module PEClient
  module Resource
    # You can use the orchestrator API to run jobs and plans on demand; schedule tasks and plans; get information about jobs, plans, and events; track node usage; and more.
    #
    # @see https://help.puppet.com/pe/current/topics/orchestrator_api_v1_endpoints.htm
    class OrchestratorV1 < BaseWithPort
      # The base path for Orchestrator API v1 endpoints.
      BASE_PATH = "/orchestrator/v1"

      # Default Orchestrator API Port
      PORT = 8143

      # Returns metadata about the orchestrator API, along with a list of links to application management resources.
      #
      # @return [Hash]
      def get
        @client.get BASE_PATH
      end

      # Retrieves information about the orchestrator's daily node usage, Puppet events activity on nodes, and nodes that are present in PuppetDB.
      #
      # @param start_date [String] Specify the earliest date to query, in YYYY-MM-DD format.
      # @param end_date [String] Specify the latest date to query, in YYYY-MM-DD format.
      #   If you also specified `start_date`, the end_date must be greater than or equal to the `start_date`.
      # @param events [String] Specifies whether you want the response to "include" or "exclude" daily Puppet events activity.
      #   The default is "include".
      #   If set to "exclude", the response only contains node counts (total nodes and the number of nodes with and without agents).
      #   Specifically, the response omits the number of corrective changes, the number of intentional changes, the number of task runs, and the number of plan runs.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/pe/current/topics/orchestrator_api_usage_endpoint.htm
      def usage(start_date: nil, end_date: nil, events: nil)
        @client.get "#{BASE_PATH}/usage", params: {start_date:, end_date:, events:}.compact
      end

      # @return [PEClient::Resource::OrchestratorV1::Command]
      def command
        require_relative "orchestrator.v1/command"
        @command ||= OrchestratorV1::Command.new(@client)
      end

      # @return [PEClient::Resource::OrchestratorV1::Inventory]
      def inventory
        require_relative "orchestrator.v1/inventory"
        @inventory ||= OrchestratorV1::Inventory.new(@client)
      end

      # @return [PEClient::Resource::OrchestratorV1::Jobs]
      def jobs
        require_relative "orchestrator.v1/jobs"
        @jobs ||= OrchestratorV1::Jobs.new(@client)
      end

      # @return [PEClient::Resource::OrchestratorV1::ScheduledJobs]
      def scheduled_jobs
        require_relative "orchestrator.v1/scheduled_jobs"
        @scheduled_jobs ||= OrchestratorV1::ScheduledJobs.new(@client)
      end

      # @return [PEClient::Resource::OrchestratorV1::Plans]
      def plans
        require_relative "orchestrator.v1/plans"
        @plans ||= OrchestratorV1::Plans.new(@client)
      end

      # @return [PEClient::Resource::OrchestratorV1::PlanJobs]
      def plan_jobs
        require_relative "orchestrator.v1/plan_jobs"
        @plan_jobs ||= OrchestratorV1::PlanJobs.new(@client)
      end

      # @return [PEClient::Resource::OrchestratorV1::Tasks]
      def tasks
        require_relative "orchestrator.v1/tasks"
        @tasks ||= OrchestratorV1::Tasks.new(@client)
      end

      # @return [PEClient::Resource::OrchestratorV1::Scopes]
      def scopes
        require_relative "orchestrator.v1/scopes"
        @scopes ||= OrchestratorV1::Scopes.new(@client)
      end
    end
  end
end
