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
      # Use the update-classes endpoint to trigger the node classifier to get updated class and environment definitions from the primary server.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/update_classes_endpoint.htm
      class UpdateClasses < Base
        # The base path for Node Classifier API v1 update classes endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/update-classes".freeze

        # Trigger the node classifier to retrieve updated class and environment definitions from the primary server.
        # The classifier service also uses this endpoint when you refresh classes in the console.
        #
        # @param environment [String, nil]
        #
        # @return [Hash] If the request is successful, the response body is empty.
        def update(environment: nil)
          @client.post BASE_PATH, params: {environment:}.compact
        end
      end
    end
  end
end
