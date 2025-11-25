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
      # Use the scheduled_jobs endpoints to query, edit, and delete scheduled orchestrator jobs.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/orchestrator_api_scheduled_jobs_endpoint.htm
      class ScheduledJobs < Base
        # The base path for OrchestratorV1 API v1 Scheduled Jobs endpoints.
        BASE_PATH = "#{OrchestratorV1::BASE_PATH}/scheduled_jobs".freeze

        # Retrieve information about scheduled environment jobs, which are deployments, tasks, or plans that run in a specific environment.
        # Use parameters to narrow the response scope.
        # Or Retrieve information about a specific scheduled environment job.
        #
        # @param job_id [String] Identifying a specific scheduled job.
        # @param limit [Integer] Set the maximum number of scheduled jobs to include in the response.
        #   The point at which the limit count starts is determined by `offset`, and the job record sort order is determined by `order_by` and `order`.
        # @param offset [Integer] Specify a zero-indexed integer at which to start returning results.
        #   For example, if you set this to 12, the response returns scheduled jobs starting with the 13th record.
        #   The default is 0.
        # @param order_by [String] Specify one of the following categories to use to sort the results: "next_run_time", "environment", "owner", "name", or "type".
        #   The default is "next_run_time".
        # @param order [String] Indicate whether results are returned in ascending ("asc") or descending ("desc") order.
        #  The default is "asc".
        # @param type [String] Specify a job type to query, either "deploy", "task", or "plan".
        #
        # @return [Hash]
        def get(job_id: nil, limit: nil, offset: nil, order_by: nil, order: nil, type: nil)
          if job_id
            @client.get "#{BASE_PATH}/environment_jobs/#{job_id}"
          else
            @client.get "#{BASE_PATH}/environment_jobs", params: {limit:, offset:, order_by:, order:, type:}.compact
          end
        end

        # Create an environment job to run in the future.
        # An environment job is a deployment, task, or plan that runs in a specific environment, such as a Puppet run on nodes in your production environment.
        #
        # @param type [String] Enumerated value indicating the type of action you want to schedule, either "plan", "task", or "deploy".
        # @param input [Hash{Symbol, String => Any}] A Hash describing job parameters, scope, or targets.
        #   The contents depends on the type.
        # @param environment [String] A string specifying the name of the relevant environment.
        #   For task and plan jobs, this is the environment from which to load the task or plan.
        #   For deploy jobs, this can be an empty string or the name of the environment to deploy.
        # @param schedule [Hash{Symbol, String => Any}] An object that uses the start_time and interval keys to describe the job's schedule.
        #   The start_time key accepts an ISO-8601 timestamp indicating the first time that you want the job to run.
        #   The interval key accepts either a Hash or `nil`.
        #   To only run the job once, use `nil`.
        #   To schedule a recurring job, supply an object containing value and units.
        #   The units key is an enum that must be set to seconds.
        #   The value key is an integer representing the number of units to wait between job runs.
        # @param description [String] A string describing the job.
        #   You can supply an empty string.
        # @param userdata [Hash{Symbol, String => Any}] An object containing arbitrary key-value pairs supplied to the job, such as a support ticket number.
        #   You can supply an empty Hash.
        #
        # @return [Hash]
        def create(type:, input:, environment:, schedule:, description: "", userdata: {})
          @client.post "#{BASE_PATH}/environment_jobs", body: {type:, input:, environment:, schedule:, description:, userdata:}
        end
      end
    end
  end
end
