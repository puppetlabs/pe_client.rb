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
    class NodeClassifierV1
      # Use the nodes endpoints to retrieve records about nodes that have checked into the node classifier.
      #
      # @see https://help.puppet.com/pe/current/topics/nodes_endpoint.htm
      class Nodes < Base
        # The base path for Node Classifier API v1 nodes endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/nodes".freeze

        # Retrieve check-in history for all nodes or a specific node that have checked in with the node classifier.
        #
        # @param node [String] The name of a specific node to retrieve check-in history for.
        #   If nil, retrieves check-in history for all nodes.
        # @param limit [Integer] The maximum number of check-in records to retrieve.
        #   Cannot be used with the `node` parameter.
        # @param offset [Integer] The number of check-in records to skip before starting to return results.
        #   Cannot be used with the `node` parameter.
        #
        # @return [Hash]
        def get(node: nil, limit: nil, offset: nil)
          if node
            @client.get "#{BASE_PATH}/#{node}"
          else
            @client.get BASE_PATH, params: {limit:, offset:}.compact
          end
        end
      end
    end
  end
end
