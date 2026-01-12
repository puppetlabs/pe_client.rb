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
    # You can use the Code Manager API to deploy code and check the status of deployments on your primary server and compilers without direct shell access.
    #
    # @see https://help.puppet.com/pe/current/topics/code_manager_api.htm
    class CodeManagerV1 < BaseWithPort
      # The base path for Code Manager API v1 endpoints.
      BASE_PATH = "/code-manager/v1"

      # Default Code Manager API Port
      PORT = 8170

      # Trigger Code Manager to deploy code to a specific environment or all environments, or use the dry-run parameter to test your control repo connection.
      #
      # @param deploy_all [Boolean] Set to true if you want to trigger code deployments for all known environments.
      #   If `false` or omitted, you must include the environments key.
      # @param environments [Array<String>] Specify the names of one or more specific environments for which you want to trigger code deployments.
      #   This key is required if deploy-all is `false` or omitted.
      # @param deploy_modules [Boolean] Indicate whether Code Manager deploys modules declared in an environment's Puppetfile.
      #   If `false`, modules aren't deployed.
      #   If omitted, the default value is `true`.
      # @param modules [Array<String>] Specific modules to deploy.
      # @param wait [Boolean] Indicates how soon you want Code Manager to return a response.
      #   If `false` or omitted, Code Manager returns a list of queued deployments immediately after receiving the request.
      #   If `true`, Code Manager returns a more detailed response after all deployments have finished (either successfully or with an error).
      # @param dry_run [Boolean] Use to test Code Manager's connection to your source control provider.
      #   If `true`, Code Manager attempt to connect to each of your remotes, attempts to fetch a list of environments from each source, and reports any connection errors.
      #
      # @return [Array]
      #
      # @see https://help.puppet.com/pe/current/topics/control_repo_add_env.htm For information about how Code Manager detects environments.
      # @see https://help.puppet.com/pe/current/topics/control_repo_concept.htm For more information about having multiple remotes
      def deploys(deploy_all: nil, environments: nil, deploy_modules: nil, modules: nil, wait: nil, dry_run: nil)
        @client.post "#{BASE_PATH}/deploys", body: {
          environments:, modules:, wait:,
          "deploy-all": deploy_all, "deploy-modules": deploy_modules, "dry-run": dry_run
        }.compact
      end

      # Deploy code by triggering your Code Manager webhook.
      #
      # @param type [String] Identifies your Git host.
      # @param prefix [String] Required if your source configuration uses prefixing.
      #   Specifies the prefix to use when converting branch names to environment names.
      # @param token [String] Required unless you disabled authenticate_webhook in your Code Manager configuration.
      #   You must supply the authentication token in the token parameter.
      #   Tokens supplied in query parameters might appear in access logs.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/pe/current/topics/code_mgr_webhook_query_params.htm Code Manager webhook query parameters.
      def webhook(type:, prefix: nil, token: nil)
        @client.post "#{BASE_PATH}/webhook", params: {type:, prefix:, token:}.compact
      end

      # Get the status of code deployments that Code Manager is currently processing for each environment.
      # You can specify an id query parameter to get the status of a particular deployment.
      #
      # @param id [Integer] Get the status of a specific deployment by calling its position in the current deployment queue.
      #
      # @return [Hash]
      def status(id: nil)
        @client.get "#{BASE_PATH}/deploys/status", params: {id:}.compact
      end
    end
  end
end
