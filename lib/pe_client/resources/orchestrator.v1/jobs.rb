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
      # Use the jobs endpoints to examine jobs and their details.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/orchestrator_api_jobs_endpoint.htm
      class Jobs < Base
        # The base path for OrchestratorV1 API v1 Jobs endpoints.
        BASE_PATH = "#{OrchestratorV1::BASE_PATH}/jobs".freeze

        # Retrieve details about all jobs that the orchestrator knows about.
        # or Retrieve details of a specific job, including the start and end times for each job state.
        #
        # @param job_id [String] Identifying a specific task or deployment.
        #   Cannot be used with any other parameters.
        # @param limit [Integer] Set the maximum number of jobs to include in the response.
        #   The point at which the limit count starts is determined by `offset`, and the job record sort order is determined by `order_by` and `order`.
        # @param offset [Integer] Specify a zero-indexed integer at which to start returning results.
        #   For example, if you set this to 12, the response returns jobs starting with the 13th record.
        #   The default is 0.
        # @param order_by [String] Specify one of the following categories to use to sort the results: "owner", "timestamp", "environment", "name", or "state".
        #   Sorting by `owner` uses the `login` subfield of `owner` records.
        # @param order [String] Indicate whether results are returned in ascending ("asc") or descending ("desc") order.
        #   The default is "asc".
        # @param type [String] Specify a job type to query, either "deploy", "task", or "plan_task".
        # @param task [String] Specify a task name to match.
        #   Partial matches are supported.
        #   If you specified type: "deploy", you can't use task.
        # @param min_finish_timestamp [String] Returns only the jobs that finished at or after the supplied UTC timestamp.
        # @param max_finish_timestamp [String] Returns only the jobs that finished at or before the supplied UTC timestamp.
        #
        # @return [Hash]
        def get(job_id: nil, limit: nil, offset: nil, order_by: nil, order: nil, type: nil, task: nil, min_finish_timestamp: nil, max_finish_timestamp: nil)
          if job_id
            @client.get("#{BASE_PATH}/#{job_id}")
          else
            @client.get(BASE_PATH, params: {limit:, offset:, order_by:, order:, type:, task:, min_finish_timestamp:, max_finish_timestamp:}.compact)
          end
        end

        # Retrieve information about nodes associated with a specific job.
        #
        # @param job_id [String]
        # @param limit [Integer] Set the maximum number of nodes to include in the response.
        #   The point at which the limit count starts is determined by `offset`, and the node record sort order is determined by `order_by` and `order`.
        # @param offset [Integer] Specify a zero-indexed integer at which to start returning results.
        #   For example, if you set this to 12, the response returns nodes starting with the 13th record.
        #   The default is 0.
        # @param order_by [String] Specify one of the following categories to use to sort the results: "name", "duration", "state", "start_timestamp", or "finish_timestamp".
        # @param order [String] Indicate whether results are returned in ascending ("asc") or descending ("desc") order.
        #   The default is "asc".
        # @param state [String] Specify a specific node state to query: "new", "ready", "running", "stopping", "stopped", "finished", or "failed".
        #
        # @return [Hash]
        def nodes(job_id, limit: nil, offset: nil, order_by: nil, order: nil, state: nil)
          @client.get("#{BASE_PATH}/#{job_id}/nodes", params: {limit:, offset:, order_by:, order:, state:}.compact)
        end

        # Returns a report that summarizes a specific job.
        #
        # @param job_id [String] Identifying a specific task or deployment.
        #
        # @return [Hash]
        def report(job_id)
          @client.get("#{BASE_PATH}/#{job_id}/report")
        end

        # Retrieve a list of events that occurred during a specific job.
        #
        # @param job_id [String] Identifying a specific task or deployment.
        # @param start [Integer] Start the list of events from a specific event ID number.
        #
        # @return [Hash]
        def events(job_id, start: nil)
          @client.get("#{BASE_PATH}/#{job_id}/events", params: {start:}.compact)
        end
      end
    end
  end
end
