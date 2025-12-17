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

require "faraday"
require "uri"

module PEClient
  # Client for interacting with PE services
  #
  # @attr_reader [String] api_key API key for authentication
  # @attr_reader [String, URI] base_url Base URL for the PE API
  # @attr_reader [Faraday::Connection] connection Faraday connection object
  class Client
    attr_reader :api_key, :base_url, :connection

    # @param api_key [String] API key for authentication
    # @param base_url [String, URI] Base URL for the PE API
    # @param ca_file [String] Path to CA certificate file
    # @param block [Proc] Optional block for Faraday connection customization
    #
    # @yield [Faraday::Connection] Faraday connection for customization
    def initialize(api_key:, base_url:, ca_file:, &block)
      @api_key = api_key
      @base_url = base_url.is_a?(URI) ? base_url : URI.parse(base_url)
      @provisioning_block = block

      @connection = Faraday.new(url: base_url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.headers["User-Agent"] = "PEClient/#{PEClient::VERSION} Ruby/#{RUBY_VERSION}".freeze
        conn.headers["X-Authentication"] = @api_key
        conn.ssl[:ca_file] = ca_file

        block&.call(conn)

        conn.adapter Faraday.default_adapter
      end
    end

    # Create a deep duplicate of the client
    #
    # @return [PEClient::Client]
    def deep_dup
      self.class.new(
        api_key: @api_key.dup,
        base_url: @base_url.dup,
        ca_file: @connection.ssl[:ca_file].dup,
        &@provisioning_block
      )
    end

    # HTTP GET request
    #
    # @param path [String] API endpoint path
    # @param params [Hash] Query parameters
    # @param headers [Hash]
    #
    # @return Parsed JSON response
    def get(path, params: {}, headers: {})
      handle_response connection.get(path, params, headers)
    end

    # HTTP POST request
    #
    # @param path [String] API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @param headers [Hash]
    #
    # @return Parsed JSON response
    def post(path, body: {}, params: {}, headers: {})
      path = "#{path}?#{URI.encode_www_form(params)}" unless params.empty?
      handle_response connection.post(path, body, headers)
    end

    # HTTP PUT request
    #
    # @param path [String] API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @param headers [Hash]
    #
    # @return Parsed JSON response
    def put(path, body: {}, params: {}, headers: {})
      path = "#{path}?#{URI.encode_www_form(params)}" unless params.empty?
      handle_response connection.put(path, body, headers)
    end

    # HTTP DELETE request
    #
    # @param path [String] API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @param headers [Hash]
    #
    # @return Parsed JSON response
    def delete(path, body: nil, params: {}, headers: {})
      if body
        response = connection.delete(path, params, headers) do |req|
          req.body = body
        end
        handle_response response
      else
        handle_response connection.delete(path, params, headers)
      end
    end

    # HTTP HEAD request
    #
    # @param path [String] API endpoint path
    # @param body [Hash] Request body
    # @param params [Hash] Query parameters
    # @param headers [Hash]
    #
    # @return [Hash] HTTP Headers
    def head(path, body: nil, params: {}, headers: {})
      if body
        response = connection.head(path, params, headers) do |req|
          req.body = body
        end
        handle_response response, headers_only: true
      else
        handle_response connection.head(path, params, headers), headers_only: true
      end
    end

    # @return [Resource::NodeInventoryV1]
    def node_inventory_v1
      require_relative "resources/node_inventory.v1"
      @node_inventory_v1 ||= Resource::NodeInventoryV1.new(self)
    end

    # @return [Resource::RBACV1]
    def rbac_v1
      require_relative "resources/rbac.v1"
      @rbac_v1 ||= Resource::RBACV1.new(self)
    end

    # @return [Resource::RBACV2]
    def rbac_v2
      require_relative "resources/rbac.v2"
      @rbac_v2 ||= Resource::RBACV2.new(self)
    end

    # @return [Resource::NodeClassifierV1]
    def node_classifier_v1
      require_relative "resources/node_classifier.v1"
      @node_classifier_v1 ||= Resource::NodeClassifierV1.new(self)
    end

    # @return [Resource::OrchestratorV1]
    def orchestrator_v1
      require_relative "resources/orchestrator.v1"
      @orchestrator_v1 ||= Resource::OrchestratorV1.new(self)
    end

    # @return [Resource::CodeManagerV1]
    def code_manager_v1
      require_relative "resources/code_manager.v1"
      @code_manager_v1 ||= Resource::CodeManagerV1.new(self)
    end

    # @return [Resource::StatusV1]
    def status_v1
      require_relative "resources/status.v1"
      @status_v1 ||= Resource::StatusV1.new(self)
    end

    # @return [Resource::ActivityV1]
    def activity_v1
      require_relative "resources/activity.v1"
      @activity_v1 ||= Resource::ActivityV1.new(self)
    end

    # @return [Resource::ActivityV2]
    def activity_v2
      require_relative "resources/activity.v2"
      @activity_v2 ||= Resource::ActivityV2.new(self)
    end

    # @return [Resource::MetricsV1]
    def metrics_v1
      require_relative "resources/metrics.v1"
      @metrics_v1 ||= Resource::MetricsV1.new(self)
    end

    # @return [Resource::MetricsV2]
    def metrics_v2
      require_relative "resources/metrics.v2"
      @metrics_v2 ||= Resource::MetricsV2.new(self)
    end

    # @return [Resource::PuppetAdminV1]
    def puppet_admin_v1
      require_relative "resources/puppet_admin.v1"
      @puppet_admin_v1 ||= Resource::PuppetAdminV1.new(self)
    end

    # @return [Resource::PuppetV3]
    def puppet_v3
      require_relative "resources/puppet.v3"
      @puppet_v3 ||= Resource::PuppetV3.new(self)
    end

    private

    # Handle HTTP response
    #
    # @param response [Faraday::Response] HTTP response
    # @param headers_only [Boolean] Whether to return only headers
    #
    # @return Parsed JSON response, headers, or location
    #
    # @raise [PEClient::HTTPError] Raises specific errors based on status code
    def handle_response(response, headers_only: false)
      case response.status
      when 204 # No Content
        headers_only ? response.headers : {}
      when 200..299
        headers_only ? response.headers : response.body
      when 303 # See Other
        {"location" => response.headers["Location"]}
      when 400
        raise BadRequestError, response
      when 401
        raise UnauthorizedError, response
      when 403
        raise ForbiddenError, response
      when 404
        raise NotFoundError, response
      when 409
        raise ConflictError, response
      when 500..599
        raise ServerError, response
      else
        raise HTTPError, response
      end
    end
  end
end
