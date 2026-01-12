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
    class RBACV2
      # Authentication tokens control access to PE services.
      # Use the v2 tokens endpoints to revoke and validate tokens.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac_api_v2_tokens_endpoints.htm
      class Tokens < Base
        # The base path for RBAC API v2 Tokens endpoints.
        BASE_PATH = "#{RBACV2::BASE_PATH}/tokens".freeze

        # Use this endpoint to revoke one or more authentication tokens, ensuring the tokens can no longer be used with RBAC to access PE services.
        #
        # @param token [String] The authentication token to use for authorization.
        #   Cannot be used with other parameters.
        # @param revoke_tokens [Array<String>] Supply a list of complete authentication tokens you want to revoke.
        #   Any user can revoke any token by supplying the complete token in this parameter.
        # @param revoke_tokens_by_usernames [Array<String>] Supply a list of user names identifying users whose tokens you want to revoke.
        #   To revoke tokens by user name, the user making the request must have the Users Revoke permission for the specified users.
        # @param revoke_tokens_by_labels [Array<String>] Supply a list of labels identifying tokens to revoke.
        #   To be revoked in this manner, the tokens must belong to the requesting user and have been assigned a [token-spcific label](https://help.puppet.com/pe/current/topics/rbac_token_auth_token_label.htm).
        # @param revoke_tokens_by_ids [Array<String>] Supply a list of UUIDs for users whose tokens you want to revoke.
        #   To revoke tokens by user name, the user making the request must have the Users Revoke permission for the specified users.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def delete(token: nil, revoke_tokens: [], revoke_tokens_by_usernames: [], revoke_tokens_by_labels: [], revoke_tokens_by_ids: [])
          if token
            @client.delete "#{BASE_PATH}/#{token}"
          else
            @client.delete BASE_PATH, body: {revoke_tokens:, revoke_tokens_by_usernames:, revoke_tokens_by_labels:, revoke_tokens_by_ids:}.reject { |_, v| v.empty? }
          end
        end

        # Use this endpoint to exchange a token for a map representing an RBAC subject and associated token data.
        #
        # @param token [String] An authentication token.
        # @param update_last_activity [Boolean] A Boolean indicating whether you want a successful request to update the token's last_active timestamp.
        #
        # @return [Hash]
        #
        # @note PEClient::Client.api_key is not required to use this method.
        def authenticate(token, update_last_activity: false)
          @client.post "#{RBACV2::BASE_PATH}/auth/token/authenticate", body: {token:, update_last_activity?: update_last_activity}
        end
      end
    end
  end
end
