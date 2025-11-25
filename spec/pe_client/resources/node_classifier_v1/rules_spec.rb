# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/rules"

RSpec.describe PEClient::Resource::NodeClassifierV1::Rules do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#translate" do
    it "translates rules to default format" do
      stub_request(:get, "#{base_url}/classifier-api/v1/rules/translate")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"query": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.translate
      expect(response).to eq({"query" => []})
    end

    it "translates rules to inventory format" do
      stub_request(:get, "#{base_url}/classifier-api/v1/rules/translate?format=inventory")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"query": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.translate(format: "inventory")
      expect(response).to eq({"query" => []})
    end
  end
end
