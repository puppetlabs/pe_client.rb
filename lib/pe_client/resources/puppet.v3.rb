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
    # Server-specific Puppet API endpoints.
    #
    # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet_v3_api.htm
    class PuppetV3 < BaseWithPort
      # The base path for Puppet API v3 endpoints.
      BASE_PATH = "/puppet/v3"

      # Default Puppet API Port
      PORT = 8140

      # Returns a catalog for the specified node name given the provided facts.
      #
      # @param node_name [String] The name of the node to retrieve the catalog for.
      # @param environment [String] The environment to use when compiling the catalog.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_catalog.htm
      def catalog(node_name:, environment: nil)
        @client.get File.join("#{BASE_PATH}/catalog", node_name), params: {environment:}.compact
      end

      # The returned information includes the node name and environment, and optionally any classes set by an External Node Classifier and a hash of parameters which may include the node's facts.
      # The returned node may have a different environment from the one given in the request if Puppet is configured with an ENC.
      #
      # @param certname [String] The name of the node to retrieve information for.
      # @param environment [String] The environment to use when retrieving the node information.
      # @param transaction_uuid [String] A transaction uuid identifying the entire transaction (shows up in the report as well).
      # @param configured_environment [String] The environment configured on the client.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_node.htm
      def node(certname:, environment: nil, transaction_uuid: nil, configured_environment: nil)
        @client.get File.join("#{BASE_PATH}/node", certname), params: {environment:, transaction_uuid:, configured_environment:}.compact
      end

      # Allows setting the facts for the specified node name.
      #
      # @param node_name [String] The name of the node to set the facts for.
      # @param facts [Hash] The facts to set for the node.
      # @param environment [String] The environment to use when setting the facts.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_facts.htm
      def facts(node_name:, facts:, environment: nil)
        @client.put File.join("#{BASE_PATH}/facts", node_name), body: facts.to_json, params: {environment:}.compact
      end

      # Returns the contents of the specified file.
      #
      # @param mount_point [String] One of the following types:
      #   - Custom file serving mounts as specified in fileserver.conf
      #   - `modules/<MODULE>` --- a semi-magical mount point which allows access to the files subdirectory of <MODULE>
      #   - `plugins` --- a highly magical mount point which merges the lib directory of every module together.
      #     Used for syncing plugins; not intended for general consumption.
      #     Per-module sub-paths can not be specified.
      #   - `pluginfacts` --- a highly magical mount point which merges the facts.d directory of every module together.
      #     Used for syncing external facts; not intended for general consumption.
      #     Per-module sub-paths can not be specified.
      #   - `tasks/<MODULE>` --- a semi-magical mount point which allows access to files in the tasks subdirectory of <MODULE>
      # @param name [String]
      #
      # @return [String]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_file_content.htm
      def file_content(mount_point:, name:)
        @client.get File.join("#{BASE_PATH}/file_content", mount_point, name), params: {"Content-Type": "application/octet-stream", Accept: "application/octet-stream"}.freeze
      end

      # This endpoint allows clients to send reports to the master.
      # Once received by the master they are processed by the `report processors` configured to be triggered when a report is received.
      # As an example, storing reports in PuppetDB is handled by one such report processor.
      #
      # @param node_name [String] The name of the node the report is for.
      # @param environment [String] The environment to use when submitting the report.
      # @param report [Hash] The report to submit.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_report.htm
      def report(node_name:, environment:, report:)
        @client.put File.join("#{BASE_PATH}/report", node_name), body: report, params: {environment:}
      end

      # The environment classes API serves as a replacement for the Puppet resource type API for classes, which was removed in Puppet.
      #
      # @param environment [String] The environment to query.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/environment_classes.htm
      def environment_classes(environment:)
        @client.get "#{BASE_PATH}/environment_classes", params: {environment:}
      end

      # The environment modules API returns information about what modules are installed for the requested environment.
      #
      # @param environment [String] The environment to query.
      #
      # @return [Array<Hash>, Hash]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/environment_modules.htm
      def environment_modules(environment: nil)
        @client.get "#{BASE_PATH}/environment_modules", params: {environment:}.compact
      end

      # The static_file_content endpoint returns the standard output of a `code-content-command` script, which should output the contents of a specific version of a `file resource` that has a source attribute with a `puppet:///` URI value.
      # That source must be a file from the files or tasks directory of a module in a specific environment.
      #
      # @param file_path [String] The path corresponds to the requested file's path on the Server relative to the given environment's root directory, and must point to a file in the */*/files/**, */*/lib/**, */*/scripts/**, or */*/tasks/** glob.
      #
      # @return [String]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/static_file_content.htm
      def static_file_content(file_path:)
        @client.get File.join("#{BASE_PATH}/static_file_content", file_path)
      end

      # @return [PEClient::Resource::PuppetV3::FileBucket]
      def file_bucket
        require_relative "puppet.v3/file_bucket"
        @file_bucket ||= PuppetV3::FileBucket.new(@client)
      end

      # @return [PEClient::Resource::PuppetV3::FileMetadata]
      def file_metadata
        require_relative "puppet.v3/file_metadata"
        @file_metadata ||= PuppetV3::FileMetadata.new(@client)
      end
    end
  end
end
