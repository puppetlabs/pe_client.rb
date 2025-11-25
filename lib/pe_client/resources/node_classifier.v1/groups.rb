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
      # The groups endpoints create, read, update, and delete groups.
      #
      # @see https://help.puppet.com/pe/2025.6/topics/groups_endpoint.htm
      class Groups < Base
        # The base path for Node Classifier API v1 groups endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/groups".freeze

        # Retrieves one or more groups.
        #
        # @param id [String]
        #
        # @return [Hash, Array<Hash>]
        def get(id = nil)
          if id
            @client.get("#{BASE_PATH}/#{id}")
          else
            @client.get(BASE_PATH)
          end
        end

        # Create a node group with a randomly-generated ID or specific ID if supplied.
        #
        # @param name [String] The name of the node group.
        # @param parent [String] The ID of the node group's parent.
        # @param id [String]
        # @param environment [String] The name of the node group's environment.
        #   This is optional.
        #   If omitted, the default value is production.
        # @param environment_trumps [Boolean] When a node belongs to two or more groups, this Boolean indicates whether this node group's environment overrides environments defined by other node groups.
        #   This is optional.
        #   If omitted, the default value is false.
        # @param description [String] Describing the node group.
        #   This is optional.
        #   If omitted, the node group has no description.
        # @param rule [String] The condition that must be satisfied for a node to be classified into this node group.
        #   For rule formatting assistance, refer to (Forming node classifier API requests)[https://help.puppet.com/pe/2025.6/topics/forming_node_classifier_requests.htm].
        # @param variables [Hash{Symbol, String => String}] An optional object that defines the names and values of any top-level variables set by the node group.
        #   Supply key-value pairs of variable names and corresponding variable values.
        #   Variable values can be any type of JSON value.
        #   The variables object can be omitted if the node group does not define any top-level variables.
        # @param classes [Hash{Symbol, String => String}] Defines the classes to be used by nodes in the node group.
        #   The classes object contains the parameters for each class.
        #   Some classes have required parameters.
        #   This object contains nested objects – The classes object's keys are class names (as strings), and each key's value is an object that defines class parameter names and their values.
        #   Within the nested objects, the keys are the parameter names (as strings), and each value is the parameter's assigned value (which can be any type of JSON value).
        #   If no classes are declared, then classes must be supplied as an empty object ({}).
        #   If missing, the server returns a 400 Bad request response.
        # @param config_data [Hash{Symbol, String => Any}] An optional object that defines the class parameters to be used by nodes in the group.
        #   Its structure is the same as the classes object.
        #   No configuration data is stored if you supply a config_data object that only contains a class name, such as `"config_data" => {"qux" => {}}`.
        #
        # @return [Hash]
        def create(name:, parent:, id: nil, environment: nil, environment_trumps: nil, description: nil, rule: nil, variables: nil, classes: {}, config_data: nil)
          body = {
            name:,
            parent:,
            environment:,
            environment_trumps:,
            description:,
            rule:,
            variables:,
            classes:,
            config_data:
          }.compact!

          if id
            @client.put "#{BASE_PATH}/#{id}", body:
          else
            @client.post BASE_PATH, body:
          end
        end

        # Edit the name, environment, parent node group, rules, classes, class parameters, configuration data, and variables for a specific node group.
        #
        # @param id [String]
        # @param attributes [Hash] The attributes to update.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/2025.6/topics/post_v1_groups.htm
        def update(id, attributes)
          @client.post "#{BASE_PATH}/#{id}", body: attributes
        end

        # Delete the node group with the given ID.
        #
        # @param id [String]
        #
        # @return [Hash] If the request is successful, the response body is empty.
        def delete(id)
          @client.delete "#{BASE_PATH}/#{id}"
        end

        # Pin specific nodes to a node group.
        #
        # @param id [String]
        # @param nodes [Array<String>] Names of the nodes you want to pin to the group
        #
        # @return [Hash] If the request is successful, the response body is empty.
        def pin(id, nodes)
          @client.post "#{BASE_PATH}/#{id}/pin", body: {nodes:}
        end

        # Unpin specific nodes to a node group.
        #
        # @param id [String]
        # @param nodes [Array<String>] Names of the nodes you want to unpin to the group
        #
        # @return [Hash] If the request is successful, the response body is empty.
        def unpin(id, nodes)
          @client.post "#{BASE_PATH}/#{id}/unpin", body: {nodes:}
        end

        # Resolve the rules for a specific node group, and then translate those rules to work with the PuppetDB nodes and inventory endpoints.
        #
        # @param id [String]
        #
        # @return [Hash]
        def rules(id)
          @client.get "#{BASE_PATH}/#{id}/rules"
        end

        # Resolve all the nodes associated with a node group.
        #   This endpoint combines all the rules for the group and queries PuppetDB for the result.
        #
        # @param id [String]
        #
        # @return [Hash]
        def nodes(id)
          @client.get "#{BASE_PATH}/#{id}/nodes"
        end
      end
    end
  end
end
