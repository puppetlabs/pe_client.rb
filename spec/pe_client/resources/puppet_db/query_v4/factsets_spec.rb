# frozen_string_literal: true

require "uri"
require_relative "../../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4/factsets"

RSpec.describe PEClient::Resource::PuppetDB::QueryV4::Factsets do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:resource) { described_class.new(puppetdb.instance_variable_get(:@client)) }

  describe "#get" do
    it "retrieves all factsets" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/factsets")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","timestamp":"2025-01-01T00:00:00Z","facts":{"operatingsystem":"RedHat"}}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([{
        "certname" => "node1.example.com",
        "timestamp" => "2025-01-01T00:00:00Z",
        "facts" => {"operatingsystem" => "RedHat"}
      }])
    end

    it "retrieves factset for a specific node" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/factsets/node1.example.com")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"certname":"node1.example.com","timestamp":"2025-01-01T00:00:00Z","facts":{"operatingsystem":"RedHat","kernel":"Linux"}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(node: "node1.example.com")
      expect(response).to eq({
        "certname" => "node1.example.com",
        "timestamp" => "2025-01-01T00:00:00Z",
        "facts" => {"operatingsystem" => "RedHat", "kernel" => "Linux"}
      })
    end

    it "supports query parameter" do
      query_param = URI.encode_www_form({"query" => ["=", "certname", "node1.example.com"].to_json})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/factsets?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","facts":{}}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(query: ["=", "certname", "node1.example.com"])
      expect(response).to eq([{"certname" => "node1.example.com", "facts" => {}}])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "10", "offset" => "5"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/factsets?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(limit: 10, offset: 5)
      expect(response).to eq([])
    end
  end

  describe "#facts" do
    it "retrieves facts for a specific factset" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/factsets/node1.example.com/facts")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","name":"operatingsystem","value":"RedHat"},{"certname":"node1.example.com","name":"kernel","value":"Linux"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(node: "node1.example.com")
      expect(response).to eq([
        {"certname" => "node1.example.com", "name" => "operatingsystem", "value" => "RedHat"},
        {"certname" => "node1.example.com", "name" => "kernel", "value" => "Linux"}
      ])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "5"})
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/factsets/node1.example.com/facts?#{query_param}")
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

    it "returns facts even for deactivated nodes" do
      stub_request(:get, "https://puppet.example.com:8080/pdb/query/v4/factsets/deactivated.node.com/facts")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"deactivated.node.com","name":"operatingsystem","value":"Ubuntu"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.facts(node: "deactivated.node.com")
      expect(response).to eq([{"certname" => "deactivated.node.com", "name" => "operatingsystem", "value" => "Ubuntu"}])
    end
  end
end
