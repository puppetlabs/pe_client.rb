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
      # User roles contain sets of permissions.
      # When you assign a user (or a user group) to a role, you can assign the entire set of permissions at once.
      # This is more organized and easier to manage than assigning individual permissions to individual users.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_user_role.htm
      class Roles < Base
        # The base path for RBAC API v1 Roles endpoints.
        BASE_PATH = "#{RBACV1::BASE_PATH}/roles".freeze

        # The base path for RBAC API v1 Roles command endpoints.
        COMMAND_BASE_PATH = "#{RBACV1::BASE_PATH}/command/roles".freeze

        # Fetches information about all user roles.
        #
        # @param rid [String] The Role ID of the group. If nil, retrieves all groups.
        #
        # @return [Hash]
        def get(rid = nil)
          path = rid ? "#{BASE_PATH}/#{rid}" : BASE_PATH
          @client.get path
        end

        # Create a role.
        #
        # @param permissions [Array<String>] An array of permission objects (consisting of sets of object_type, action, and instance) defining the permissions associated with this role.
        #   Required, but can be empty. An empty array means no permissions are associated with the role.
        # @param group_ids [Array<String>] An array of group IDs defining the user groups you want to assign this role to.
        #   All users in the groups (or added to the groups in the future) receive this role through their group membership.
        #   Required, but can be empty. An empty array means the role is not assigned to any groups.
        # @param user_ids [Array<String>] An array of user IDs defining the individual users that you want to assign this role to.
        #   You do not need to repeat any users who are part of a group mentioned in group_ids.
        #   Required, but can be empty. An empty array means the role is not assigned to any individual users
        # @param display_name [String] A string naming the role.
        # @param description [String] A string describing the role's purpose.
        #
        # @return [Hash]
        def create(permissions:, group_ids:, user_ids:, display_name:, description: nil)
          @client.post BASE_PATH, body: {permissions:, group_ids:, user_ids:, display_name:, description:}.compact
        end

        # Replaces the content of the specified role object.
        # For example, you can update the role's permissions or user membership.
        #
        # @param rid [String] The Role ID of the role to update.
        # @param attributes [Hash] A hash of attributes to update for the role.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_user_role_post_roles.htm#Requestformat
        def edit(rid, attributes)
          @client.put "#{BASE_PATH}/#{rid}", body: attributes
        end

        # Deletes the role with the specified role ID.
        # Users who had this role (either directly or through a user group) immediately lose the role and all permissions granted by it, but their session is otherwise unaffected.
        # The next action the user takes in PE is determined by their permissions without the deleted role.
        #
        # @param rid [String] The Role ID of the role to delete.
        #
        # @return [Hash]
        def delete(rid)
          @client.delete "#{BASE_PATH}/#{rid}"
        end

        # Assign a role to one or more users.
        #
        # @param role_id [String] The ID of the role you want to assign users to.
        # @param user_ids [Array<String>] An array of user IDs defining the users that you want to assign to the role.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def add_users(role_id, user_ids)
          @client.post "#{COMMAND_BASE_PATH}/add-users", body: {role_id:, user_ids:}
        end

        # Remove a role from one or more users.
        #
        # @param role_id [String] The ID of the role you want to remove users from.
        # @param user_ids [Array<String>] An array of user IDs defining the users that you want to remove from the role.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        #
        # @note A request with an invalid role_id still returns no content even though no users were removed from the nonexistent role.
        def remove_users(role_id, user_ids)
          @client.post "#{COMMAND_BASE_PATH}/remove-users", body: {role_id:, user_ids:}
        end

        # Add a role to one or more user groups.
        #
        # @param role_id [String] The ID of the role you want to assign to groups.
        # @param group_ids [Array<String>] An array of user group IDs defining the groups that you want to assign the role to.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def add_groups(role_id, group_ids)
          @client.post "#{COMMAND_BASE_PATH}/add-groups", body: {role_id:, group_ids:}
        end

        # Remove a role from one or more user groups.
        #
        # @param role_id [String] The ID of the role you want to remove groups from.
        # @param group_ids [Array<String>] An array of user group IDs defining the groups that you want to remove the role from.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def remove_groups(role_id, group_ids)
          @client.post "#{COMMAND_BASE_PATH}/remove-groups", body: {role_id:, group_ids:}
        end

        # Add permissions to a role.
        #
        # @param role_id [String] The ID of the role you want to add permissions to.
        # @param permissions [Array<Hash>] An array of permissions objects describing the permissions to add to the role.
        #   Permissions objects consist of sets of "object_type", "action", and "instance".
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def add_permissions(role_id, permissions)
          @client.post "#{COMMAND_BASE_PATH}/add-permissions", body: {role_id:, permissions:}
        end

        # Remove permissions from a role.
        #
        # @param role_id [String] The ID of the role you want to remove permissions from.
        # @param permissions [Array<Hash>] An array of permissions objects describing the permissions to remove from the role.
        #   Permissions objects consist of sets of "object_type", "action", and "instance".
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def remove_permissions(role_id, permissions)
          @client.post "#{COMMAND_BASE_PATH}/remove-permissions", body: {role_id:, permissions:}
        end
      end
    end
  end
end
