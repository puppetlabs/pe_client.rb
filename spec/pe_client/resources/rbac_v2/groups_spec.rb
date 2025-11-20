# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v2"
require_relative "../../../../lib/pe_client/resources/rbac.v2/groups"

RSpec.describe PEClient::Resource::RBACV2::Groups do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#create" do
    it "creates a group with minimal parameters" do
      stub_request(:post, "#{base_url}/rbac-api/v2/groups")
        .with(
          body: '{"login":"ldap-group","role_ids":["role1"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id": "new-group-id"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(login: "ldap-group", role_ids: ["role1"])
      expect(response).to eq({"id" => "new-group-id"})
    end

    it "creates a group with all optional parameters" do
      stub_request(:post, "#{base_url}/rbac-api/v2/groups")
        .with(
          body: '{"login":"ldap-group","role_ids":[],"display_name":"Test Group","identity_provider_id":"uuid-123","validate":false}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.create(
        login: "ldap-group",
        role_ids: [],
        display_name: "Test Group",
        identity_provider_id: "uuid-123",
        validate: false
      )
      expect(response).to eq({})
    end
  end
end
