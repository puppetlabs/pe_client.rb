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
    # @see https://help.puppet.com/pe/current/topics/activity_api.htm
    class ActivityV1 < BaseWithPort
      # The base path for Activity API v1 endpoints.
      BASE_PATH = "/activity-api/v1"

      # Default Activity API Port
      PORT = 4433

      # Fetch information about events the activity service tracks.
      #
      # @param service_id [String] The ID of the service you want to query.
      # @param subject_type [String] Limit the activity query to a specific subject type (which is the actor of the activity).
      #   Use `subject_id` to further limit the query to specific IDs within the specified type.
      #   For example, you can query all user activities or specific users' activities.
      # @param subject_id [Array<String>] List of IDs associated with the defined subject type.
      #   Optional, but, if supplied, then subject_type is required.
      # @param object_type [String] Limit the activity query to a specific object type (which is the target of activities).
      #   Use `object_id` to further limit the query to specific IDs within the specified type.
      # @param object_id [Array<String>] List of IDs associated with the defined object type.
      #   Optional, but, if supplied, then object_type is required.
      # @param offset [Integer] Specify a zero-indexed integer to retrieve activity records starting from the offset point.
      #   If omitted, the default is 0.
      #   This parameter is useful for omitting initial, irrelevant results, such as test data.
      # @param order [String]  	Specify, whether records are returned in ascending ("asc") or descending ("desc") order.
      #   If omitted, the default is "desc".
      #   Sorting is based on the activity record's submission time.
      # @param limit [Integer] Specify a limit the number of user records returned.
      #   If omitted, the default is 1000 events.
      # @param after_service_commit_time [String] Specify a timestamp in ISO-8601 format if you want to fetch results after a specific service commit time.
      #
      # @return [Hash]
      def events(service_id:, subject_type: nil, subject_id: nil, object_type: nil, object_id: nil, offset: nil, order: nil, limit: nil, after_service_commit_time: nil)
        @client.get "#{BASE_PATH}/events", params: {service_id:, subject_type:, subject_id:, object_type:, object_id:, offset:, order:, limit:, after_service_commit_time:}.compact
      end
    end
  end
end
