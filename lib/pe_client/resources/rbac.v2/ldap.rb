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
    class RBACV2
      # Use the v2 ldap endpoints to get information about your LDAP directory service connections.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/rbac-api-v2-directory.htm
      class LDAP < Base
        # The base path for RBAC API v2 LDAP endpoints.
        BASE_PATH = "#{RBACV2::BASE_PATH}/ldap".freeze

        # Get details of configured LDAP connections.
        #
        # @param uuid [String] LDAP connection ID.
        #
        # @return [Array<Hash>, Hash]
        def get(uuid: nil)
          if uuid
            @client.get "#{BASE_PATH}/#{uuid}"
          else
            @client.get BASE_PATH
          end
        end

        # Get information about your directory service.
        #
        # @deprecated Use {#get} instead.
        #
        # @return [Array<Hash>]
        def ds
          PEClient.deprecated "ds", "get"
          @client.get "#{RBACV2::BASE_PATH}/ds"
        end
      end
    end
  end
end
