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
    # Manages interactions with Puppet CA API endpoints.
    # Most of the certificate authority (CA) API requires admin access.
    #
    # @note The Puppet CA V1 API requires certificate-based authentication.
    #   The certificate used must have the `pp_cli_auth` extension.
    #
    # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/ca_v1_api.htm
    class PuppetCAV1 < BaseWithPort
      # The base path for Puppet CA API v1 endpoints.
      BASE_PATH = "/puppet-ca/v1"

      # Default Puppet CA API Port
      PORT = 8140

      # Common Puppet CA API V1 Headers
      HEADERS = {Accept: "text/plain"}.freeze

      # Returns the certificate for the specified name, which might be either a standard certname or ca.
      #
      # @param node_name [String]
      #
      # @return [String] PEM-encoded certificate
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate.htm
      # @see https://help.puppet.com/core/current/Content/PuppetCore/puppet_registered_ids.htm#puppet_registered_ids
      def certificate(node_name)
        @client.get "#{BASE_PATH}/certificate/#{node_name}", headers: HEADERS
      end

      # Returns the "not-after" date for all certificates in the CA bundle, and the "next-update" date of all CRLs in the chain.
      #
      # @return [String]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_expirations.htm
      def expirations
        @client.get "#{BASE_PATH}/expirations", headers: HEADERS
      end

      # Allows you to revoke and delete a list of certificates with a single request.
      #
      # @param certnames [Array<String>]
      #
      # @return [String]
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_clean.htm
      def clean(certnames)
        @client.put "#{BASE_PATH}/clean", body: {certnames:}, headers: HEADERS
      end

      # @return [PEClient::Resource::PuppetCAV1::CertificateRequest]
      def certificate_request
        require_relative "puppet_ca.v1/certificate_request"
        @certificate_request ||= PuppetCAV1::CertificateRequest.new(@client)
      end

      # @return [PEClient::Resource::PuppetCAV1::CertificateStatus]
      def certificate_status
        require_relative "puppet_ca.v1/certificate_status"
        @certificate_status ||= PuppetCAV1::CertificateStatus.new(@client)
      end

      # @return [PEClient::Resource::PuppetCAV1::CertificateRevocationList]
      def certificate_revocation_list
        require_relative "puppet_ca.v1/certificate_revocation_list"
        @certificate_revocation_list ||= PuppetCAV1::CertificateRevocationList.new(@client)
      end

      # @return [PEClient::Resource::PuppetCAV1::BulkCertificateSign]
      def bulk_certificate_sign
        require_relative "puppet_ca.v1/bulk_certificate_sign"
        @bulk_certificate_sign ||= PuppetCAV1::BulkCertificateSign.new(@client)
      end
    end
  end
end
