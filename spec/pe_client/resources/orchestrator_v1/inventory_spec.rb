# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/inventory"

RSpec.describe PEClient::Resource::OrchestratorV1::Inventory do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves a list of all nodes connected to the PCP broker" do
      stub_request(:get, "#{base_url}/orchestrator/v1/inventory")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"name":"node1.example.com","connected":true}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"items" => [{"name" => "node1.example.com", "connected" => true}]})
    end

    it "retrieves information about a single node's connection" do
      stub_request(:get, "#{base_url}/orchestrator/v1/inventory/node1.example.com")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"node1.example.com","connected":true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get("node1.example.com")
      expect(response).to eq({"name" => "node1.example.com", "connected" => true})
    end
  end

  describe "#get_multiple" do
    it "returns information about multiple nodes' connections" do
      stub_request(:post, "#{base_url}/orchestrator/v1/inventory")
        .with(
          body: {"nodes" => ["node1.example.com", "node2.example.com"]},
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"items":[{"name":"node1.example.com","connected":true},{"name":"node2.example.com","connected":false}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get_multiple(["node1.example.com", "node2.example.com"])
      expect(response).to eq({"items" => [
        {"name" => "node1.example.com", "connected" => true},
        {"name" => "node2.example.com", "connected" => false}
      ]})
    end
  end
end
