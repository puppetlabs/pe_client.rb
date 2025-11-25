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
      # Use the tasks endpoints to get information about tasks you've installed and tasks included with Puppet Enterprise (PE).
      #
      # @see https://help.puppet.com/pe/2025.6/topics/orchestrator_api_tasks_endpoint.htm
      class Tasks < Base
        # The base path for OrchestratorV1 API v1 Tasks endpoints.
        BASE_PATH = "#{OrchestratorV1::BASE_PATH}/tasks".freeze

        # Lists all tasks in a specific environment.
        # Or get information about a specific task, including metadata and file information.
        #
        # @param module_name [String]
        # @param task_name [String]
        # @param environment [String] The environment from which to retrieve tasks.
        #   Defaults to "production".
        #
        # @return [Hash]
        def get(module_name: nil, task_name: nil, environment: nil)
          if module_name && task_name
            @client.get "#{BASE_PATH}/#{module_name}/#{task_name}", params: {environment:}.compact
          else
            @client.get BASE_PATH, params: {environment:}.compact
          end
        end
      end
    end
  end
end
