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
      # Allows you to update a selection or all pending certificate requests to the signed state with a single request.
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_certificate_sign.htm
      class BulkCertificateSign < Base
        # The base path for Puppet CA API v1 Bulk Certificate Sign endpoints.
        BASE_PATH = "#{PuppetCAV1::BASE_PATH}/sign".freeze

        # Allows you to request the signing of CSRs that match the certnames included in the payload.
        #
        # @param certnames [Array<String>]
        #
        # @return [Hash]
        def sign(certnames)
          @client.post BASE_PATH, body: {certnames:}
        end

        # Allows you to request the signing of all outstanding CSRs.
        #
        # @return [Hash]
        def sign_all
          @client.post "#{BASE_PATH}/all"
        end
      end
    end
  end
end
