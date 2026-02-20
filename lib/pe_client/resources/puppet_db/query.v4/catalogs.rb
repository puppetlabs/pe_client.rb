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
        # You can query catalogs by making an HTTP request to the catalogs endpoint.
        #
        # @see https://help.puppet.com/pdb/current/topics/catalogs.htm
        class Catalogs < Base
          # The base path for PuppetDB Query v4 Catalogs endpoints.
          BASE_PATH = "#{QueryV4::BASE_PATH}/catalogs".freeze

          # This will return a JSON array containing the most recent catalog for each node or for a given node in your infrastructure.
          #
          # @param node [String]
          # @macro query
          # @macro query_paging
          #
          # @return [Array<Hash>, Hash]
          #
          # @see https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogs
          # @see https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogsnode
          def get(node: nil, query: nil, **kwargs)
            @client.get node ? "#{BASE_PATH}/#{node}" : BASE_PATH,
              params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
          end

          # This will return all edges for a particular catalog, designated by a node certname.
          # This is a shortcut to the {QueryV4#edges} endpoint. It behaves the same as a call to {QueryV4#edges} with `query: ["=", "certname", "<NODE>"]`.
          # Except results are returned even if the node is deactivated or expired.
          #
          # @param node [String]
          # @macro query_paging
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogsnodeedges
          def edges(node:, **kwargs)
            @client.get "#{BASE_PATH}/#{node}/edges", params: QueryV4.query_paging(**kwargs).compact
          end

          # This will return all resources for a particular catalog, designated by a node certname.
          # This is a shortcut to the {QueryV4#resources} endpoint. It behaves the same as a call to {QueryV4#resources} with `query: ["=", "certname", "<NODE>"]`.
          # Except results are returned even if the node is deactivated or expired.
          #
          # @param node [String]
          # @macro query_paging
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/catalogs.htm#pdbqueryv4catalogsnoderesources
          def resources(node:, **kwargs)
            @client.get "#{BASE_PATH}/#{node}/resources", params: QueryV4.query_paging(**kwargs).compact
          end
        end
      end
    end
  end
end
