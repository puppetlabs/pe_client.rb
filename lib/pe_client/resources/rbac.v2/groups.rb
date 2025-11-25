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
      # User groups allow you to quickly assign one or more roles to a set of users by placing all relevant users in the group.
      # This is more efficient than assigning roles to each user individually.
      # The v2 {#create} has additional optional parameters you can use when creating groups.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/rbac-api-v2-user-group.htm
      class Groups < Base
        # The base path for RBAC API v2 Groups endpoints.
        BASE_PATH = "#{RBACV2::BASE_PATH}/groups".freeze

        # Create a new remote directory user group.
        #
        # @deprecated Use {RBACV1::Groups#create} instead.
        #
        # @param login [String] Defines the group for an external IdP.
        #   This could be an LDAP login or a SAML identifier for the group.
        # @param role_ids [Array<String>] An array of role IDs defining the roles that you want to assign to users in this group.
        #   An empty array might be valid, but users can't do anything in PE if they are not assigned to any roles.
        # @param display_name [String] Specify a name for the group as you want it to appear in the PE console.
        #   If the group you're creating originates from an LDAP group, the LDAP group's Display name setting overrides this parameter.
        # @param identity_provider_id [String] Specify the UUID of an identity provider (SAML or LDAP) to bind to the group.
        # @param validate [Boolean] Specifying whether you want to validate if the group exists on the LDAP server prior to creating it.
        #   The default is true.
        #   Set this to false if you don't want to validate the group's existence in LDAP.
        #
        # @return [Hash{String => String}]
        def create(login:, role_ids:, display_name: nil, identity_provider_id: nil, validate: nil)
          PEClient.deprecated "create", "RBACV1::Groups#create"
          @client.post BASE_PATH, body: {login:, role_ids:, display_name:, identity_provider_id:, validate:}.compact
        end
      end
    end
  end
end
