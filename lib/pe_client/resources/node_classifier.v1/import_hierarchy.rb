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
      # Use the import hierarchy endpoint to delete all existing node groups from the node classifier service and replace them with the node groups defined in the body of the request.
      #
      # @see https://help.puppet.com/pe/current/topics/import_hierarchy_endpoint.htm
      class ImportHierarchy < Base
        # The base path for Node Classifier API v1 import hierarchy endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/import-hierarchy".freeze

        # Delete _all_ existing node groups from the node classifier service and replace them with the node groups defined in the body of the submitted request.
        #
        # @param name [String] The name of the node group.
        # @param environment [String] The name of the node group's environment, such as "production".
        # @param environment_trumps [Boolean] When a node belongs to two or more groups, this Boolean indicates whether this node group's environment overrides environments defined by other node groups.
        # @param parent [String] The ID of the node group's parent.
        # @param rule [String] The condition that must be satisfied for a node to be classified into this node group.
        #   For rule formatting assistance, refer to (Forming node classifier API requests)[https://help.puppet.com/pe/current/topics/forming_node_classifier_requests.htm].
        # @param config_data [Hash{Symbol, String => Any}] An object that defines the class parameters to be used by nodes in the group. Its structure is the same as the classes object.
        #   No configuration data is stored if you supply a config_data object that only contains a class name, such as config_data: {"qux" => {}}.
        # @param description [String] A string describing the node group.
        # @param variables [Hash{Symbol, String => Any}] An object that defines the names and values of any top-level variables set by the node group.
        #   Supply key-value pairs of variable names and corresponding variable values.
        #   Variable values can be any type of JSON value.
        #   The variables object can be empty if the node group does not define any top-level variables.
        # @param classes [Hash{Symbol, String => Any}] An object that defines the classes to be used by nodes in the node group.
        #   The classes object contains the parameters for each class.
        #   Some classes have required parameters.
        #   This object contains nested objects – The classes object's keys are class names (as strings), and each key's value is an object that defines class parameter names and their values.
        #   Within the nested objects, the keys are the parameter names (as strings), and each value is the parameter's assigned value (which can be any type of JSON value).
        #   If no classes are declared, then classes must be supplied as an empty Hash.
        #
        # @return [Hash] If the request is successful, the response body is empty.
        def replace(name:, environment:, environment_trumps:, parent:, rule:, config_data:, description: "", variables: {}, classes: {})
          @client.post BASE_PATH, body: {
            name:,
            environment:,
            environment_trumps:,
            parent:,
            rule:,
            config_data:,
            description:,
            variables:,
            classes:
          }
        end
      end
    end
  end
end
