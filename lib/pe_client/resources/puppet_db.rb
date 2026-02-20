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
    # Interact with PuppetDB
    #
    # @see https://help.puppet.com/pdb/current/topics/api.htm
    class PuppetDB < BaseWithPort
      # The base path for PuppetDB endpoints.
      BASE_PATH = "/pdb"

      # Default PuppetDB API Port
      PORT = 8081

      # The state-overview endpoint provides a convenient mechanism for getting counts of nodes based on the status of their last report, or alternatively whether the node is unresponsive or has not reported.
      #
      # @param unresponsive_threshold [Integer] The time (in seconds) since the last report after which a node is considered "unresponsive".
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/pdb/current/topics/state-overview.htm
      def state_overview(unresponsive_threshold:)
        @client.get "#{BASE_PATH}/ext/v1/state-overview", params: {unresponsive_threshold:}
      end

      # The status endpoint implements the Puppet Status API for coordinated monitoring of Puppet services.
      #
      # @return [Hash]
      #
      # @see https://help.puppet.com/pdb/current/topics/status.htm
      def status
        @client.get "/status/v1/services/puppetdb-status"
      end

      # @return [PuppetDB::QueryV4]
      def query_v4
        require_relative "puppet_db/query.v4"
        @query_v4 ||= PuppetDB::QueryV4.new(@client)
      end

      # @return [PuppetDB::AdminV1]
      def admin_v1
        require_relative "puppet_db/admin.v1"
        @admin_v1 ||= PuppetDB::AdminV1.new(@client)
      end

      # @return [PuppetDB::MetadataV1]
      def metadata_v1
        require_relative "puppet_db/metadata.v1"
        @metadata_v1 ||= PuppetDB::MetadataV1.new(@client)
      end
    end
  end
end
