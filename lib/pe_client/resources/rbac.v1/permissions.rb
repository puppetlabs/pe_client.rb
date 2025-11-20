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
      # You add permissions to roles to control what users can access and do in PE.
      # Use the permissions endpoints to get information about objects you can create permissions for, what types of permissions you can create, and whether specific users can perform certain actions.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/rbac_api_v1_permissions.htm
      class Permissions < Base
        # The base path for RBAC API v1 Permissions endpoints.
        BASE_PATH = "#{RBACV1::BASE_PATH}/permitted".freeze

        # Lists each object_type that you can regulate with RBAC permissions, the available actions for each type, and whether each action allows instance specification.
        #
        # @return [Array<Hash>]
        def types
          @client.get "/types"
        end

        # Query whether a user or user group can perform specified actions.
        # Use this to check if a user or group already has a certain permission.
        #
        # @param token [String] The UUID of a user or user group.
        # @param permissions [Array<Hash>] An array of JSON objects representing permissions.
        #   Each permissions object includes the object_type, action, and instance keys.
        #   For more information about these keys and how to populate them, see [Permissions](https://help.puppet.com/pe/2025.6/topics/rbac_api_v1_permissions_keys.htm).
        #
        # @return [Array<Boolean>] The response array has the same length as the request's permissions array.
        #   Each returned Boolean value corresponds to the submitted permission query at the same index.
        #   For example, if you query two permissions, the response array contains two values, such as:
        #     `[true, false]`
        def permitted(token:, permissions:)
          @client.post BASE_PATH, body: {token:, permissions:}
        end

        # For a specific object_type and action, get a list of instance IDs that the current authenticated user is permitted to take the specified action on.
        #
        # @param object_type [String] Name of an object type.
        # @param action [String] Applicable action for the object type.
        #
        # @return [Array<String>] An array of instance IDs that the authenticated user is permitted to perform the supplied action on.
        def instances(object_type:, action:)
          @client.get "#{BASE_PATH}/#{object_type}/#{action}"
        end

        # For a specific object_type and action, get a list of instance IDs that the specific user (identified by UUID) is permitted to take the specified action on.
        #
        # @param object_type [String] Name of an object type.
        # @param action [String] Applicable action for the object type.
        # @param uuid [String]
        #
        # @return [Array<String>] An array of instance IDs that the specified user is permitted to perform the supplied action on.
        def user_instances(object_type:, action:, uuid:)
          @client.get "#{BASE_PATH}/#{object_type}/#{action}/#{uuid}"
        end
      end
    end
  end
end
