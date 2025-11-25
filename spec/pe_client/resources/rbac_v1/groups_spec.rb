# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/groups"

RSpec.describe PEClient::Resource::RBACV1::Groups do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:group_sid) { "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" }

  describe "#get" do
    it "retrieves all groups" do
      stub_request(:get, "#{base_url}/rbac-api/v1/groups")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "group1", "display_name": "Administrators"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"id" => "group1", "display_name" => "Administrators"})
    end

    it "retrieves a specific group" do
      stub_request(:get, "#{base_url}/rbac-api/v1/groups/#{group_sid}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "group1", "display_name": "Test Group"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(group_sid)
      expect(response).to eq({"id" => "group1", "display_name" => "Test Group"})
    end
  end

  describe "#create" do
    it "creates a remote directory user group" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/groups")
        .with(
          body: '{"login":"ldap-group","role_ids":["role1"],"identity_provider_id":"uuid-123"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id": "new-group-id"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(
        login: "ldap-group",
        role_ids: ["role1"],
        identity_provider_id: "uuid-123"
      )
      expect(response).to eq({"id" => "new-group-id"})
    end

    it "creates a group with display name" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/groups")
        .with(
          body: '{"login":"ldap-group","role_ids":[],"identity_provider_id":"uuid-123","display_name":"Test Group"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.create(
        login: "ldap-group",
        role_ids: [],
        identity_provider_id: "uuid-123",
        display_name: "Test Group"
      )
      expect(response).to eq({})
    end
  end

  describe "#edit" do
    it "edits a group's attributes" do
      attributes = {"display_name" => "Updated Name", "role_ids" => ["role1", "role2"]}

      stub_request(:put, "#{base_url}/rbac-api/v1/groups/#{group_sid}")
        .with(
          body: attributes.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.edit(group_sid, attributes)
      expect(response).to eq({})
    end
  end

  describe "#delete" do
    it "deletes a group" do
      stub_request(:delete, "#{base_url}/rbac-api/v1/groups/#{group_sid}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.delete(group_sid)
      expect(response).to eq({})
    end
  end
end
