# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/classes"

RSpec.describe PEClient::Resource::NodeClassifierV1::Classes do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves all classes" do
      stub_request(:get, "#{base_url}/classifier-api/v1/classes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name": "apache", "environment": "production"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([{"name" => "apache", "environment" => "production"}])
    end
  end
end
