# frozen_string_literal: true

require "uri"
require_relative "../../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4/catalogs"

RSpec.describe PEClient::Resource::PuppetDB::QueryV4::Catalogs do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:resource) { described_class.new(puppetdb.instance_variable_get(:@client)) }

  describe "#get" do
    it "retrieves all catalogs" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","version":"1234567890","producer_timestamp":"2025-01-01T00:00:00Z"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([{
        "certname" => "node1.example.com",
        "version" => "1234567890",
        "producer_timestamp" => "2025-01-01T00:00:00Z"
      }])
    end

    it "retrieves catalog for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs/node1.example.com")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"certname":"node1.example.com","version":"1234567890","environment":"production","edges":[],"resources":[]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(node: "node1.example.com")
      expect(response).to eq({
        "certname" => "node1.example.com",
        "version" => "1234567890",
        "environment" => "production",
        "edges" => [],
        "resources" => []
      })
    end

    it "supports query parameter" do
      query_param = URI.encode_www_form({"query" => ["=", "certname", "node1.example.com"].to_json})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(query: ["=", "certname", "node1.example.com"])
      expect(response).to eq([{"certname" => "node1.example.com"}])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "10", "offset" => "0"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs?#{query_param}")
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

  describe "#edges" do
    it "retrieves edges for a specific catalog" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs/node1.example.com/edges")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","source_type":"File","source_title":"/etc/hosts","target_type":"Service","target_title":"networking","relationship":"before"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.edges(node: "node1.example.com")
      expect(response).to eq([{
        "certname" => "node1.example.com",
        "source_type" => "File",
        "source_title" => "/etc/hosts",
        "target_type" => "Service",
        "target_title" => "networking",
        "relationship" => "before"
      }])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "10"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs/node1.example.com/edges?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.edges(node: "node1.example.com", limit: 10)
      expect(response).to eq([])
    end

    it "returns edges even for deactivated nodes" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs/deactivated.node.com/edges")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.edges(node: "deactivated.node.com")
      expect(response).to eq([])
    end
  end

  describe "#resources" do
    it "retrieves resources for a specific catalog" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs/node1.example.com/resources")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","type":"File","title":"/etc/hosts","parameters":{"ensure":"file"}}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(node: "node1.example.com")
      expect(response).to eq([{
        "certname" => "node1.example.com",
        "type" => "File",
        "title" => "/etc/hosts",
        "parameters" => {"ensure" => "file"}
      }])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "20"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs/node1.example.com/resources?#{query_param}")
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

    it "returns resources even for deactivated nodes" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/catalogs/deactivated.node.com/resources")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"deactivated.node.com","type":"File","title":"/tmp/test"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.resources(node: "deactivated.node.com")
      expect(response).to eq([{"certname" => "deactivated.node.com", "type" => "File", "title" => "/tmp/test"}])
    end
  end
end
