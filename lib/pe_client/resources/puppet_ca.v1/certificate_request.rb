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
      # The `certificate_request` endpoint submits a Certificate Signing Request (CSR) to the primary server.
      # CSRs that have been submitted can then also be retrieved.
      # The returned CSR is always in the `.pem` format.
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_request.htm
      class CertificateRequest < Base
        # The base path for Puppet CA API v1 Certificate Request endpoints.
        BASE_PATH = "#{PuppetCAV1::BASE_PATH}/certificate_request".freeze

        # Common headers for Puppet CA API v1 Certificate Request endpoints.
        HEADERS = {"Content-Type": "text/plain", Accept: "text/plain"}.freeze

        # Get a submitted CSR
        #
        # @param node_name [String]
        #
        # @return [String]
        def get(node_name)
          @client.get "#{BASE_PATH}/#{node_name}", headers: HEADERS
        end

        # Submit a CSR
        #
        # @param node_name [String]
        # @param csr [String] PEM-encoded CSR
        #
        # @return [String]
        def submit(node_name, csr)
          @client.put "#{BASE_PATH}/#{node_name}", body: csr, headers: HEADERS
        end

        # Delete a submitted CSR
        #
        # @param node_name [String]
        #
        # @return [String]
        def delete(node_name)
          @client.delete "#{BASE_PATH}/#{node_name}", headers: HEADERS
        end
      end
    end
  end
end
