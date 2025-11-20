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
    # The role-based access control (RBAC) API v2 service enables you to fetch information about users, create groups, revoke tokens, validate tokens, and get information about your LDAP directory service.
    # The v2 endpoints either extend or replace some RBAC API v1 endpoints.
    #
    # @see https://help.puppet.com/pe/2025.6/topics/rbac_api_v2_endpoints.htm
    class NodeClassifierV1 < BaseWithPort
      # The base path for Node Classifier API v1 endpoints.
      BASE_PATH = "/classifier-api/v1"

      # Default Node Classifier API Port
      PORT = 4433

      # @return [PEClient::Resource::NodeClassifierV1::Groups]
      def groups
        require_relative "node_classifier.v1/groups"
        @groups ||= NodeClassifierV1::Groups.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::Classes]
      def classes
        require_relative "node_classifier.v1/classes"
        @classes ||= NodeClassifierV1::Classes.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::Classification]
      def classification
        require_relative "node_classifier.v1/classification"
        @classification ||= NodeClassifierV1::Classification.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::Commands]
      def commands
        require_relative "node_classifier.v1/commands"
        @commands ||= NodeClassifierV1::Commands.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::Environments]
      def environments
        require_relative "node_classifier.v1/environments"
        @environments ||= NodeClassifierV1::Environments.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::Nodes]
      def nodes
        require_relative "node_classifier.v1/nodes"
        @nodes ||= NodeClassifierV1::Nodes.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::GroupChildren]
      def group_children
        require_relative "node_classifier.v1/group_children"
        @group_children ||= NodeClassifierV1::GroupChildren.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::Rules]
      def rules
        require_relative "node_classifier.v1/rules"
        @rules ||= NodeClassifierV1::Rules.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::ImportHierarchy]
      def import_hierarchy
        require_relative "node_classifier.v1/import_hierarchy"
        @import_hierarchy ||= NodeClassifierV1::ImportHierarchy.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::LastClassUpdate]
      def last_class_update
        require_relative "node_classifier.v1/last_class_update"
        @last_class_update ||= NodeClassifierV1::LastClassUpdate.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::UpdateClasses]
      def update_classes
        require_relative "node_classifier.v1/update_classes"
        @update_classes ||= NodeClassifierV1::UpdateClasses.new(@client)
      end

      # @return [PEClient::Resource::NodeClassifierV1::Validation]
      def validation
        require_relative "node_classifier.v1/validation"
        @validation ||= NodeClassifierV1::Validation.new(@client)
      end
    end
  end
end
