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
    # Puppet Enterprise (PE) includes an optional web endpoint for Java Management Extension (JMX) metrics managed beans (MBeans).
    #
    # @deprecated Use {MetricsV2} instead.
    #
    # @see https://help.puppet.com/pe/2025.6/topics/metrics-api-v1.htm
    class MetricsV1 < BaseWithPort
      # The base path for Metrics API v1 endpoints.
      BASE_PATH = "/metrics/v1"

      # Default Metrics v1 API Port
      PORT = 8140

      # Lists available MBeans.
      #
      # @return [Hash]
      def mbeans
        @client.get "#{BASE_PATH}/mbeans"
      end

      # Retrieves requested MBean metrics.
      #
      # @param metrics [String, Array<String>] Metric(s) to retrieve.
      #
      # @return [Hash, Array<Hash>] Will return an Array when multiple metrics are requested.
      def get(metrics)
        if metrics.is_a?(String)
          @client.get "#{BASE_PATH}/mbeans/#{metrics}"
        else
          @client.post "#{BASE_PATH}/mbeans", body: metrics
        end
      end
    end
  end
end
