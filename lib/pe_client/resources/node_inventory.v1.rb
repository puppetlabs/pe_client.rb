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
    # Puppet Enterprise Node inventory API v1
    #
    # @see https://help.puppet.com/pe/current/topics/node_inventory_api.htm
    class NodeInventoryV1 < BaseWithPort
      # Base path for the Node Inventory API v1
      BASE_PATH = "/inventory/v1"

      # Default Node Inventory API Port
      PORT = 8143

      # List all the connections entries in the inventory database or request information about a specific connection.
      #
      # @param certnames [Array<String>] An array containing a list of certnames to retrieve from the inventory service database.
      #   If omitted, then all connections are returned.
      # @param sensitive [Boolean] Indicating whether you want the response to include sensitive connection parameters.
      #   This parameter has a permission gate, and it doesn't work if you don't have the proper permissions.
      # @param extract [Array<String>] Array of keys indicating the information you want the response to include.
      #   The connection_id key is always returned, and you can use extract to limit the remaining keys.
      #   For example, extract=["type"] limits the response to connection_id and type.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/pe/current/topics/inventory_api_get_query_connections.htm
      def connections(certnames: [], sensitive: false, extract: [])
        body = {}
        body[:certnames] = certnames unless certnames.empty?
        body[:sensitive] = sensitive if sensitive
        body[:extract] = extract unless extract.empty?
        @client.post "#{BASE_PATH}/query/connections", body:
      end

      # Create a new connection entry in the node inventory service database.
      #
      # @param certnames [Array<String>] An array containing a list of certnames to associate with the supplied connection details.
      # @param type [String] A string that is either "ssh" or "winrm".
      #   This tells bolt-server which connection type to use to access the node when running a task.
      # @param parameters [Hash] Specifying the connection parameters for the specified transport type.
      # @param sensitive_parameters [Hash] Defining the necessary sensitive data for connecting to the provided certnames, such as usernames and passwords.
      #   These values are stored in an encrypted format.
      # @param duplicates [String] A string that is either error or replace.
      #   This specifies how to handle cases where supplied certnames conflict with existing certnames stored in the node inventory connections database.
      #   If you specify error, the endpoint returns a 409 response if it finds any duplicate certnames.
      #   If you specify replace, the endpoint overwrites the existing certname with the new connection details if it finds a duplicate.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/pe/current/topics/inventory_api_post_command_create-connection.htm
      def create_connections(certnames:, type:, parameters: {}, sensitive_parameters: {}, duplicates: "error")
        @client.post "#{BASE_PATH}/command/create-connection", body: {certnames:, type:, parameters:, sensitive_parameters:, duplicates:}
      end

      # Remove specified certnames from all associated connection entries in the inventory service database.
      # In PuppetDB, removed certnames are replaced with preserve: false.
      #
      # @param certnames [Array<String>] An array containing a list of certnames to remove from the inventory service database.
      #
      # @return [Hash] If the request is well-formed, valid, and processed successfully, the service returns with an empty body.
      def delete_connections(certnames)
        @client.post "#{BASE_PATH}/command/delete-connection", body: {certnames:}
      end
    end
  end
end
