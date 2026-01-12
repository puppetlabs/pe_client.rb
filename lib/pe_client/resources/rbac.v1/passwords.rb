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
      # When local users forget their Puppet Enterprise (PE) passwords or lock themselves out of PE by attempting to log in with incorrect credentials too many times, you must generate a password reset token for them.
      # Use the password endpoints to generate password reset tokens, use tokens to reset passwords, change the authenticated user's password, and validate potential user names and passwords.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_password.htm
      class Passwords < Base
        # Generate a single-use, limited-lifetime password reset token for a specific local user.
        #
        # @param uuid [String]
        #
        # @return [Hash]
        def generate_reset_token(uuid)
          @client.post "#{RBACV1::BASE_PATH}/users/#{uuid}/password/reset"
        end

        # Use a password reset token to change a local user's password.
        #
        # @param token [String]
        # @param password [String]
        #
        # @return [Hash]
        def reset(token, password)
          @client.post "#{RBACV1::BASE_PATH}/auth/reset", body: {token:, password:}
        end

        # Changes the current authenticated local user's password.
        #
        # @param current_password [String]
        # @param password [String]
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def change(current_password, password)
          @client.put "#{RBACV1::BASE_PATH}/users/current/password", body: {current_password:, password:}
        end

        # Check whether a password is valid.
        #
        # @param password [String] A password string to validate for compliance with password format and complexity requirements.
        # @param reset_token [String] You can provide a password reset token to identify the user for password validation.
        #   You can get password reset tokens from the {#generate_reset_token} method.
        #
        # @return [Hash]
        #
        # @note If `reset_token` is provided PEClient::Client.api_key is not required.
        def validate_password(password, reset_token: nil)
          @client.post "#{RBACV1::BASE_PATH}/command/validate-password", body: {password:, reset_token:}.compact
        end

        # Check whether a user name (login) is valid.
        #
        # @param login [String] A user name (login) string to validate for compliance with user name format and complexity requirements.
        #
        # @return [Hash]
        def validate_login(login)
          @client.post "#{RBACV1::BASE_PATH}/command/validate-login", body: {login:}
        end
      end
    end
  end
end
