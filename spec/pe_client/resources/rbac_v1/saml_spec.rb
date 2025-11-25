# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/saml"

RSpec.describe PEClient::Resource::RBACV1::SAML do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#configure" do
    it "configures SAML settings" do
      saml_config = {
        "idp_entity_id" => "https://idp.example.com",
        "idp_sso_url" => "https://idp.example.com/sso"
      }

      stub_request(:put, "#{base_url}/rbac-api/v1/saml/configure")
        .with(
          body: saml_config.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.configure(saml_config)
      expect(response).to eq({})
    end
  end

  describe "#get" do
    it "retrieves current SAML configuration" do
      stub_request(:get, "#{base_url}/rbac-api/v1/saml")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"idp_entity_id": "https://idp.example.com"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"idp_entity_id" => "https://idp.example.com"})
    end
  end

  describe "#delete" do
    it "removes SAML configuration" do
      stub_request(:delete, "#{base_url}/rbac-api/v1/saml")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.delete
      expect(response).to eq({})
    end
  end

  describe "#meta" do
    it "retrieves SAML metadata" do
      stub_request(:get, "#{base_url}/rbac-api/v1/saml/meta")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"certificate": "cert-data", "url": "https://pe.example.com/saml"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.meta
      expect(response).to eq({"certificate" => "cert-data", "url" => "https://pe.example.com/saml"})
    end
  end
end
