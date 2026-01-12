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
      PORT = 8080

      # @return [PuppetDB::QueryV4]
      def query_v4
        require_relative "puppet_db/query.v4"
        @query_v4 ||= PuppetDB::QueryV4.new(@client)
      end
    end
  end
end
