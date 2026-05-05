# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/import_hierarchy"

RSpec.describe PEClient::Resource::NodeClassifierV1::ImportHierarchy do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:node_groups) do
    [
      {
        environment_trumps: false,
        parent: "00000000-0000-4000-8000-000000000000",
        name: "My Nodes",
        variables: {},
        id: "085e2797-32f3-4920-9412-8e9decf4ef65",
        environment: "production",
        rule: ["~", "name", ".*"],
        classes: {},
        config_data: {},
        description: ""
      }
    ]
  end

  describe "#replace" do
    it "replaces the entire node group hierarchy with an array of node groups" do
      stub_request(:post, "#{base_url}/classifier-api/v1/import-hierarchy")
        .with(
          body: node_groups.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.replace(node_groups)
      expect(response).to eq({})
    end
  end
end
