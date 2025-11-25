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
      # Use the group-children endpoint to retrieve a list of node groups descending from a specific node group.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/group_children_endpoint.htm
      class GroupChildren < Base
        # The base path for Node Classifier API v1 group children endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/group-children".freeze

        # Retrieve a list of node groups descending from a specific node group,
        #
        # @param id [String]
        # @param depth [Integer] optional depth parameter to limit how many levels of descendants are returned.
        #   For example, depth: 2 limits the response to the group's immediate children and first grandchildren.
        #   If depth: 0 the response only returns the base group and no children or grandchildren.
        #
        # @return [Array<Hash>]
        def get(id, depth: nil)
          @client.get "#{BASE_PATH}/#{id}", params: {depth:}.compact
        end
      end
    end
  end
end
