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
        # Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB. Each report includes:
        # - Data about the entire run
        # - Metadata about the report
        # - Many events, describing what happened during the run
        #
        # After this information is stored in PuppetDB, it can be queried in various ways.
        # - You can query data about the run and report metadata by making an HTTP request to the reports endpoint.
        # - You can query data about individual events by making an HTTP request to the {QueryV4#events} endpoint.
        # - You can query summaries of event data by making an HTTP request to the {QueryV4#event_counts} or {QueryV4#aggregate_event_counts} endpoints.
        #
        # @see https://help.puppet.com/pdb/current/topics/reports.htm
        class Reports < Base
          # The base path for PuppetDB Query v4 Reports endpoints.
          BASE_PATH = "#{QueryV4::BASE_PATH}/reports".freeze

          # If `:query` is absent, PuppetDB will return all reports.
          #
          # @macro query
          # @macro query_paging
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reports
          def get(query: nil, **kwargs)
            @client.get(BASE_PATH, params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact)
          end

          # Returns all events for a particular report, designated by its unique hash.
          #
          # @param hash [String] The unique hash of the report.
          # @macro query
          # @macro query_paging
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reportshashevents
          def events(hash:, query: nil, **kwargs)
            @client.get "#{BASE_PATH}/#{hash}/events",
              params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
          end

          # Returns all metrics for a particular report, designated by its unique hash.
          # This endpoint does not currently support querying or paging.
          #
          # @param hash [String] The unique hash of the report.
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reportshashmetrics
          def metrics(hash:)
            @client.get "#{BASE_PATH}/#{hash}/metrics"
          end

          # Returns all logs for a particular report, designated by its unique hash.
          # This endpoint does not currently support querying or paging.
          #
          # @param hash [String] The unique hash of the report.
          #
          # @return [Array<Hash>]
          #
          # @see https://help.puppet.com/pdb/current/topics/reports.htm#pdbqueryv4reportshashlogs
          def logs(hash:)
            @client.get "#{BASE_PATH}/#{hash}/logs"
          end
        end
      end
    end
  end
end
