# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/import_hierarchy"

RSpec.describe PEClient::Resource::NodeClassifierV1::ImportHierarchy do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#replace" do
    it "replaces the entire node group hierarchy" do
      stub_request(:post, "#{base_url}/classifier-api/v1/import-hierarchy")
        .with(
          body: hash_including(
            "name" => "All Nodes",
            "environment" => "production",
            "environment_trumps" => false,
            "parent" => "00000000-0000-4000-8000-000000000000",
            "rule" => "~ name .*",
            "config_data" => {},
            "classes" => {}
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.replace(
        name: "All Nodes",
        environment: "production",
        environment_trumps: false,
        parent: "00000000-0000-4000-8000-000000000000",
        rule: "~ name .*",
        config_data: {}
      )
      expect(response).to eq({})
    end
  end
end
