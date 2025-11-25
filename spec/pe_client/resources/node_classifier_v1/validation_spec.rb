# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/validation"

RSpec.describe PEClient::Resource::NodeClassifierV1::Validation do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#group" do
    it "validates a node group" do
      stub_request(:post, "#{base_url}/classifier-api/v1/validate/group")
        .with(
          body: hash_including(
            "name" => "Test Group",
            "environment" => "production",
            "environment_trumps" => false,
            "parent" => "00000000-0000-4000-8000-000000000000",
            "rule" => "~ name .*",
            "classes" => {}
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"valid": true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.group(
        name: "Test Group",
        environment: "production",
        environment_trumps: false,
        parent: "00000000-0000-4000-8000-000000000000",
        rule: "~ name .*"
      )
      expect(response).to eq({"valid" => true})
    end
  end
end
