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
      # Use the inventory endpoints to check whether the orchestrator can reach a node.
      #
      # @see https://help.puppet.com/pe/current/topics/orchestrator_api_inventory.endpoint.htm
      class Inventory < Base
        # The base path for OrchestratorV1 API v1 Inventory endpoints.
        BASE_PATH = "#{OrchestratorV1::BASE_PATH}/inventory".freeze

        # Retrieve a list of all nodes connected to the Puppet Communications Protocol (PCP) broker.
        # Or Retrieve information about a single node's connection.
        #
        # @param node [String] The node to check connectivity for.
        #
        # @return [Hash]
        def get(node = nil)
          if node
            @client.get("#{BASE_PATH}/#{node}")
          else
            @client.get(BASE_PATH)
          end
        end

        # Returns information about multiple nodes' connections to the Puppet Communications Protocol (PCP) broker.
        #
        # @param nodes [Array<String>]
        #
        # @return [Hash]
        def get_multiple(nodes)
          @client.post(BASE_PATH, body: {nodes:})
        end
      end
    end
  end
end
