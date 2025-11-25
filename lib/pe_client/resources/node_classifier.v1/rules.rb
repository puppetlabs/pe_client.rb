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
      # Use the rules endpoint to translate a node group rule condition into PuppetDB query syntax.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/rules_endpoint.htm
      class Rules < Base
        # The base path for Node Classifier API v1 rules endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/rules".freeze

        # Translate a node group rule condition into PuppetDB query syntax.
        #
        # @param format [String] Optional format parameter to change the response format.
        #   The default value is "nodes".
        #   If you specify format: "inventory", the response returns classifier rules in a compatible dot notation format, instead of the PuppetDB AST format.
        #
        # @return [Hash]
        def translate(format: nil)
          @client.get "#{BASE_PATH}/translate", params: {format:}.compact
        end
      end
    end
  end
end
