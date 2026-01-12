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
      # With role-based access control (RBAC), you can manage local users and remote users (created on a directory service).
      # Use the users endpoints to get lists of users, create local users, and delete, revoke, and reinstate users in PE.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_user.htm
      class Users < Base
        # The base path for RBAC API v1 Users endpoints.
        BASE_PATH = "#{RBACV1::BASE_PATH}/users".freeze

        # The base path for RBAC API v1 Users command endpoints.
        COMMAND_BASE_PATH = "#{RBACV1::BASE_PATH}/command/users".freeze

        # Get a list of all local and remote users.
        # If a user SID is provided, get details for that specific user.
        #
        # @param sid [String] The Subject ID of the user. If nil, retrieves all users.
        #
        # @return [Hash]
        def get(sid = nil)
          path = sid ? "#{BASE_PATH}/#{sid}" : BASE_PATH
          @client.get path
        end

        # Get information about the current authenticated user.
        #
        # @return [Hash]
        def current
          @client.get "#{BASE_PATH}/current"
        end

        # Get a list of tokens for a user.
        #
        # @param sid [String] The Subject ID of the user.
        # @param limit [Integer] An integer specifying the maximum number of records to return.
        #   If omitted, all records are returned.
        # @param offset [Integer] Specify a zero-indexed integer to specify the index value of the first record to return.
        #   If omitted, the default is position 0 (the first record). For example, offset=5 would start from the 6th record.
        # @param order_by [String] Specify one of the following strings to define the order in which records are returned:
        #   "creation_date", "expiration_date", "last_active_date", "client"
        #   If omitted, the default is "creation_date".
        # @param order [String] Determines the sort order as either ascending (asc) or descending (desc).
        #   If omitted, the default is asc.
        #
        # @return [Hash]
        def tokens(sid, limit: nil, offset: nil, order_by: nil, order: nil)
          @client.get "#{BASE_PATH}/#{sid}/tokens", params: {limit:, offset:, order_by:, order:}.compact
        end

        # Create a local user
        #
        # @param email [String] Specify the user's email address.
        # @param display_name [String] The user's name as you want it shown in the console.
        # @param login [String] The username for the user to use to login.
        # @param role_ids [Array<String>] An array of role IDs defining the roles that you want to assign to the new user.
        #   An empty array is valid, but the user can't do anything in PE if they are not assigned to any roles.
        # @param password [String] A password the user can use to login.
        #   For the password to work in the PE console, it must be at least six characters.
        #   This field is optional, however user accounts are not usable until a password is set.
        #   You can also use the Passwords endpoints to generate a password reset token the user can use to login for the first time.
        #
        # @return [Hash] If creation is successful, the endpoint returns an empty body.
        def create(email:, display_name:, login:, role_ids: [], password: nil)
          @client.post BASE_PATH, body: {email:, display_name:, login:, role_ids:, password:}
        end

        # Edit a local user
        #
        # @param sid [String] The Subject ID of the user to edit.
        # @param attributes [Hash] A hash of attributes to update for the user.
        #   The attributes MUST use all keys supplied in the {#get} response for the user, modified as needed to update the user.
        #   Not all attributes are editable such as `:last_login`.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_user_keys.htm
        def edit(sid, attributes)
          @client.put "#{BASE_PATH}/#{sid}", body: attributes
        end

        # Delete a user from the PE console.
        #
        # @param sid [String] The Subject ID of the user to delete.
        #
        # @return [Hash] If deletion is successful, the endpoint returns an empty body.
        def delete(sid)
          @client.delete "#{BASE_PATH}/#{sid}"
        end

        # Assign roles to a user.
        #
        # @param user_id [String] The ID of the user you want to assign roles to.
        # @param role_ids [Array<String>] An array of role IDs defining the roles that you want to assign to the user.
        #   An empty array is valid, but the user can't do anything in PE if they are not assigned to any roles.
        #
        # @return [Hash] If role assignment is successful, the endpoint returns an empty body.
        def add_roles(user_id, role_ids)
          @client.post "#{COMMAND_BASE_PATH}/command/users/add-roles", body: {user_id:, role_ids:}
        end

        # Remove roles from a user.
        #
        # @param user_id [String] The ID of the user you want to remove roles from.
        # @param role_ids [Array<String>] An array of role IDs defining the roles that you want to remove from the user.
        #
        # @return [Hash] If role removal is successful, the endpoint returns an empty body.
        def remove_roles(user_id, role_ids)
          @client.post "#{COMMAND_BASE_PATH}/command/users/remove-roles", body: {user_id:, role_ids:}
        end

        # Revoke a user's PE access.
        #
        # @param user_id [String] The ID of the user you want to revoke access for.
        #
        # @return [Hash] If revocation is successful, the endpoint returns an empty body
        def revoke(user_id)
          @client.post "#{COMMAND_BASE_PATH}/command/users/revoke", body: {user_id:}
        end

        # Reinstate a revoked user.
        #
        # @param user_id [String] The ID of the user you want to reinstate.
        #
        # @return [Hash] If reinstatement is successful, the endpoint returns an empty body.
        def reinstate(user_id)
          @client.post "#{COMMAND_BASE_PATH}/command/users/reinstate", body: {user_id:}
        end
      end
    end
  end
end
