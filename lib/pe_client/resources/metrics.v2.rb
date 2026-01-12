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
    # The Metrics v2 endpoints use the Jolokia library for Java Management Extension (JMX) metrics to query Orchestrator service metrics.
    #
    # @see https://help.puppet.com/pe/current/topics/metrics-api-v2.htm
    class MetricsV2 < BaseWithPort
      # The base path for Metrics API v2 endpoints.
      BASE_PATH = "/metrics/v2"

      # Default Metrics v2 API Port
      PORT = 8081

      # Get a list of all valid MBeans
      #
      # @return [Hash]
      def list
        @client.get "#{BASE_PATH}/list"
      end

      # Retrieve orchestrator service metrics data or metadata.
      #
      # @param mbean_names [String] MBean names are created by joining the first two keys in the list response's value object with a colon (which are the domain and prop list, in Jolokia terms).
      #   Such as "java.util.logging:type=Logging"
      #   If you specify multiple MBean names or attributes, use comma separation, such as: "java.lang:name=*,type=GarbageCollector"
      # @param attributes [String] Attributes are derived from the attr object, which is within the value object in the list response.
      # @param inner_path_filter [String] Depends on the MBeans and attributes you are querying.
      #
      # @return [Hash]
      def read(mbean_names:, attributes:, inner_path_filter: nil)
        path = "#{BASE_PATH}/read/#{mbean_names}/#{attributes}"
        path += "/#{inner_path_filter}" if inner_path_filter
        @client.get path
      end

      # Use more complicated queries to retrieve orchestrator service metrics data or metadata.
      #
      # @param body [Hash, Array<Hash>] Request body as per Jolokia protocol.
      #
      # @return [Hash]
      #
      # @see https://jolokia.org/reference/html/manual/jolokia_protocol.html#post-requests
      def complex_read(body)
        @client.post "#{BASE_PATH}/read", body:
      end
    end
  end
end
