# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/group_children"

RSpec.describe PEClient::Resource::NodeClassifierV1::GroupChildren do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }
  let(:group_id) { "00000000-0000-4000-8000-000000000000" }

  describe "#get" do
    it "retrieves all descendants of a group" do
      stub_request(:get, "#{base_url}/classifier-api/v1/group-children/#{group_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"id": "child1"}, {"id": "child2"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(group_id)
      expect(response).to eq([{"id" => "child1"}, {"id" => "child2"}])
    end

    it "retrieves descendants with depth limit" do
      stub_request(:get, "#{base_url}/classifier-api/v1/group-children/#{group_id}?depth=2")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"id": "child1"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(group_id, depth: 2)
      expect(response).to eq([{"id" => "child1"}])
    end
  end
end
