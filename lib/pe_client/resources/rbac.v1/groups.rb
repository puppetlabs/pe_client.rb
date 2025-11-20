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
      # User groups allow you to quickly assign one or more roles to a set of users by placing all relevant users in the group.
      # This is more efficient than assigning roles to each user individually.
      # Use the groups endpoints to get lists of groups and add, delete, and change groups.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/rbac_api_v1_user_group.htm
      class Groups < Base
        # The base path for RBAC API v1 Groups endpoints.
        BASE_PATH = "#{RBACV1::BASE_PATH}/groups".freeze

        # The base path for RBAC API v1 Groups command endpoints.
        COMMAND_BASE_PATH = "#{RBACV1::BASE_PATH}/command/groups".freeze

        # Fetch information about all user groups.
        # if a SID is provided, fetch information about that specific group.
        #
        # @param sid [String, nil] The Subject ID of the group. If nil, retrieves all groups.
        #
        # @return [Hash]
        def get(sid = nil)
          path = sid ? "#{BASE_PATH}/#{sid}" : BASE_PATH
          @client.get path
        end

        # Create a remote directory user group.
        #
        # @param login [String] Defines the group for an external IdP, such as an LDAP login or a SAML identifier for the group.
        # @param role_ids [Array<String>] An array of IDs defining the roles that you want to assign to users in this group.
        #   Roles grant permissions to group members.
        # @param identity_provider_id [String] Specify the UUID of an identity provider to bind to the group.
        # @param display_name [String, nil] Specify a name for the group that is visible in the PE console.
        #   If this group originates from an LDAP group, this value is determined by the group's Display name setting in LDAP.
        #
        # @return [Hash]
        def create(login:, role_ids:, identity_provider_id:, display_name: nil)
          @client.post COMMAND_BASE_PATH, body: {login:, role_ids:, identity_provider_id:, display_name:}.compact
        end

        # Edit the content of the specified user group object. For example, you can update the group's roles or membership.
        #
        # @param sid [String] The Subject ID of the group to update.
        # @param attributes [Hash] A hash of attributes to update for the group.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/2025.6/topics/rbac_api_v1_user_group_keys.htm
        def edit(sid, attributes)
          @client.put "#{BASE_PATH}/#{sid}", body: attributes
        end

        # Deletes the user group with the specified ID from PE RBAC.
        # This endpoint does not change the directory service.
        #
        # @param sid [String] The Subject ID of the group to delete.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def delete(sid)
          @client.delete "#{BASE_PATH}/#{sid}"
        end

        # Creates a new remote directory user group.
        #
        # @deprecated Use {#create} instead.
        #
        # @param login [String] Defines the group for an external IdP. This could be an LDAP login or a SAML identifier for the group.
        # @param role_ids [Array<String>] An array of role IDs defining the roles that you want to assign to users in this group.
        #   An empty array might be valid, but users can't do anything in PE if they are not assigned to any roles.
        #
        # @return [Hash]
        def create_deprecated(login, role_ids)
          PEClient.deprecated "create_deprecated", "create"
          @client.post COMMAND_BASE_PATH, {login:, role_ids:}
        end
      end
    end
  end
end
