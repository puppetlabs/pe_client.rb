# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/ldap"

RSpec.describe PEClient::Resource::RBACV1::LDAP do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#create" do
    it "creates a new LDAP connection" do
      ldap_config = {
        "display_name" => "Corporate LDAP",
        "hostname" => "ldap.example.com",
        "port" => 389,
        "base_dn" => "dc=example,dc=com"
      }

      stub_request(:post, "#{base_url}/rbac-api/v1/command/ldap/create")
        .with(
          body: ldap_config.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id": "ldap-conn-id"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(ldap_config)
      expect(response).to eq({"id" => "ldap-conn-id"})
    end
  end

  describe "#update" do
    it "updates an LDAP connection" do
      ldap_config = {"hostname" => "ldap2.example.com"}

      stub_request(:put, "#{base_url}/rbac-api/v1/command/ldap/update")
        .with(
          body: ldap_config.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.update(ldap_config)
      expect(response).to eq({})
    end
  end

  describe "#delete" do
    it "deletes an LDAP connection" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/ldap/delete")
        .with(
          body: '{"id":"ldap-conn-id"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.delete("ldap-conn-id")
      expect(response).to eq({})
    end
  end

  describe "#test" do
    it "tests an LDAP connection" do
      ldap_config = {"hostname" => "ldap.example.com", "port" => 389}

      stub_request(:post, "#{base_url}/rbac-api/v1/command/ldap/test")
        .with(
          body: ldap_config.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"success": true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.test(ldap_config)
      expect(response).to eq({"success" => true})
    end
  end
end
