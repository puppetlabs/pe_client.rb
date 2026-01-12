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
    class RBACV1
      # Authentication tokens control access to PE services. Use the auth/token and tokens endpoints to create tokens.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_token.htm
      class Tokens < Base
        # Generate an authorization token for a user identified by login and password.
        # This token can be used to authenticate requests to Puppet Enterprise (PE) services, such as by using an X-Authentication header or a token query parameter in an API request.
        #
        # @param login [String]
        # @param password [String]
        # @param lifetime [String] The duration that the token is valid for.
        #   This is a string that consists of a number followed by a unit, such as "1h" for one hour or "30m" for thirty minutes.
        # @param label [String] A label to identify the token.
        #
        # @return [Hash]
        #
        # @note PEClient::Client.api_key is not required to use this method.
        def generate(login:, password:, lifetime: nil, label: nil)
          @client.post "#{RBACV1::BASE_PATH}/auth/token", body: {login:, password:, lifetime:, label:}.compact
        end

        # Create a token for the authenticated user.
        # Doesn't allow certificate authentication.
        #
        # @param lifetime [String] The duration that the token is valid for.
        #   This is a string that consists of a number followed by a unit, such as "1h" for one hour or "30m" for thirty minutes.
        # @param description [String] A description to identify the token.
        # @param client [String] Description about the client making the token request, such as "PE console".
        #
        # @return [Hash]
        def create(lifetime:, description:, client: "PEClient/#{PEClient::VERSION}")
          @client.post "#{RBACV1::BASE_PATH}/tokens", body: {lifetime:, description:, client:}.compact
        end
      end
    end
  end
end
