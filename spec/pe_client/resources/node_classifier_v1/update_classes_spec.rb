# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/update_classes"

RSpec.describe PEClient::Resource::NodeClassifierV1::UpdateClasses do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#update" do
    it "triggers class update for all environments" do
      stub_request(:post, "#{base_url}/classifier-api/v1/update-classes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.update
      expect(response).to eq({})
    end

    it "triggers class update for a specific environment" do
      stub_request(:post, "#{base_url}/classifier-api/v1/update-classes?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.update(environment: "production")
      expect(response).to eq({})
    end
  end
end
