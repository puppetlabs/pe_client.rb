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
      # Use the saml endpoints to configure SAML, retrieve SAML configuration details, and get the public certificate and URLs needed for configuration.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/rbac-api-v1-saml.htm
      class SAML < Base
        # The base path for RBAC API v1 SAML endpoints.
        BASE_PATH = "#{RBACV1::BASE_PATH}/saml".freeze

        # Use this endpoint to configure SAML.
        #
        # @param attributes [Hash] The SAML configuration attributes.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/2025.6/topics/rbac-saml-config-reference.htm
        def configure(attributes)
          @client.put "#{BASE_PATH}/configure", body: attributes
        end

        # Retrieves the current SAML configuration settings.
        #
        # @return [Hash]
        def get
          @client.get BASE_PATH
        end

        # Remove the current SAML configuration along with associated user groups and users.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def delete
          @client.delete BASE_PATH
        end

        # Retrieve the public SAML certificate and URLs you need to configure an identity provider.
        #
        # @return [Hash]
        def meta
          @client.get "#{BASE_PATH}/meta"
        end
      end
    end
  end
end
