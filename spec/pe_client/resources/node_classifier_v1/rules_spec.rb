# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/rules"

RSpec.describe PEClient::Resource::NodeClassifierV1::Rules do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:rule) { ["=", ["fact", "is_spaceship"], "true"] }

  describe "#translate" do
    it "translates rules to the default nodes format" do
      stub_request(:post, "#{base_url}/classifier-api/v1/rules/translate")
        .with(
          body: rule.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "nodes { fact.is_spaceship = 'true' }",
          headers: {"Content-Type" => "text/plain"}
        )

      response = resource.translate(rule: rule)
      expect(response).to eq("nodes { fact.is_spaceship = 'true' }")
    end

    it "translates rules to inventory format" do
      stub_request(:post, "#{base_url}/classifier-api/v1/rules/translate?format=inventory")
        .with(
          body: rule.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "inventory { facts.is_spaceship = 'true' }",
          headers: {"Content-Type" => "text/plain"}
        )

      response = resource.translate(rule: rule, format: "inventory")
      expect(response).to eq("inventory { facts.is_spaceship = 'true' }")
    end
  end
end
