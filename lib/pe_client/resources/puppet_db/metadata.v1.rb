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
      # PuppetDB's metadata API endpoints can be used to retrieve version information and the server time from the PuppetDB server.
      #
      # @see https://help.puppet.com/pdb/current/topics/api_metadata.htm
      class MetadataV1 < Base
        # The base path for PuppetDB Metadata v1 endpoints.
        BASE_PATH = "#{PuppetDB::BASE_PATH}/meta/v1".freeze

        # The version endpoint can be used to retrieve version information from the PuppetDB server.
        #
        # @param latest [Boolean]
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pdb/current/topics/version.htm
        def version(latest: false)
          @client.get latest ? "#{BASE_PATH}/version/latest" : "#{BASE_PATH}/version"
        end

        # Used to retrieve the server time from the PuppetDB server.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pdb/current/topics/server_time.htm
        def server_time
          @client.get "#{BASE_PATH}/server-time"
        end
      end
    end
  end
end
