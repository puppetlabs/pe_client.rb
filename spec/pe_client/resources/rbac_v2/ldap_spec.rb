# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v2"
require_relative "../../../../lib/pe_client/resources/rbac.v2/ldap"

RSpec.describe PEClient::Resource::RBACV2::LDAP do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves all LDAP connections" do
      stub_request(:get, "#{base_url}/rbac-api/v2/ldap")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"id": "ldap1", "display_name": "Corporate LDAP"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([{"id" => "ldap1", "display_name" => "Corporate LDAP"}])
    end

    it "retrieves a specific LDAP connection" do
      stub_request(:get, "#{base_url}/rbac-api/v2/ldap/ldap-uuid-123")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "ldap-uuid-123", "display_name": "Test LDAP"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(uuid: "ldap-uuid-123")
      expect(response).to eq({"id" => "ldap-uuid-123", "display_name" => "Test LDAP"})
    end
  end
end
