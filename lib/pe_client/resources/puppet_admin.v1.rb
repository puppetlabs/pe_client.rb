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
    # Deleting environment caches created by a primary server.
    # Deleting the Puppet Server pool of JRuby instances.
    #
    # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/admin-api/v1/environment-cache.htm
    # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/admin-api/v1/jruby-pool.htm
    class PuppetAdminV1 < BaseWithPort
      # The base path for Puppet Admin API v1 endpoints.
      BASE_PATH = "/puppet-admin-api/v1"

      # Default Activity API Port
      PORT = 8140

      # When using directory environments, Puppet Server caches the data it loads from disk for each environment.
      # This endpoint is for clearing this cache
      #
      # @param environment [String] Set to the name of a specific Puppet environment.
      #   If this parameter is provided, only the specified environment will be flushed from the cache, as opposed to all environments.
      #
      # @return [Hash] If successful, returns an empty JSON object.
      def environment_cache(environment: nil)
        @client.delete "#{BASE_PATH}/environment-cache", params: {environment:}.compact
      end

      # Puppet Server contains a pool of JRuby instances.
      # This will remove all of the existing JRuby interpreters from the pool, allowing the memory occupied by these interpreters to be reclaimed by the JVM's garbage collector.
      # The pool will then be refilled with new JRuby instances, each of which will load the latest Ruby code and related resources from disk.
      #
      # @return [Hash] If successful, returns an empty JSON object.
      def jruby_pool
        @client.delete "#{BASE_PATH}/jruby-pool"
      end

      # Retrieve a Ruby thread dump for each JRuby instance registered to the pool.
      # The thread dump provides a backtrace through the Ruby code that each instance is executing and is useful for diagnosing instances that have stalled or are otherwise unresponsive.
      #
      # @return [Hash]
      def jruby_thread_dump
        @client.get "#{BASE_PATH}/jruby-pool/thread-dump"
      end
    end
  end
end
