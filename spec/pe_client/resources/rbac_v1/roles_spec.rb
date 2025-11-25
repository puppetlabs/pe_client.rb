# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/roles"

RSpec.describe PEClient::Resource::RBACV1::Roles do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:role_id) { "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" }

  describe "#get" do
    it "retrieves all roles" do
      stub_request(:get, "#{base_url}/rbac-api/v1/roles")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "role1", "display_name": "Operators"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"id" => "role1", "display_name" => "Operators"})
    end

    it "retrieves a specific role" do
      stub_request(:get, "#{base_url}/rbac-api/v1/roles/#{role_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "role1", "display_name": "Test Role"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(role_id)
      expect(response).to eq({"id" => "role1", "display_name" => "Test Role"})
    end
  end

  describe "#create" do
    it "creates a role" do
      stub_request(:post, "#{base_url}/rbac-api/v1/roles")
        .with(
          body: '{"permissions":[],"group_ids":[],"user_ids":[],"display_name":"New Role"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id": "new-role-id"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(
        permissions: [],
        group_ids: [],
        user_ids: [],
        display_name: "New Role"
      )
      expect(response).to eq({"id" => "new-role-id"})
    end

    it "creates a role with description and permissions" do
      stub_request(:post, "#{base_url}/rbac-api/v1/roles")
        .with(
          body: hash_including("description" => "Test role", "permissions" => ["aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"]),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})

      response = resource.create(
        permissions: ["aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"],
        group_ids: [],
        user_ids: [],
        display_name: "New Role",
        description: "Test role"
      )
      expect(response).to eq({})
    end
  end

  describe "#edit" do
    it "edits a role's attributes" do
      attributes = {"display_name" => "Updated Role", "permissions" => []}

      stub_request(:put, "#{base_url}/rbac-api/v1/roles/#{role_id}")
        .with(
          body: attributes.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})

      response = resource.edit(role_id, attributes)
      expect(response).to eq({})
    end
  end

  describe "#delete" do
    it "deletes a role" do
      stub_request(:delete, "#{base_url}/rbac-api/v1/roles/#{role_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.delete(role_id)
      expect(response).to eq({})
    end
  end

  describe "#add_users" do
    it "adds users to a role" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/roles/add-users")
        .with(
          body: '{"role_id":"role1","user_ids":["user1","user2"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.add_users("role1", ["user1", "user2"])
      expect(response).to eq({})
    end
  end

  describe "#remove_users" do
    it "removes users from a role" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/roles/remove-users")
        .with(
          body: '{"role_id":"role1","user_ids":["user1"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.remove_users("role1", ["user1"])
      expect(response).to eq({})
    end
  end

  describe "#add_groups" do
    it "adds groups to a role" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/roles/add-groups")
        .with(
          body: '{"role_id":"role1","group_ids":["group1"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.add_groups("role1", ["group1"])
      expect(response).to eq({})
    end
  end

  describe "#remove_groups" do
    it "removes groups from a role" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/roles/remove-groups")
        .with(
          body: '{"role_id":"role1","group_ids":["group1"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.remove_groups("role1", ["group1"])
      expect(response).to eq({})
    end
  end

  describe "#add_permissions" do
    it "adds permissions to a role" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/roles/add-permissions")
        .with(
          body: '{"role_id":"role1","permissions":[{"object_type":"nodes","action":"view"}]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.add_permissions("role1", [{"object_type" => "nodes", "action" => "view"}])
      expect(response).to eq({})
    end
  end

  describe "#remove_permissions" do
    it "removes permissions from a role" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/roles/remove-permissions")
        .with(
          body: '{"role_id":"role1","permissions":[{"object_type":"nodes","action":"view"}]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.remove_permissions("role1", [{"object_type" => "nodes", "action" => "view"}])
      expect(response).to eq({})
    end
  end
end
