# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/nodes"

RSpec.describe PEClient::Resource::NodeClassifierV1::Nodes do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves check-in history for all nodes" do
      stub_request(:get, "#{base_url}/classifier-api/v1/nodes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"nodes": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"nodes" => []})
    end

    it "retrieves check-in history for a specific node" do
      stub_request(:get, "#{base_url}/classifier-api/v1/nodes/node1.example.com")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name": "node1.example.com"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(node: "node1.example.com")
      expect(response).to eq({"name" => "node1.example.com"})
    end

    it "retrieves check-in history with limit and offset" do
      stub_request(:get, "#{base_url}/classifier-api/v1/nodes?limit=10&offset=5")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"nodes": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(limit: 10, offset: 5)
      expect(response).to eq({"nodes" => []})
    end
  end
end
