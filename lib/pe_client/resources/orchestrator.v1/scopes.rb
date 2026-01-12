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
      # Use the scopes endpoints to retrieve information about task-targets.
      #
      # @see https://help.puppet.com/pe/current/topics/orchestrator_api_scopes_endpoint.htm
      class Scopes < Base
        # The base path for OrchestratorV1 API v1 Scopes endpoints.
        BASE_PATH = "#{OrchestratorV1::BASE_PATH}/scopes/task_targets".freeze

        # Retrieve information about all orchestrator task-targets.
        # Or Get information about a specific task-target.
        #
        # @param task_target_id [String]
        #
        # @return [Hash]
        def get(task_target_id: nil)
          if task_target_id
            @client.get "#{BASE_PATH}/#{task_target_id}"
          else
            @client.get BASE_PATH
          end
        end
      end
    end
  end
end
