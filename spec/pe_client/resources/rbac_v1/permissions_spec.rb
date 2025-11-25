# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/permissions"

RSpec.describe PEClient::Resource::RBACV1::Permissions do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#types" do
    it "retrieves all permission types" do
      stub_request(:get, "#{base_url}/types")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"object_type": "nodes", "actions": ["view", "edit"]}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.types
      expect(response).to eq([{"object_type" => "nodes", "actions" => ["view", "edit"]}])
    end
  end

  describe "#permitted" do
    it "checks if a user has specific permissions" do
      stub_request(:post, "#{base_url}/rbac-api/v1/permitted")
        .with(
          body: '{"token":"user-token","permissions":[{"object_type":"nodes","action":"view","instance":"*"}]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[true]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.permitted(
        token: "user-token",
        permissions: [{"object_type" => "nodes", "action" => "view", "instance" => "*"}]
      )
      expect(response).to eq([true])
    end
  end

  describe "#instances" do
    it "retrieves instances the authenticated user can access" do
      stub_request(:get, "#{base_url}/rbac-api/v1/permitted/nodes/view")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '["instance1", "instance2"]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.instances(object_type: "nodes", action: "view")
      expect(response).to eq(["instance1", "instance2"])
    end
  end

  describe "#user_instances" do
    it "retrieves instances a specific user can access" do
      stub_request(:get, "#{base_url}/rbac-api/v1/permitted/nodes/view/user-uuid-123")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '["instance1"]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.user_instances(object_type: "nodes", action: "view", uuid: "user-uuid-123")
      expect(response).to eq(["instance1"])
    end
  end
end
