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
    class PuppetDB
      # PuppetDB's administration API endpoints can be used for importing and exporting PuppetDB archives,
      # triggering PuppetDB maintenance operations or to directly deleting a node,
      # and generating information about the way your PuppetDB installation is using postgres.
      #
      # @see https://help.puppet.com/pdb/current/topics/api_admin.htm
      class AdminV1 < Base
        # The base path for PuppetDB Admin v1 endpoints.
        BASE_PATH = "#{PuppetDB::BASE_PATH}/admin/v1".freeze

        # The cmd endpoint can be used to trigger PuppetDB maintenance operations or to directly delete a node.
        # Admin commands are processed synchronously seperate from other PuppetDB commands.
        #
        # @param command [String] Identifying the command.
        # @param version [Integer] Describing what version of the given command you're attempting to invoke.
        #   The version of the command also indicates the version of the wire format to use for the command.
        # @param payload [Object] Must be a valid JSON object of any kind.
        #   It's up to an individual handler function to determine how to interpret this object.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pdb/current/topics/cmd.htm
        def cmd(command:, version:, payload:)
          @client.post "#{BASE_PATH}/cmd", body: {command:, version:, payload:}
        end

        # The summary-stats endpoint is used to generate information about the way your PuppetDB installation is using postgres.
        # Its intended purpose at this time is to aid in diagnosis of support issues, though users may find it independently useful.
        #
        # @return [Hash]
        #
        # @note This endpoint will execute a number of relatively expensive SQL commands against your database.
        #   It will not meaningfully impede performance of a running PuppetDB instance, but the request may take several minutes to complete.
        #
        # @see https://help.puppet.com/pdb/current/topics/summary-stats.htm
        # @api experimental
        def summary_stats
          @client.get "#{BASE_PATH}/summary-stats"
        end

        # @return [PEClient::Resource::PuppetDB::AdminV1::Archive]
        def archive
          require_relative "admin.v1/archive"
          @archive ||= AdminV1::Archive.new(@client)
        end
      end
    end
  end
end
