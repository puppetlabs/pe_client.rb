# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/tokens"

RSpec.describe PEClient::Resource::RBACV1::Tokens do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#generate" do
    it "generates an authentication token" do
      stub_request(:post, "#{base_url}/rbac-api/v1/auth/token")
        .with(
          body: '{"login":"admin","password":"secret"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"token": "generated-token-123"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.generate(login: "admin", password: "secret")
      expect(response).to eq({"token" => "generated-token-123"})
    end

    it "generates a token with lifetime and label" do
      stub_request(:post, "#{base_url}/rbac-api/v1/auth/token")
        .with(
          body: '{"login":"admin","password":"secret","lifetime":"1h","label":"test-token"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"token": "token-123"}', headers: {"Content-Type" => "application/json"})

      response = resource.generate(login: "admin", password: "secret", lifetime: "1h", label: "test-token")
      expect(response).to eq({"token" => "token-123"})
    end
  end

  describe "#create" do
    it "creates a token for the authenticated user" do
      stub_request(:post, "#{base_url}/rbac-api/v1/tokens")
        .with(
          body: hash_including("lifetime" => "8h", "description" => "API token"),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"token": "created-token-456"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(lifetime: "8h", description: "API token")
      expect(response).to eq({"token" => "created-token-456"})
    end
  end
end
