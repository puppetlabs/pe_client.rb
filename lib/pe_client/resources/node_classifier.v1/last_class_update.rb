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
      # Use the last-class-update endpoint to retrieve the time that classes were last updated from the primary server.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/last_class_update_endpoint.htm
      class LastClassUpdate < Base
        # The base path for Node Classifier API v1 last class update endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/last-class-update".freeze

        # Retrieve the time that classes were last updated from the primary server.
        #
        # @return [Hash]
        def get
          @client.get BASE_PATH
        end
      end
    end
  end
end
