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

require_relative "../../base"

module PEClient
  module Resource
    class PuppetDB
      class QueryV4
        # The factsets endpoint provides access to a representation of node factsets where each result includes the structured facts for a node broken down into a vector of top-level key/value pairs.
        # Note that the inventory endpoint will often provide more flexible and efficient access to the same information.
        #
        # @see https://help.puppet.com/pdb/current/topics/factsets.htm
        class Factsets < Base
          # The base path for PuppetDB Query v4 Factsets endpoints.
          BASE_PATH = "#{QueryV4::BASE_PATH}/factsets".freeze

          # This will return all factsets matching the given query.
          #
          # @param node [String] This will return the most recent factset for the given node.
          # @macro query
          # @macro query_paging
          #
          # @return [Array<Hash>, Hash]
          #
          # @see {QueryV4#query_paging} for paging options
          # @see https://help.puppet.com/pdb/current/topics/factsets.htm#pdbqueryv4factsets
          # @see https://help.puppet.com/pdb/current/topics/factsets.htm#pdbqueryv4factsetsnode
          def get(node: nil, query: nil, **kwargs)
            @client.get node ? "#{BASE_PATH}/#{node}" : BASE_PATH,
              params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
          end

          # This will return all facts for a particular factset, designated by a node certname.
          # This is a shortcut to the {QueryV4#facts} endpoint.
          # It behaves the same as a call to {QueryV4#facts} with a query string of ["=", "certname", "<NODE>"], except results are returned even if the node is deactivated or expired.
          #
          # @param node [String]
          # @macro query_paging
          #
          # @return [Array<Hash>]
          #
          # @see {QueryV4#facts} for more details
          # @see https://help.puppet.com/pdb/current/topics/factsets.htm#pdbqueryv4factsetsnodefacts
          def facts(node:, **kwargs)
            @client.get "#{BASE_PATH}/#{node}/facts", params: QueryV4.query_paging(**kwargs).compact
          end
        end
      end
    end
  end
end
