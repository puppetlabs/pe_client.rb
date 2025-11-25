# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/last_class_update"

RSpec.describe PEClient::Resource::NodeClassifierV1::LastClassUpdate do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves the last class update time" do
      stub_request(:get, "#{base_url}/classifier-api/v1/last-class-update")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"last_update_time": "2025-11-24T12:00:00Z"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"last_update_time" => "2025-11-24T12:00:00Z"})
    end
  end
end
