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
    class PuppetDB
      # PuppetDB's query API can retrieve data objects from PuppetDB for use in other applications.
      #
      # @see https://help.puppet.com/pdb/current/topics/api_query.htm
      class QueryV4 < Base
        # The base path for PuppetDB Query v4 endpoints.
        BASE_PATH = "#{PuppetDB::BASE_PATH}/query/v4".freeze

        # @!macro query
        #  @param query [Array] An Array of query predicates, in prefix notation (["<OPERATOR>", "<FIELD>", "<VALUE>"]).

        # @!macro query_paging
        #   Most of PuppetDB's query endpoints support a general set of HTTP URL parameters that can be used for paging results.
        #   PuppetDB also supports paging via query operators, as described in the AST documentation.
        #
        #   @param kwargs [Hash] Keyword arguments for paging
        #   @option kwargs [String] :order_by This parameter can be used to ask PuppetDB to return results sorted by one or more fields, in ascending or descending order.
        #     The value must be an Array of Hashes.
        #     Each map represents a field to sort by, and the order in which the maps are specified in the array determines the sort order.
        #     Each map must contain the key field, whose value must be the name of a field that can be returned by the specified query.
        #     Each map may also optionally contain the key order, whose value may either be "asc" or "desc", depending on whether you wish the field to be sorted in ascending or descending order.
        #     The default value for this key, if not specified, is "asc".
        #     Note that the legal values for field vary depending on which endpoint you are querying.
        #     For lists of legal fields, please refer to the documentation for the specific query endpoints.
        #   @option kwargs [Integer] :limit This parameter can be used to restrict the result set to a maximum number of results.
        #   @option kwargs [Boolean] :include_total This parameter lets you request a count of how many records would have been returned, had the query not been limited using the limit parameter.
        #     This is useful if you want your application to show how far the user has navigated ("page 3 of 15").
        #     The value should be a Boolean, and defaults to `false`.
        #     If `true`, the HTTP response will contain a header X-Records, whose value is an integer indicating the total number of results available.
        #     Note: Setting this flag to `true` can decrease performance.
        #   @option kwargs [Integer] :offset This parameter can be used to tell PuppetDB to return results beginning at the specified offset.
        #     For example, if you'd like to page through query results with a page size of 10, your first query would specify `limit: 10` and `offset: 0`, your second query would specify `limit: 10` and `offset: 10`, and so on.
        #     Note that the order in which results are returned by PuppetDB is not guaranteed to be consistent unless you specify a value for `:order_by`, so this parameter should generally be used in conjunction with `:order_by`.
        #
        #   @return [Hash]

        # The root query endpoint can be used to retrieve any known entities from a single endpoint.
        #
        # @param query [String,Array]  Either a PQL query string, or an AST JSON array containing the query in prefix notation (["from", "<ENTITY>", ["<OPERATOR>", "<FIELD>", "<VALUE>"]]).
        #   Unlike other endpoints, a query with a from is required to choose the entity for which to query. For general info about queries, see our guide to query structure.
        # @param timeout [Integer] An optional limit on the number of seconds that the query will be allowed to run (e.g. timeout=30).
        #   If the limit is reached, the query will be interrupted.
        #   At the moment, that will result in either a 500 HTTP response status, or (more likely) a truncated JSON result if the result has begun streaming.
        #   Specifying this parameter is strongly encouraged.
        #   Lingering queries can consume substantial server resources (particularly on the PostgreSQL server) decreasing performance, for example, and increasing the maximum required storage space.
        #   The query timeout configuration settings are also recommended.
        # @param ast_only [Boolean] When true, the query response will be the supplied query in AST, either exactly as supplied or translated from PQL.
        #   `False` by default.
        # @param origin [String] A string describing the source of the query.
        #   It can be anything, and will be reported in the log when PuppetDB is configured to log queries.
        #   Note that Puppet intends to use origin names beginning with puppet: for its own queries, so it is recommended that other clients choose something else.
        # @param explain [String] The string value "analyze".
        #   This parameter can be used to tell PuppetDB to return the execution plan of a statement instead of the query results.
        #   The execution plan shows how the table(s) referenced by the statement will be scanned, the estimated statement execution cost and the actual run time statistics.
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/root_endpoint.htm
        def root(query:, timeout: nil, ast_only: nil, origin: nil, explain: nil, **kwargs)
          @client.get BASE_PATH, params: {query: query.to_json, timeout:, ast_only:, origin:, explain:}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # Environments are semi-isolated groups of nodes managed by Puppet.
        # Nodes are assigned to environments by their own configuration, or by the Puppet Server's external node classifier.
        # When PuppetDB collects info about a node, it keeps track of the environment the node is assigned to.
        # PuppetDB also keeps a list of environments it has seen.
        # You can query this list by making an HTTP request to the environments endpoint.
        #
        # @param environment [String] This will return the name of the environment if it currently exists in PuppetDB.
        # @param type [String] "events", "facts", "reports", or "resources"
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/environments.htm
        def environments(environment: nil, type: nil, query: nil, **kwargs)
          uri = "#{BASE_PATH}/environments"
          uri += "/#{environment}" if environment
          uri += "/#{type}" if environment && type
          @client.get uri, params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # Producers are the Puppet Servers that send reports, catalogs, and factsets to PuppetDB.
        # When PuppetDB stores a report, catalog, or factset, it keeps track of the producer of the report/catalog/factset.
        # PuppetDB also keeps a list of producers it has seen.
        # You can query this list by making an HTTP request to the producers endpoint.
        #
        # @param producer [String] This will return the name of the producer if it currently exists in PuppetDB.
        # @param type [String] "catalogs", "factsets", or "reports"
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>, Hash]
        #
        # @see https://help.puppet.com/pdb/current/topics/producers.htm
        def producers(producer: nil, type: nil, query: nil, **kwargs)
          uri = "#{BASE_PATH}/producers"
          uri += "/#{producer}" if producer
          uri += "/#{type}" if producer && type
          @client.get uri, params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # The facts endpoint provides access to a representation of node factsets where a result is returned for each top-level key in the node's structured factset.
        # Note that the {#inventory} endpoint will often provide more flexible and efficient access to the same information.
        #
        # @param fact_name [String] This will return all facts with the given fact name, for all nodes.
        # @param value [String] This will return all facts with the given fact name and value, for all nodes.
        #   (That is, only the certname field will differ in each result.)
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/facts.htm
        def facts(fact_name: nil, value: nil, query: nil, **kwargs)
          uri = "#{BASE_PATH}/facts"
          uri += "/#{fact_name}" if fact_name
          uri += "/#{value}" if fact_name && value
          @client.get uri, params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # The fact_names endpoint can be used to retrieve all known fact names.
        #
        # @macro query
        # @macro query_paging
        #
        # @return [Array<String>]
        #
        # @see https://help.puppet.com/pdb/current/topics/fact-names.htm
        def fact_names(query: nil, **kwargs)
          @client.get "#{BASE_PATH}/fact-names", params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # The fact_paths endpoint retrieves the set of all known fact paths for all known nodes, and is intended as a counterpart to the {#fact_names} endpoint, providing increased granularity around structured facts.
        # The endpoint may be useful for building autocompletion in GUIs or for other applications that require a basic top-level view of fact paths.
        #
        # @macro query
        # @macro query_paging
        #
        # @return [Array<String>]
        #
        # @see https://help.puppet.com/pdb/current/topics/fact-paths.htm
        def fact_paths(query: nil, **kwargs)
          @client.get "#{BASE_PATH}/fact-paths", params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # The fact_contents endpoint provides selective access to factset subtrees via fact paths.
        # Note that the {#inventory} endpoint will often provide more flexible and efficient access to the same information.
        #
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/fact-contents.htm
        def fact_contents(query: nil, **kwargs)
          @client.get "#{BASE_PATH}/fact-contents", params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # The inventory endpoint provides an alternate and potentially more efficient way to access structured facts as compared to the {#facts}, {#fact_contents}, and {#factsets} endpoints.
        #
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        def inventory(query: nil, **kwargs)
          @client.get "#{BASE_PATH}/inventory", params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # You can query resources by making an HTTP request to the resources endpoint.
        #
        # @param type [String] This will return all resources for all nodes with the given type.
        # @param title [String] This will return all resources for all nodes with the given type and title.
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/resources.htm
        def resources(type: nil, title: nil, query: nil, **kwargs)
          uri = "#{BASE_PATH}/resources"
          uri += "/#{type}" if type
          uri += "/#{title}" if type && title
          @client.get uri, params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # Catalog edges are relationships formed between two resources.
        # They represent the edges inside the catalog graph, whereas resources represent the nodes in the graph.
        # You can query edges by making a request to the edges endpoint.
        #
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/edges.htm
        def edges(query: nil, **kwargs)
          @client.get "#{BASE_PATH}/edges", params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB. Each report includes:
        # - Data about the entire run
        # - Metadata about the report
        # - Many events, describing what happened during the run
        #
        # After this information is stored in PuppetDB, it can be queried in various ways.
        # - You can query data about the run and report metadata by making an HTTP request to the {#reports} endpoint.
        # - You can query data about individual events by making an HTTP request to the {#events} endpoint.
        # - You can query summaries of event data by making an HTTP request to the {#event_counts} or {#aggregate_event_counts} endpoints.
        #
        # @param distinct_resources [Boolean] If specified, the result set will only return the most recent event for a given resource on a given node.
        #   (EXPERIMENTAL: it is possible that the behavior of this parameter may change in future releases.)
        # @param distinct_start_time [String] An ISO 8601 timestamp.
        #   Required if `distinct_resources` is `true`.
        # @param distinct_end_time [String] An ISO 8601 timestamp.
        #   Required if `distinct_resources` is `true`.
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/events.htm
        def events(distinct_resources: nil, distinct_start_time: nil, distinct_end_time: nil, query: nil, **kwargs)
          @client.get "#{BASE_PATH}/events",
            params: {distinct_resources:, distinct_start_time:, distinct_end_time:, query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # The event_counts endpoint is designated as experimental. It may be altered or removed in a future release.
        # Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB. Each report includes:
        # - Data about the entire run
        # - Metadata about the report
        # - Many events, describing what happened during the run
        #
        # After this information is stored in PuppetDB, it can be queried in various ways.
        # - You can query data about the run and report metadata by making an HTTP request to the {#reports} endpoint.
        # - You can query data about individual events by making an HTTP request to the {#events} endpoint.
        # - You can query summaries of event data by making an HTTP request to the {#event_counts} or {#aggregate_event_counts} endpoints.
        #
        # @param summarize_by [String] A string specifying which type of object you'd like to see counts for.
        #   Supported values are "resource", "containing_class", and "certname".
        # @param count_by [String] A string specifying what type of object is counted when building up the counts of successes, failures, noops, and skips.
        #   Supported values are "resource" (default) and "certname".
        # @param counts_filter [Array] An Array of query predicates, in prefix notation (["<OPERATOR>", "<FIELD>", "<VALUE>"]).
        # @param distinct_resources [Boolean] This parameter is passed along to the {#events} endpoint.
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/event-counts.htm
        # @api experimental
        def event_counts(summarize_by:, count_by: nil, counts_filter: nil, distinct_resources: nil, query: nil, **kwargs)
          @client.get "#{BASE_PATH}/event-counts",
            params: {summarize_by:, count_by:, counts_filter: counts_filter&.to_json, distinct_resources:, query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # The aggregate_event_counts endpoint is designated as experimental. It may be altered or removed in a future release.
        # Puppet agent nodes submit reports after their runs, and the Puppet Server forwards these to PuppetDB. Each report includes:
        # - Data about the entire run.
        # - Metadata about the report.
        # - Many events, describing what happened during the run.
        #
        # After this information is stored in PuppetDB, it can be queried in various ways.
        # - You can query data about the run and report metadata by making an HTTP request to the {#reports} endpoint.
        # - You can query data about individual events by making an HTTP request to the {#events} endpoint.
        # - You can query summaries of event data by making an HTTP request to the {#event_counts} or {#aggregate_event_counts} endpoints.
        #
        # @param summarize_by [String] A string specifying which type of object you'd like to see counts for.
        #   Supported values are "resource", "containing_class", and "certname".
        # @param count_by [String] A string specifying what type of object is counted when building up the counts of successes, failures, noops, and skips.
        #   Supported values are "resource" (default) and "certname".
        # @param counts_filter [Array] An Array of query predicates, in prefix notation (["<OPERATOR>", "<FIELD>", "<VALUE>"]).
        # @param distinct_resources [Boolean] This parameter is passed along to the {#events} endpoint.
        # @macro query
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/aggregate-event-counts.htm
        # @api experimental
        def aggregate_event_counts(summarize_by:, count_by: nil, counts_filter: nil, distinct_resources: nil, query: nil)
          @client.get "#{BASE_PATH}/aggregate-event-counts",
            params: {summarize_by:, count_by:, counts_filter: counts_filter&.to_json, distinct_resources:, query: query&.to_json}.compact
        end

        # Returns all installed packages, across all nodes.
        #
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/packages.htm#pdbqueryv4packages
        def packages(query: nil, **kwargs)
          @client.get "#{BASE_PATH}/packages", params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # Returns all installed packages along with the certname of the nodes they are installed on or a specific node.
        #
        # @param certname [String]
        # @macro query
        # @macro query_paging
        #
        # @return [Array<Hash>]
        #
        # @see https://help.puppet.com/pdb/current/topics/packages.htm#pdbqueryv4package-inventory
        # @see https://help.puppet.com/pdb/current/topics/packages.htm#pdbqueryv4package-inventorycertname
        def package_inventory(certname: nil, query: nil, **kwargs)
          @client.get certname ? "#{BASE_PATH}/package-inventory/#{certname}" : "#{BASE_PATH}/package-inventory",
            params: {query: query&.to_json}.merge!(QueryV4.query_paging(**kwargs)).compact
        end

        # @return [QueryV4::Nodes]
        def nodes
          require_relative "query.v4/nodes"
          @nodes ||= QueryV4::Nodes.new(@client)
        end

        # @return [QueryV4::Factsets]
        def factsets
          require_relative "query.v4/factsets"
          @factsets ||= QueryV4::Factsets.new(@client)
        end

        # @return [QueryV4::Catalogs]
        def catalogs
          require_relative "query.v4/catalogs"
          @catalogs ||= QueryV4::Catalogs.new(@client)
        end

        # @return [QueryV4::Reports]
        def reports
          require_relative "query.v4/reports"
          @reports ||= QueryV4::Reports.new(@client)
        end

        # @macro query_paging
        # @api private
        def self.query_paging(**kwargs)
          {
            order_by: kwargs[:order_by],
            limit: kwargs[:limit],
            include_total: kwargs[:include_total],
            offset: kwargs[:offset]
          }
        end
      end
    end
  end
end
