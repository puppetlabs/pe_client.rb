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

module PEClient
  module Resource
    # Base class for PEClient resources where a custom port is needed.
    class BaseWithPort
      # We need to customise the port
      #
      # @param client [PEClient::Client]
      # @param port [Integer] Port number for the service
      def initialize(client, port: self.class::PORT)
        @client = client.dup

        base_url = @client.base_url.dup
        base_url.port = port

        @client.instance_variable_set(:@base_url, base_url)
        @client.instance_variable_set(:@connection, client.connection.dup)
        @client.connection.url_prefix = base_url
      end
    end
  end
end
