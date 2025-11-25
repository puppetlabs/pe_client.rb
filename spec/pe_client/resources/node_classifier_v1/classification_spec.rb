# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/classification"

RSpec.describe PEClient::Resource::NodeClassifierV1::Classification do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves classification for a node with facts" do
      stub_request(:post, "#{base_url}/classifier-api/v1/classified/nodes/node1.example.com")
        .with(
          body: '{"fact":{"operatingsystem":"RedHat"}}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"name": "node1.example.com", "classes": {}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get("node1.example.com", fact: {"operatingsystem" => "RedHat"})
      expect(response).to eq({"name" => "node1.example.com", "classes" => {}})
    end

    it "retrieves classification with trusted facts" do
      stub_request(:post, "#{base_url}/classifier-api/v1/classified/nodes/node1.example.com")
        .with(
          body: '{"fact":{"os":"linux"},"trusted":{"certname":"node1.example.com"}}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})

      response = resource.get("node1.example.com", fact: {"os" => "linux"}, trusted: {"certname" => "node1.example.com"})
      expect(response).to eq({})
    end
  end

  describe "#explanation" do
    it "retrieves detailed explanation for node classification" do
      stub_request(:post, "#{base_url}/classifier-api/v1/classified/nodes/node1.example.com/explanation")
        .with(
          body: '{"fact":{},"trusted":{}}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"explanation": "details"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.explanation("node1.example.com")
      expect(response).to eq({"explanation" => "details"})
    end
  end
end
