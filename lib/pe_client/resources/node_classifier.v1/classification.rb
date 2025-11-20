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
    class NodeClassifierV1
      # The classification endpoints accepts a node name and a set of facts, and then return information about how the specified node is classified.
      # The output can help you test your node group classification rules.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/classification_endpoint.htm
      class Classification < Base
        # The base path for Node Classifier API v1 groups endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/classified/nodes".freeze

        # Retrieve a specific node's classification information based on facts supplied in the body of your request.
        #
        # @param name [String]
        # @param fact [Hash{Symbol, String => Any}, nil] Containing regular, non-trusted facts associated with the node.
        #   The object contains key/value pairs of fact names and fact values.
        #   Fact values can be strings, Integers, Booleans, Arrays, or Hashes.
        # @param trusted [Hash{Symbol, String => Any}, nil] Containing trusted facts associated with the node.
        #   The object contains key/value pairs of fact names and fact values.
        #   Fact values can be Strings, Integers, Booleans, Arrays, or Hashes.
        #
        # @return [Hash]
        def get(name, fact: nil, trusted: nil)
          @client.post "#{BASE_PATH}/#{name}", body: {fact:, trusted:}.compact
        end

        # Retrieve a detailed explanation about how a node is classified based on facts supplied in the body of your request.
        #
        # @param name [String]
        # @param fact [Hash{Symbol, String => Any}, nil] Containing regular, non-trusted facts associated with the node.
        #   The object contains key/value pairs of fact names and fact values.
        #   Fact values can be strings, Integers, Booleans, Arrays, or Hashes.
        # @param trusted [Hash{Symbol, String => Any}, nil] Containing trusted facts associated with the node.
        #   The object contains key/value pairs of fact names and fact values.
        #   Fact values can be Strings, Integers, Booleans, Arrays, or Hashes.
        #
        # @return [Hash]
        def explanation(name, fact: {}, trusted: {})
          @client.post "#{BASE_PATH}/#{name}/explanation", body: {fact:, trusted:}.compact
        end
      end
    end
  end
end
