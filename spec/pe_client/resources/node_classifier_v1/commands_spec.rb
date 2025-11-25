# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/commands"

RSpec.describe PEClient::Resource::NodeClassifierV1::Commands do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#unpin_from_all" do
    it "unpins nodes from all groups" do
      stub_request(:post, "#{base_url}/classifier-api/v1/commands/unpin-from-all")
        .with(
          body: '{"nodes":["node1.example.com","node2.example.com"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.unpin_from_all(["node1.example.com", "node2.example.com"])
      expect(response).to eq({})
    end
  end
end
