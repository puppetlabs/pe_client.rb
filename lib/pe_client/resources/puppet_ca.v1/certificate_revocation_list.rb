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
    class PuppetCAV1
      # The `certificate_revocation_list` endpoint retrieves a Certificate Revocation List (CRL) from the primary server.
      # The returned CRL is always in the `.pem` format.
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_revocation_list.htm
      class CertificateRevocationList < Base
        # The base path for Puppet CA API v1 Certificate Revocation List endpoints.
        BASE_PATH = "#{PuppetCAV1::BASE_PATH}/certificate_revocation_list".freeze

        # Common headers for Puppet CA API v1 Certificate Revocation List endpoints.
        HEADERS = {"Content-Type": "text/plain", Accept: "text/plain"}.freeze

        # Get the submitted CRL
        #
        # @return [String]
        def get
          @client.get "#{BASE_PATH}/ca", headers: HEADERS
        end

        # Update upstream CRLs
        #
        # @param crls [String] PEM-encoded CRLs
        #
        # @return [String]
        def update(crls)
          @client.put "#{BASE_PATH}/ca", body: crls, headers: HEADERS
        end
      end
    end
  end
end
