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
    # The activity service records changes to role-based access control (RBAC) entities, such as users, directory groups, and user roles.
    # Use the activity service API to query event data.
    #
    # @see https://help.puppet.com/pe/2025.6/topics/activity_api.htm
    class ActivityV2 < BaseWithPort
      # The base path for Activity API v2 endpoints.
      BASE_PATH = "/activity-api/v2"

      # Default Activity API Port
      PORT = 4433

      # Fetches information about events the activity service tracks.
      # Allows filtering through query parameters and supports multiple objects for filtering results.
      #
      # @param service_id [String] The ID of the service you want to query.
      #   If omitted, all services are queried.
      # @param offset [Integer] Specify a zero-indexed integer to retrieve activity records starting from the offset point.
      #   If omitted, the default is 0.
      #   This parameter is useful for omitting initial, irrelevant results, such as test data.
      # @param order [String] Specify, whether records are returned in ascending ("asc") or descending ("desc") order.
      #   If omitted, the default is "desc".
      #   Sorting is based on the activity record's submission time.
      # @param limit [Integer] Specify a positive integer to limit the number of user records returned.
      #   If omitted, the default is 1000 events.
      # @param query [Array<Hash{Symbol, String => String}>]
      # @option query [String] :subject_id Limit the query to the subject (a user) with the specified ID.
      #   If `:subject_type` is omitted, the type is assumed to be users.
      #   Currently, users is the only available `:subject_type`.
      # @option query [String] :subject_type Optional, but if included, you must also include `:subject_id`. Refer to `:subject_id` for more information.
      # @option query [String] :object_type Limit the activity query to a specific object type (which is the target of activities).
      #   Use `:object_id` to further limit the query to a specific ID within the specified type.
      # @option query [String] :object_id An ID associated with a defined object type.
      #   If supplied, then `:object_type` is required.
      # @option query [String] :ip_address Specifies an IP address associated with activities.
      #   Supports partial string matching.
      # @option query [String] :start Supply a timestamp in ISO-8601 format.
      #   Must be used with `:end` to fetch results within a specific service commit time range.
      # @option query [String] :end Supply a timestamp in ISO-8601 format.
      #   Must be used with `:start` to fetch results within a specific service commit time range.
      #
      # @return [Hash]
      def events(service_id: nil, offset: nil, order: nil, limit: nil, query: nil)
        @client.get "#{BASE_PATH}/events", params: {service_id:, offset:, order:, limit:, query: query&.to_json}.compact
      end
    end
  end
end
