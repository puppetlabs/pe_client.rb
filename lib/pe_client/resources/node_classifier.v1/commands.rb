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
      # Use the commands endpoint to unpin specified nodes from all node groups they’re pinned to.
      #
      # @see https://help.puppet.com/pe/current/topics/commands_endpoint.htm
      class Commands < Base
        # The base path for Node Classifier API v1 commands endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/commands".freeze

        # Unpin one or more specific nodes from all node groups they’re pinned to.
        # Unpinning has no effect on nodes that are assigned to node groups via dynamic rules.
        #
        # @param nodes [Array<String>] Node certnames.
        #
        # @return [Hash]
        def unpin_from_all(nodes)
          @client.post "#{BASE_PATH}/unpin-from-all", body: {nodes:}
        end
      end
    end
  end
end
