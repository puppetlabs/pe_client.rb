# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../lib/pe_client/resources/puppet_db/query.v4"

RSpec.describe PEClient::Resource::PuppetDB::QueryV4 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:resource) { described_class.new(puppetdb.instance_variable_get(:@client)) }
  subject { resource }

  describe "#root" do
    it "performs an AST query with required parameters" do
      query_array = ["from", "nodes", ["=", "certname", "node1.example.com"]]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4")
        .with(
          query: hash_including(
            "query" => query_array.to_json
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.root(query: query_array)
      expect(response).to eq([{"certname" => "node1.example.com"}])
    end

    it "performs an AST query with all optional parameters" do
      query_array = ["from", "nodes", ["=", "certname", "node1.example.com"]]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4")
        .with(
          query: hash_including(
            "query" => query_array.to_json,
            "limit" => "10",
            "offset" => "5",
            "timeout" => "30",
            "include_total" => "true"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com"}]',
          headers: {"Content-Type" => "application/json", "X-Records" => "100"}
        )

      response = resource.root(
        query: query_array,
        limit: 10,
        offset: 5,
        timeout: 30,
        include_total: true
      )
      expect(response).to eq([{"certname" => "node1.example.com"}])
    end
  end

  describe "#environments" do
    it "retrieves environments with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/environments")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name":"production"},{"name":"development"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.environments
      expect(response).to eq([{"name" => "production"}, {"name" => "development"}])
    end

    it "retrieves environments with environment parameter" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/environments/production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name":"production"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.environments(environment: "production")
      expect(response).to eq([{"name" => "production"}])
    end

    it "retrieves environments with environment and type parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/environments/production/events")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name":"production"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.environments(environment: "production", type: "events")
      expect(response).to eq([{"name" => "production"}])
    end
  end

  describe "#producers" do
    it "retrieves producers with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/producers")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name":"puppet-server1"},{"name":"puppet-server2"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.producers
      expect(response).to eq([{"name" => "puppet-server1"}, {"name" => "puppet-server2"}])
    end

    it "retrieves producers with producer parameter" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/producers/puppet-server1")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"puppet-server1"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.producers(producer: "puppet-server1")
      expect(response).to eq({"name" => "puppet-server1"})
    end

    it "retrieves producers with producer and type parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/producers/puppet-server1/catalogs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name":"puppet-server1"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.producers(producer: "puppet-server1", type: "catalogs")
      expect(response).to eq([{"name" => "puppet-server1"}])
    end
  end

  describe "#facts" do
    it "retrieves facts with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/facts")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","name":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts
      expect(response).to eq([{"certname" => "node1", "name" => "operatingsystem", "value" => "RedHat"}])
    end

    it "retrieves facts with fact_name parameter" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/facts/operatingsystem")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","name":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(fact_name: "operatingsystem")
      expect(response).to eq([{"certname" => "node1", "name" => "operatingsystem", "value" => "RedHat"}])
    end

    it "retrieves facts with fact_name and value parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/facts/operatingsystem/RedHat")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","name":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(fact_name: "operatingsystem", value: "RedHat")
      expect(response).to eq([{"certname" => "node1", "name" => "operatingsystem", "value" => "RedHat"}])
    end
  end

  describe "#fact_names" do
    it "retrieves fact names with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/fact-names")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '["operatingsystem","kernel","architecture"]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.fact_names
      expect(response).to eq(["operatingsystem", "kernel", "architecture"])
    end

    it "retrieves fact names with all optional parameters" do
      query_array = ["~", "name", "operating.*"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/fact-names")
        .with(
          query: hash_including("query" => query_array.to_json),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '["operatingsystem"]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.fact_names(query: query_array)
      expect(response).to eq(["operatingsystem"])
    end
  end

  describe "#fact_paths" do
    it "retrieves fact paths with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/fact-paths")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '["operatingsystem","networking.interfaces.eth0.mac"]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.fact_paths
      expect(response).to eq(["operatingsystem", "networking.interfaces.eth0.mac"])
    end

    it "retrieves fact paths with all optional parameters" do
      query_array = ["~", "path", "networking.*"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/fact-paths")
        .with(
          query: hash_including("query" => query_array.to_json),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '["networking.interfaces.eth0.mac"]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.fact_paths(query: query_array)
      expect(response).to eq(["networking.interfaces.eth0.mac"])
    end
  end

  describe "#fact_contents" do
    it "retrieves fact contents with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/fact-contents")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","path":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.fact_contents
      expect(response).to eq([{"certname" => "node1", "path" => "operatingsystem", "value" => "RedHat"}])
    end

    it "retrieves fact contents with all optional parameters" do
      query_array = ["=", "path", "operatingsystem"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/fact-contents")
        .with(
          query: hash_including("query" => query_array.to_json),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1","path":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.fact_contents(query: query_array)
      expect(response).to eq([{"certname" => "node1", "path" => "operatingsystem", "value" => "RedHat"}])
    end
  end

  describe "#inventory" do
    it "retrieves inventory data with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/inventory")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","environment":"production","facts":{"operatingsystem":"RedHat"}}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.inventory
      expect(response).to eq([{"certname" => "node1", "environment" => "production", "facts" => {"operatingsystem" => "RedHat"}}])
    end

    it "retrieves inventory data with all optional parameters" do
      query_array = ["=", "certname", "node1"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/inventory")
        .with(
          query: hash_including("query" => query_array.to_json),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1","environment":"production","facts":{"operatingsystem":"RedHat"}}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.inventory(query: query_array)
      expect(response).to eq([{"certname" => "node1", "environment" => "production", "facts" => {"operatingsystem" => "RedHat"}}])
    end
  end

  describe "#resources" do
    it "retrieves resources with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/resources")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","type":"File","title":"/etc/hosts"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources
      expect(response).to eq([{"certname" => "node1", "type" => "File", "title" => "/etc/hosts"}])
    end

    it "retrieves resources with type parameter" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/resources/File")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","type":"File","title":"/etc/hosts"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(type: "File")
      expect(response).to eq([{"certname" => "node1", "type" => "File", "title" => "/etc/hosts"}])
    end

    it "retrieves resources with type and title parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/resources/File/%2Fetc%2Fhosts")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","type":"File","title":"/etc/hosts"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(type: "File", title: "/etc/hosts")
      expect(response).to eq([{"certname" => "node1", "type" => "File", "title" => "/etc/hosts"}])
    end
  end

  describe "#edges" do
    it "retrieves edges with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/edges")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","source_type":"File","source_title":"/etc/hosts","target_type":"Service","target_title":"networking"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.edges
      expect(response).to eq([{"certname" => "node1", "source_type" => "File", "source_title" => "/etc/hosts", "target_type" => "Service", "target_title" => "networking"}])
    end

    it "retrieves edges with all optional parameters" do
      query_array = ["=", "certname", "node1"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/edges")
        .with(
          query: hash_including("query" => query_array.to_json),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1","source_type":"File","source_title":"/etc/hosts","target_type":"Service","target_title":"networking"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.edges(query: query_array)
      expect(response).to eq([{"certname" => "node1", "source_type" => "File", "source_title" => "/etc/hosts", "target_type" => "Service", "target_title" => "networking"}])
    end
  end

  describe "#events" do
    it "retrieves events with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/events")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","status":"success","timestamp":"2025-01-01T00:00:00Z"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events
      expect(response).to eq([{"certname" => "node1", "status" => "success", "timestamp" => "2025-01-01T00:00:00Z"}])
    end

    it "retrieves events with all optional parameters" do
      query_array = ["=", "status", "success"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/events")
        .with(
          query: hash_including(
            "query" => query_array.to_json,
            "distinct_resources" => "true",
            "distinct_start_time" => "2025-01-01T00:00:00Z",
            "distinct_end_time" => "2025-01-02T00:00:00Z"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1","status":"success","timestamp":"2025-01-01T00:00:00Z"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(
        query: query_array,
        distinct_resources: true,
        distinct_start_time: "2025-01-01T00:00:00Z",
        distinct_end_time: "2025-01-02T00:00:00Z"
      )
      expect(response).to eq([{"certname" => "node1", "status" => "success", "timestamp" => "2025-01-01T00:00:00Z"}])
    end
  end

  describe "#event_counts" do
    it "retrieves event counts with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/event-counts")
        .with(
          query: hash_including("summarize_by" => "certname"),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"subject":"node1","successes":1,"failures":0}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.event_counts(summarize_by: "certname")
      expect(response).to eq([{"subject" => "node1", "successes" => 1, "failures" => 0}])
    end

    it "retrieves event counts with all optional parameters" do
      counts_filter_array = ["=", "status", "success"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/event-counts")
        .with(
          query: hash_including(
            "summarize_by" => "certname",
            "count_by" => "certname",
            "counts_filter" => counts_filter_array.to_json,
            "distinct_resources" => "true"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"subject":"node1","successes":1,"failures":0}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.event_counts(
        summarize_by: "certname",
        count_by: "certname",
        counts_filter: counts_filter_array,
        distinct_resources: true
      )
      expect(response).to eq([{"subject" => "node1", "successes" => 1, "failures" => 0}])
    end
  end

  describe "#aggregate_event_counts" do
    it "retrieves aggregate event counts with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/aggregate-event-counts")
        .with(
          query: hash_including("summarize_by" => "certname"),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"successes":50,"failures":2}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.aggregate_event_counts(summarize_by: "certname")
      expect(response).to eq([{"successes" => 50, "failures" => 2}])
    end

    it "retrieves aggregate event counts with all optional parameters" do
      counts_filter_array = ["=", "status", "success"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/aggregate-event-counts")
        .with(
          query: hash_including(
            "summarize_by" => "certname",
            "count_by" => "certname",
            "counts_filter" => counts_filter_array.to_json,
            "distinct_resources" => "true"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"successes":50,"failures":2}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.aggregate_event_counts(
        summarize_by: "certname",
        count_by: "certname",
        counts_filter: counts_filter_array,
        distinct_resources: true
      )
      expect(response).to eq([{"successes" => 50, "failures" => 2}])
    end
  end

  describe "#packages" do
    it "retrieves packages with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/packages")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"package_name":"httpd","version":"2.4.6"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.packages
      expect(response).to eq([{"package_name" => "httpd", "version" => "2.4.6"}])
    end

    it "retrieves packages with all optional parameters" do
      query_array = ["=", "package_name", "httpd"]
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/packages")
        .with(
          query: hash_including("query" => query_array.to_json),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"package_name":"httpd","version":"2.4.6"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.packages(query: query_array)
      expect(response).to eq([{"package_name" => "httpd", "version" => "2.4.6"}])
    end
  end

  describe "#package_inventory" do
    it "retrieves package inventory with required parameters" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/package-inventory")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","package_name":"httpd","version":"2.4.6"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.package_inventory
      expect(response).to eq([{"certname" => "node1", "package_name" => "httpd", "version" => "2.4.6"}])
    end

    it "retrieves package inventory with certname parameter" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/package-inventory/node1")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1","package_name":"httpd","version":"2.4.6"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.package_inventory(certname: "node1")
      expect(response).to eq([{"certname" => "node1", "package_name" => "httpd", "version" => "2.4.6"}])
    end
  end

  include_examples "a memoized resource", :nodes, "PEClient::Resource::PuppetDB::QueryV4::Nodes"
  include_examples "a memoized resource", :factsets, "PEClient::Resource::PuppetDB::QueryV4::Factsets"
  include_examples "a memoized resource", :catalogs, "PEClient::Resource::PuppetDB::QueryV4::Catalogs"
  include_examples "a memoized resource", :reports, "PEClient::Resource::PuppetDB::QueryV4::Reports"
end
