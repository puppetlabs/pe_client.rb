# frozen_string_literal: true

require "uri"
require_relative "../../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4/nodes"

RSpec.describe PEClient::Resource::PuppetDB::QueryV4::Nodes do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:resource) { described_class.new(puppetdb.instance_variable_get(:@client)) }

  describe "#get" do
    it "retrieves all nodes" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","deactivated":null},{"certname":"node2.example.com","deactivated":null}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([
        {"certname" => "node1.example.com", "deactivated" => nil},
        {"certname" => "node2.example.com", "deactivated" => nil}
      ])
    end

    it "retrieves a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"certname":"node1.example.com","deactivated":null,"catalog_timestamp":"2025-01-01T00:00:00Z"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(node: "node1.example.com")
      expect(response).to eq({
        "certname" => "node1.example.com",
        "deactivated" => nil,
        "catalog_timestamp" => "2025-01-01T00:00:00Z"
      })
    end

    it "supports query parameter" do
      query_param = URI.encode_www_form({"query" => ["~", "certname", "node.*"].to_json})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(query: ["~", "certname", "node.*"])
      expect(response).to eq([{"certname" => "node1.example.com"}])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "10", "offset" => "0"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(limit: 10, offset: 0)
      expect(response).to eq([])
    end
  end

  describe "#facts" do
    it "retrieves facts for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/facts")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","name":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(node: "node1.example.com")
      expect(response).to eq([{"certname" => "node1.example.com", "name" => "operatingsystem", "value" => "RedHat"}])
    end

    it "retrieves facts by name for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/facts/operatingsystem")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","name":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(node: "node1.example.com", name: "operatingsystem")
      expect(response).to eq([{"certname" => "node1.example.com", "name" => "operatingsystem", "value" => "RedHat"}])
    end

    it "retrieves facts by name and value for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/facts/operatingsystem/RedHat")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","name":"operatingsystem","value":"RedHat"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(node: "node1.example.com", name: "operatingsystem", value: "RedHat")
      expect(response).to eq([{"certname" => "node1.example.com", "name" => "operatingsystem", "value" => "RedHat"}])
    end

    it "supports query parameter" do
      query_param = URI.encode_www_form({"query" => ["~", "name", "operating.*"].to_json})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/facts?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(node: "node1.example.com", query: ["~", "name", "operating.*"])
      expect(response).to eq([])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "5"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/facts?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(node: "node1.example.com", limit: 5)
      expect(response).to eq([])
    end
  end

  describe "#resources" do
    it "retrieves resources for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/resources")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","type":"File","title":"/etc/hosts"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(node: "node1.example.com")
      expect(response).to eq([{"certname" => "node1.example.com", "type" => "File", "title" => "/etc/hosts"}])
    end

    it "retrieves resources by type for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/resources/File")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","type":"File","title":"/etc/hosts"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(node: "node1.example.com", type: "File")
      expect(response).to eq([{"certname" => "node1.example.com", "type" => "File", "title" => "/etc/hosts"}])
    end

    it "retrieves resources by type and title for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/resources/File//etc/hosts")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","type":"File","title":"/etc/hosts"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(node: "node1.example.com", type: "File", title: "/etc/hosts")
      expect(response).to eq([{"certname" => "node1.example.com", "type" => "File", "title" => "/etc/hosts"}])
    end

    it "supports query parameter" do
      query_param = URI.encode_www_form({"query" => ["=", "type", "File"].to_json})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/resources?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(node: "node1.example.com", query: ["=", "type", "File"])
      expect(response).to eq([])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "20"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/nodes/node1.example.com/resources?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(node: "node1.example.com", limit: 20)
      expect(response).to eq([])
    end
  end
end
