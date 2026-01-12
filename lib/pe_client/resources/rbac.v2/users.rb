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
      # With role-based access control (RBAC), you can manage local users and remote users (created on a directory service).
      # Use the users endpoints to get lists of users, create local users, and delete, revoke, and reinstate users in PE.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_user.htm
      class Users < Base
        # The base path for RBAC API v2 Users endpoints.
        BASE_PATH = "#{RBACV2::BASE_PATH}/users".freeze

        # Fetches all users, both local and remote (including the superuser) with options for filtering and sorting response content.
        #
        # @param offset [Integer] Specify a zero-indexed integer to retrieve user records starting from the offset point.
        #   The default is 0.
        #   This parameter is useful for omitting initial, irrelevant results, such as test data.
        # @param limit [Integer] Specify a positive integer to limit the number of user records returned.
        #   The default is 500 records.
        # @param order [String] Specify, as a string, whether records are returned in ascending (asc) or descending (desc) order.
        #   The default is "asc".
        #   The order_by parameter specifies the basis for sorting.
        # @param order_by [String] Specify, as a string, what information to use to sort the records.
        #   Choose from "login", "email", "display_name", "last_login", "id", or "creation_date".
        #   The default is "id".
        # @param filter [String] Specify a case-insensitive partial string.
        #   This parameter queries the email, display_name, and login fields.
        #   For example, "example.com" searches for users with example.com in any of those three fields.
        # @param include_roles [Boolean] Specify whether you want the response to include role information.
        #   The default is false.
        #
        # @return [Hash]
        def get(offset: nil, limit: nil, order: nil, order_by: nil, filter: nil, include_roles: nil)
          @client.get BASE_PATH, params: {offset:, limit:, order:, order_by:, filter:, include_roles:}.compact
        end
      end
    end
  end
end
