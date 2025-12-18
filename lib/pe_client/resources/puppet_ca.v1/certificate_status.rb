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
      # The `certificate_status` endpoint allows a client to read or alter the status of a certificate or pending certificate request.
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_request.htm
      class CertificateStatus < Base
        # The base path for Puppet CA API v1 Certificate Status endpoints.
        BASE_PATH = "#{PuppetCAV1::BASE_PATH}/certificate_status".freeze

        # Retrieve information about the specified certificate.
        #
        # @param certname [String]
        #
        # @return [Hash]
        def get(certname)
          @client.get "#{BASE_PATH}/#{certname}"
        end

        # Retrieve information about all known certificates.
        #
        # @param state [String] The certificate state by which to filter search results.
        #   Valid states are "requested", "signed", and "revoked".
        #
        # @return [Array<Hash>]
        def list(state: nil)
          @client.get "#{BASE_PATH}es/any_key", params: {state:}.compact
        end

        # Change the status of the specified certificate. The desired state is sent in the body of the PUT request as a one-item PSON hash; the two allowed complete hashes are:
        #
        # @param certname [String]
        # @param desired_state [String] The desired state for the certificate.
        #   Valid states are "signed" and "revoked".
        # @param cert_ttl [Integer, String] To set the validity period of the signed certificate.
        #   Can only be used when the `desired_state` is "signed".
        #   By default, this key specifies the number of seconds, but you can specify another time unit.
        #   See configuration for a list of Puppet's accepted time unit markers.
        #
        # @return [Hash]
        #
        # @note Revoking a certificate does not clean up other info about the host; see {#delete} for more information.
        def update(certname, desired_state, cert_ttl: nil)
          @client.put "#{BASE_PATH}/#{certname}", body: {desired_state:, cert_ttl:}.compact
        end

        # Cause the certificate authority to discard all SSL information regarding a host (including any certificates, certificate requests, and keys).
        # This does not revoke the certificate if one is present; if you wish to emulate the behavior of puppet cert --clean, you must {#update} a `desired_state` of "revoked" before deleting the host’s SSL information.
        #
        # @param hostname [String]
        #
        # @return [String]
        #
        # @note {PuppetCAV1#clean} can be used to accomplish both revoking and cleaning in one request.
        def delete(hostname)
          @client.delete "#{BASE_PATH}/#{hostname}"
        end
      end
    end
  end
end
