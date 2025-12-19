# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/node_inventory.v1"

RSpec.describe PEClient::Resource::NodeInventoryV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#connections" do
    it "queries connections with all parameters" do
      stub_request(:post, "https://puppet.example.com:8143/inventory/v1/query/connections")
        .with(
          body: '{"certnames":["node1.example.com"],"sensitive":true,"extract":["type","parameters"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"connection_id": "1"}', headers: {"Content-Type" => "application/json"})

      response = resource.connections(
        certnames: ["node1.example.com"],
        sensitive: true,
        extract: ["type", "parameters"]
      )
      expect(response).to eq({"connection_id" => "1"})
    end
  end

  describe "#create_connections" do
    it "creates a new connection with all parameters" do
      stub_request(:post, "https://puppet.example.com:8143/inventory/v1/command/create-connection")
        .with(
          body: hash_including(
            "certnames" => ["node1.example.com"],
            "type" => "ssh",
            "parameters" => {"port" => 22},
            "sensitive_parameters" => {"password" => "secret"},
            "duplicates" => "replace"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"connection_id": "new-id"}', headers: {"Content-Type" => "application/json"})

      response = resource.create_connections(
        certnames: ["node1.example.com"],
        type: "ssh",
        parameters: {port: 22},
        sensitive_parameters: {password: "secret"},
        duplicates: "replace"
      )
      expect(response).to eq({"connection_id" => "new-id"})
    end
  end

  describe "#delete_connections" do
    it "deletes connections for specified certnames" do
      stub_request(:post, "https://puppet.example.com:8143/inventory/v1/command/delete-connection")
        .with(
          body: '{"certnames":["node1.example.com","node2.example.com"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.delete_connections(["node1.example.com", "node2.example.com"])
      expect(response).to eq({})
    end
  end
end
