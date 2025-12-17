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
    # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/environment_classes.htm
    # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/environment_modules.htm
    # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/puppet-api/v3/static_file_content.htm
    class PuppetServerV3 < BaseWithPort
      # The base path for Puppet Server API v3 endpoints.
      BASE_PATH = "/puppet/v3"

      # Default Puppet Server API Port
      PORT = 8140

      # The environment classes API serves as a replacement for the Puppet resource type API for classes, which was removed in Puppet.
      #
      # @param environment [String] The environment to query.
      #
      # @return [Hash]
      def environment_classes(environment:)
        @client.get "#{BASE_PATH}/environment_classes", params: {environment:}
      end

      # The environment modules API returns information about what modules are installed for the requested environment.
      #
      # @param environment [String] The environment to query.
      #
      # @return [Array<Hash>, Hash]
      def environment_modules(environment: nil)
        @client.get "#{BASE_PATH}/environment_modules", params: {environment:}.compact
      end

      # The static_file_content endpoint returns the standard output of a `code-content-command` script, which should output the contents of a specific version of a `file resource` that has a source attribute with a `puppet:///` URI value.
      # That source must be a file from the files or tasks directory of a module in a specific environment.
      #
      # @param file_path [String] The path corresponds to the requested file's path on the Server relative to the given environment's root directory, and must point to a file in the */*/files/**, */*/lib/**, */*/scripts/**, or */*/tasks/** glob.
      #
      # @return [String]
      def static_file_content(file_path:)
        @client.get File.join("#{BASE_PATH}/static_file_content", file_path)
      end
    end
  end
end
