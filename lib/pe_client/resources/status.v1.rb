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

require_relative "base"

module PEClient
  module Resource
    # You can use the status API to check the health of Puppet Enterprise (PE) components and services.
    # It is useful for automatically monitoring your infrastructure, removing unhealthy service instances from a load-balanced pool, checking configuration values, or troubleshooting issues in PE.
    #
    # @see https://help.puppet.com/pe/2025.6/topics/status_api.htm
    class StatusV1 < Base
      # The base path for Status API v1 endpoints.
      BASE_PATH = "/status/v1"

      # Default Console Services Status API Port
      CONSOLE_SERVICES_PORT = 4433

      # Default Puppet Server Status API Port
      PUPPET_SERVER_PORT = 8140

      # Default Orchestrator Status API Port
      ORCHESTRATOR_PORT = 8143

      # Default PuppetDB Status API Port
      PUPPETDB_PORT = 8081

      # @!macro services_endpoint
      #   The services endpoints provide machine-consumable information about running services.
      #   They are intended for scripting and integration with other services.
      #
      #   @param level [String] How thorough of a check to run.
      #     Set to "critical", "debug", or "info".
      #     The default is "info".
      #   @param timeout [Integer] Specified in seconds.
      #     The default is 30.
      #
      #   @return [Hash]

      # @macro services_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "activity-service"
      #     - "classifier-service"
      #     - "rbac-service"
      def console_services(service_name: nil, level: nil, timeout: nil)
        services :console_services, service_name:, level:, timeout:
      end

      # @macro services_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "broker-service" (compilers only)
      #     - "code-manager-service"
      #     - "server" (Puppet Server)
      def puppet_server_services(service_name: nil, level: nil, timeout: nil)
        services :puppet_server, service_name:, level:, timeout:
      end

      # @macro services_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "broker-service" (primary server only)
      #     - "orchestrator-service"
      def orchestrator_services(service_name: nil, level: nil, timeout: nil)
        services :orchestrator, service_name:, level:, timeout:
      end

      # @macro services_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "puppetdb-service"
      def puppetdb_services(service_name: nil, level: nil, timeout: nil)
        services :puppetdb, service_name:, level:, timeout:
      end

      # @!macro simple_endpoint
      #   The status service plaintext endpoints are intended for load balancers that don't support JSON parsing or parameter setting.
      #   These endpoints return simple string bodies (either the service's state or a simple error message) and a relevant status code.
      #
      #   @return [String]

      # @macro simple_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "activity-service"
      #     - "classifier-service"
      #     - "rbac-service"
      def console_simple(service_name: nil)
        simple :console_services, service_name:
      end

      # @macro simple_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "broker-service" (compilers only)
      #     - "code-manager-service"
      #     - "server" (Puppet Server)
      def puppet_server_simple(service_name: nil)
        simple :puppet_server, service_name:
      end

      # @macro simple_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "broker-service" (primary server only)
      #     - "orchestrator-service"
      def orchestrator_simple(service_name: nil)
        simple :orchestrator, service_name:
      end

      # @macro simple_endpoint
      #
      # @param service_name [String] The name of the service to retrieve information for.
      #   Available services include:
      #     - "puppetdb-service"
      def puppetdb_simple(service_name: nil)
        simple :puppetdb, service_name:
      end

      # Returns information about the JRuby pools from which Puppet Server fulfills agent requests.
      #
      # @param level [String]
      #
      # @return [Hash]
      def pe_jruby_metrics(level: "debug")
        services :puppet_server, service_name: "pe-jruby-metrics", level:
      end

      # Returns information about the routes that agents use to connect to the primary server.
      #
      # @param level [String]
      #
      # @return [Hash]
      def pe_master(level: "debug")
        services :puppet_server, service_name: "pe-master", level:
      end

      # Returns statistics about catalog compilation.
      # You can use this data to discover which functions or resources are consuming the most resources or are most frequently used.
      #
      # @param level [String]
      #
      # @return [Hash]
      def pe_puppet_profiler(level: "debug")
        services :puppet_server, service_name: "pe-puppet-profiler", level:
      end

      private

      # Helper method to get services for a specific category
      #
      # @param category [Symbol] The type of service.
      # @param service_name [String]
      # @param level [String]
      # @param timeout [Integer]
      #
      # @return [Hash]
      def services(category, service_name: nil, level: nil, timeout: nil)
        if service_name
          client(category).get "#{BASE_PATH}/services/#{service_name}", params: {level:, timeout:}.compact
        else
          client(category).get "#{BASE_PATH}/services", params: {level:, timeout:}.compact
        end
      end

      # Helper method for simple endpoint
      #
      # @param category [Symbol] The type of service.
      # @param service_name [String]
      #
      # @return [String]
      def simple(category, service_name: nil)
        if service_name
          client(category).get "#{BASE_PATH}/simple/#{service_name}"
        else
          client(category).get "#{BASE_PATH}/simple"
        end
      end

      # Helper method to get the correct client
      #
      # @param category [Symbol] The type of service.
      #
      # @return [PEClient::Client]
      def client(category)
        case category
        when :console_services
          @console_services_client ||= build_client(CONSOLE_SERVICES_PORT)
        when :puppet_server
          @puppet_server_client ||= build_client(PUPPET_SERVER_PORT)
        when :orchestrator
          @orchestrator_client ||= build_client(ORCHESTRATOR_PORT)
        when :puppetdb
          @puppetdb_client ||= build_client(PUPPETDB_PORT)
        else
          raise ArgumentError, "Unknown category: #{category}"
        end
      end

      # Build a new client for a specific port
      #
      # @param port [Integer] The port to connect to
      #
      # @return [PEClient::Client]
      def build_client(port)
        client = @client.deep_dup
        client.base_url.port = port
        client.connection.url_prefix = client.base_url
        client
      end
    end
  end
end
