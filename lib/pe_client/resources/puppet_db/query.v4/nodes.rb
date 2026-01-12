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
        # Nodes can be queried by making through these endpoints.
        #
        # @see https://help.puppet.com/pdb/current/topics/nodes.htm
        class Nodes < Base
          # The base path for PuppetDB Query v4 Nodes endpoints.
          BASE_PATH = "#{QueryV4::BASE_PATH}/nodes".freeze

          # This will return all nodes matching the given query.
          # Deactivated and expired nodes aren't included in the response.
          #
          # @param node [String] This will return status information for the given node, active or not.
          #   It behaves exactly like a call with `node: nil` but with a query string of ["=", "certname", "<NODE>"].
          # @macro query
          # @macro query_paging
          #
          # @return [Array<Hash>, Hash]
          #
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodes
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnode
          def get(node: nil, query: nil, **kwargs)
            @client.get node ? "#{BASE_PATH}/#{node}" : BASE_PATH,
              params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
          end

          # This will return the facts for the given node. Facts from deactivated and expired nodes aren't included in the response.
          # This is a shortcut to the {QueryV4.facts} endpoint.
          # It behaves the same as a call to {QueryV4.facts} with a query string of ["=", "certname", "<NODE>"].
          # Facts from deactivated and expired nodes aren't included in the response.
          #
          # @param node [String]
          # @param name [String] This will return facts with the given name for the given node.
          # @param value [String] This will return facts with the given name and value for the given node.
          # @macro query
          # @macro query_paging
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnodefacts
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnodefactsname
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnodefactsnamevalue
          def facts(node:, name: nil, value: nil, query: nil, **kwargs)
            uri = "#{BASE_PATH}/#{node}/facts"
            uri += "/#{name}" if name
            uri += "/#{value}" if name && value
            @client.get uri, params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
          end

          # This will return the resources for the given node.
          # Resources from deactivated and expired nodes aren't included in the response.
          # This is a shortcut to the {QueryV4.resources} endpoint.
          # It behaves the same as a call to {QueryV4.resources} with a query string of ["=", "certname", "<NODE>"].
          #
          # @param node [String]
          # @param type [String] This will return the resources of the indicated type for the given node.
          # @param title [String] This will return the resource of the indicated type and title for the given node.
          # @macro query
          # @macro query_paging
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnoderesources
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnoderesourcestype
          # @see https://help.puppet.com/pdb/current/topics/nodes.htm#pdbqueryv4nodesnoderesourcestypetitle
          def resources(node:, type: nil, title: nil, query: nil, **kwargs)
            uri = "#{BASE_PATH}/#{node}/resources"
            uri += "/#{type}" if type
            uri += "/#{title}" if type && title
            @client.get uri, params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
          end
        end
      end
    end
  end
end
