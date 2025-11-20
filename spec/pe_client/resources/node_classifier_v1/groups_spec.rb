# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/groups"

RSpec.describe PEClient::Resource::NodeClassifierV1::Groups do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }
  let(:group_id) { "00000000-0000-4000-8000-000000000000" }

  describe "#get" do
    it "retrieves all groups" do
      stub_request(:get, "#{base_url}/classifier-api/v1/groups")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"id": "group1", "name": "All Nodes"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([{"id" => "group1", "name" => "All Nodes"}])
    end

    it "retrieves a specific group" do
      stub_request(:get, "#{base_url}/classifier-api/v1/groups/#{group_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "group1", "name": "Test Group"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(group_id)
      expect(response).to eq({"id" => "group1", "name" => "Test Group"})
    end
  end

  describe "#create" do
    it "creates a group with minimal parameters" do
      stub_request(:post, "#{base_url}/classifier-api/v1/groups")
        .with(
          body: hash_including("name" => "New Group", "parent" => "00000000-0000-4000-8000-000000000000", "classes" => {}),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"id": "new-group-id"}', headers: {"Content-Type" => "application/json"})

      response = resource.create(name: "New Group", parent: "00000000-0000-4000-8000-000000000000")
      expect(response).to eq({"id" => "new-group-id"})
    end

    it "creates a group with specific ID" do
      new_group_id = "11111111-1111-4000-8000-000000000000"
      stub_request(:put, "#{base_url}/classifier-api/v1/groups/#{new_group_id}")
        .with(
          body: hash_including("name" => "New Group", "parent" => "00000000-0000-4000-8000-000000000000"),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})

      response = resource.create(name: "New Group", parent: "00000000-0000-4000-8000-000000000000", id: new_group_id)
      expect(response).to eq({})
    end
  end

  describe "#update" do
    it "updates a group's attributes" do
      stub_request(:post, "#{base_url}/classifier-api/v1/groups/#{group_id}")
        .with(
          body: '{"name":"Updated Name"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.update(group_id, {"name" => "Updated Name"})
      expect(response).to eq({})
    end
  end

  describe "#delete" do
    it "deletes a group" do
      stub_request(:delete, "#{base_url}/classifier-api/v1/groups/#{group_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.delete(group_id)
      expect(response).to eq({})
    end
  end

  describe "#pin" do
    it "pins nodes to a group" do
      stub_request(:post, "#{base_url}/classifier-api/v1/groups/#{group_id}/pin")
        .with(
          body: '{"nodes":["node1.example.com","node2.example.com"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.pin(group_id, ["node1.example.com", "node2.example.com"])
      expect(response).to eq({})
    end
  end

  describe "#unpin" do
    it "unpins nodes from a group" do
      stub_request(:post, "#{base_url}/classifier-api/v1/groups/#{group_id}/unpin")
        .with(
          body: '{"nodes":["node1.example.com"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.unpin(group_id, ["node1.example.com"])
      expect(response).to eq({})
    end
  end

  describe "#rules" do
    it "retrieves rules for a group" do
      stub_request(:get, "#{base_url}/classifier-api/v1/groups/#{group_id}/rules")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"rules": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.rules(group_id)
      expect(response).to eq({"rules" => []})
    end
  end

  describe "#nodes" do
    it "retrieves nodes in a group" do
      stub_request(:get, "#{base_url}/classifier-api/v1/groups/#{group_id}/nodes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"nodes": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.nodes(group_id)
      expect(response).to eq({"nodes" => []})
    end
  end
end
