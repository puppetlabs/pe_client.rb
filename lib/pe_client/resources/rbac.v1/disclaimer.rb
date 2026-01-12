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
    class RBACV1
      # Use these endpoints to modify the disclaimer text that appears on the Puppet Enterprise (PE) console login page.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac-api-v1-disclaimer.htm
      class Disclaimer < Base
        # The base path for RBAC API v1 Disclaimer endpoints.
        BASE_PATH = "#{RBACV1::BASE_PATH}/config/disclaimer".freeze

        # The base path for RBAC API v1 Disclaimer command endpoints.
        COMMAND_BASE_PATH = "#{RBACV1::BASE_PATH}/command/config".freeze

        # Retrieve the current disclaimer text, as specified by {#set}.
        # This endpoint does not retrieve the contents of any disclaimer.txt file.
        #
        # @return [Hash]
        def get
          @client.get(BASE_PATH)
        end

        # Change the disclaimer text that is on the PE console login page.
        #
        # @param disclaimer [String]
        #
        # @return [Hash] If the request is successful, the response body is empty.
        def set(disclaimer)
          @client.post "#{COMMAND_BASE_PATH}/set-disclaimer", body: {disclaimer:}
        end

        # Remove the disclaimer text set through POST /command/config/set-disclaimer.
        #
        # @return [Hash] If the request is successful, the response body is empty.
        def remove
          @client.post "#{COMMAND_BASE_PATH}/remove-disclaimer"
        end
      end
    end
  end
end
