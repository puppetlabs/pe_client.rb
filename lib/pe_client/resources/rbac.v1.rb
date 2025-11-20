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
    # Role-based access control (RBAC) API v1 endpoints to manage users, directory service groups, roles, permissions, tokens, passwords, and LDAP and SAML connection settings.
    #
    # @see https://help.puppet.com/pe/2025.6/topics/rbac_api_v1.htm
    class RBACV1 < BaseWithPort
      # The base path for RBAC API v1 endpoints.
      BASE_PATH = "/rbac-api/v1"

      # Default RBAC API Port
      PORT = 4433

      # @return [PEClient::Resource::RBACV1::Users]
      def users
        require_relative "rbac.v1/users"
        @users ||= RBACV1::Users.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::Groups]
      def groups
        require_relative "rbac.v1/groups"
        @groups ||= RBACV1::Groups.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::Roles]
      def roles
        require_relative "rbac.v1/roles"
        @roles ||= RBACV1::Roles.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::Permissions]
      def permissions
        require_relative "rbac.v1/permissions"
        @permissions ||= RBACV1::Permissions.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::Tokens]
      def tokens
        require_relative "rbac.v1/tokens"
        @tokens ||= RBACV1::Tokens.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::LDAP]
      def ldap
        require_relative "rbac.v1/ldap"
        @ldap ||= RBACV1::LDAP.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::SAML]
      def saml
        require_relative "rbac.v1/saml"
        @saml ||= RBACV1::SAML.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::Passwords]
      def passwords
        require_relative "rbac.v1/passwords"
        @passwords ||= RBACV1::Passwords.new(@client)
      end

      # @return [PEClient::Resource::RBACV1::Disclaimer]
      def disclaimer
        require_relative "rbac.v1/disclaimer"
        @disclaimer ||= RBACV1::Disclaimer.new(@client)
      end
    end
  end
end
