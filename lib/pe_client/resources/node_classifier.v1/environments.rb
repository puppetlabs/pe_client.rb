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
      # Use the environments endpoints to retrieve the node classifier's environment data.
      # The responses tell you which environments are available, whether a named environment exists, and which classes exist in a certain environment.
      #
      # @see https://help.puppet.com/pe/current/topics/environments_endpoint.htm
      class Environments < Base
        # The base path for Node Classifier API v1 environments endpoints.
        BASE_PATH = "#{NodeClassifierV1::BASE_PATH}/environments".freeze

        # Retrieve a list of all environments the node classifier knows about at the time of the request.
        # Or Retrieve information about a specific environment.
        #
        # @param name [String] The name of the environment to retrieve.
        #   If nil, retrieves all environments.
        #
        # @return [Array<Hash>]
        def get(name = nil)
          if name
            @client.get "#{BASE_PATH}/#{name}"
          else
            @client.get BASE_PATH
          end
        end

        # Create a new environment with a specific name.
        #
        # @param name [String]
        #
        # @return [Hash]
        def create(name)
          @client.put BASE_PATH, body: {name: name}
        end

        # Retrieve a list of all classes (that the node classifier knows about) or a specific class in a specific environment.
        #
        # @param environment [String]
        # @param name [String] The name of the class to retrieve.
        #   If nil, retrieves all classes in the environment.
        #
        # @return [Hash]
        def classes(environment, name = nil)
          if name
            @client.get "#{BASE_PATH}/#{environment}/classes/#{name}"
          else
            @client.get "#{BASE_PATH}/#{environment}/classes"
          end
        end
      end
    end
  end
end
