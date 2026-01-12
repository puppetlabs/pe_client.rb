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

require_relative "base_with_port"

module PEClient
  module Resource
    # The role-based access control (RBAC) API v2 service enables you to fetch information about users, create groups, revoke tokens, validate tokens, and get information about your LDAP directory service.
    # The v2 endpoints either extend or replace some RBAC API v1 endpoints.
    #
    # @see https://help.puppet.com/pe/current/topics/rbac_api_v2_endpoints.htm
    class RBACV2 < BaseWithPort
      # The base path for RBAC API v2 endpoints.
      BASE_PATH = "/rbac-api/v2"

      # Default RBAC API Port
      PORT = 4433

      # @return [PEClient::Resource::RBACV2::Users]
      def users
        require_relative "rbac.v2/users"
        @users ||= RBACV2::Users.new(@client)
      end

      # @return [PEClient::Resource::RBACV2::Groups]
      def groups
        require_relative "rbac.v2/groups"
        @groups ||= RBACV2::Groups.new(@client)
      end

      # @return [PEClient::Resource::RBACV2::Tokens]
      def tokens
        require_relative "rbac.v2/tokens"
        @tokens ||= RBACV2::Tokens.new(@client)
      end

      # @return [PEClient::Resource::RBACV2::LDAP]
      def ldap
        require_relative "rbac.v2/ldap"
        @ldap ||= RBACV2::LDAP.new(@client)
      end
    end
  end
end
