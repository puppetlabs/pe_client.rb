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

require_relative "pe_client/version"
require_relative "pe_client/error"
require_relative "pe_client/client"

# Client library for PE API endpoints
module PEClient
  # Convenience method to create a new PEClient::Client
  #
  # @param api_key [String] API key for authentication
  # @param base_url [String, URI] Base URL for the PE API
  # @param ca_file [String] Path to CA certificate file
  # @param block [Proc] Optional block for Faraday connection customization
  #
  # @yield [Faraday::Connection] Faraday connection for customization
  #
  # @see PEClient::Client#initialize
  def self.new(api_key:, base_url:, ca_file:, &block)
    Client.new(api_key:, base_url:, ca_file:, &block)
  end

  # Deprecation warnings
  # @api private
  #
  # @param old_method [String] The name of the deprecated method
  # @param new_method [String] The name of the new method to use
  #
  # @return [void]
  def self.deprecated(old_method, new_method)
    warn "[DEPRECATION] `#{old_method}` is deprecated. Please use `#{new_method}` instead."
  end
end
