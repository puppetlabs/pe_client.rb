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
    class OrchestratorV1
      # Use the plan_jobs endpoints to examine plan jobs and their details.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/orchestrator_api_plan_jobs_endpoint.htm
      class PlanJobs < Base
        # The base path for OrchestratorV1 API v1 Plan Jobs endpoints.
        BASE_PATH = "#{OrchestratorV1::BASE_PATH}/plan_jobs".freeze

        # Retrieve details about all plan jobs that the orchestrator knows about.
        # Or retrieve details of a specific plan job, including the start and end times for each job state.
        #
        # @param job_id [Integer] The ID of the plan job to retrieve.
        # @param limit [Integer] Set the maximum number of plan jobs to include in the response.
        #   The point at which the limit count starts is determined by `offset`, and the job record sort order is determined by `order_by` and `order`.
        # @param offset [Integer] Specify a zero-indexed integer at which to start returning results.
        #   For example, if you set this to 12, the response returns jobs starting with the 13th record.
        #   The default is 0.
        # @param order_by [String] Specify one of the following categories to use to sort the results: "owner", "timestamp", "environment", "name", or "state".
        #   Sorting by "owner" uses the login subfield of `owner` records.
        # @param order [String] Indicate whether results are returned in ascending ("asc") or descending ("desc") order.
        #   The default is "asc".
        # @param results [String] Whether you want the response to "include" or "exclude" plan output.
        #   The default is "include".
        # @param min_finish_timestamp [String] Returns only the plan jobs that finished at or after the supplied UTC timestamp.
        # @param max_finish_timestamp [String] Returns only the plan jobs that finished at or before the supplied UTC timestamp.
        #
        # @return [Hash]
        def get(job_id: nil, limit: nil, offset: nil, order_by: nil, order: nil, results: nil, min_finish_timestamp: nil, max_finish_timestamp: nil)
          if job_id
            @client.get "#{BASE_PATH}/#{job_id}"
          else
            @client.get BASE_PATH, params: {limit:, offset:, order_by:, order:, results:, min_finish_timestamp:, max_finish_timestamp:}.compact
          end
        end

        # Retrieve a list of events that occurred during a specific plan job.
        # Or retrieve the details of a specific event for a specific plan job.
        #
        # @param job_id [Integer] The ID of the plan job.
        # @param event_id [Integer] The ID of the event to retrieve.
        # @param start [Integer] Start the list of events from a specific event ID number.
        #   Cannot be used with `event_id`.
        #
        # @return [Hash]
        def events(job_id:, event_id: nil, start: nil)
          if event_id
            @client.get "#{BASE_PATH}/#{job_id}/events/#{event_id}"
          else
            @client.get "#{BASE_PATH}/#{job_id}/events", params: {start:}.compact
          end
        end
      end
    end
  end
end
