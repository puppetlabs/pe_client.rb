# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v2"
require_relative "../../../../lib/pe_client/resources/rbac.v2/tokens"

RSpec.describe PEClient::Resource::RBACV2::Tokens do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#delete" do
    it "deletes a specific token" do
      stub_request(:delete, "#{base_url}/rbac-api/v2/tokens/token-to-delete")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.delete(token: "token-to-delete")
      expect(response).to eq({})
    end

    it "deletes tokens by complete token list" do
      stub_request(:delete, "#{base_url}/rbac-api/v2/tokens")
        .with(
          body: '{"revoke_tokens":["token1","token2"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.delete(revoke_tokens: ["token1", "token2"])
      expect(response).to eq({})
    end

    it "deletes tokens by usernames" do
      stub_request(:delete, "#{base_url}/rbac-api/v2/tokens")
        .with(
          body: '{"revoke_tokens_by_usernames":["user1","user2"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.delete(revoke_tokens_by_usernames: ["user1", "user2"])
      expect(response).to eq({})
    end

    it "deletes tokens by labels" do
      stub_request(:delete, "#{base_url}/rbac-api/v2/tokens")
        .with(
          body: '{"revoke_tokens_by_labels":["label1"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.delete(revoke_tokens_by_labels: ["label1"])
      expect(response).to eq({})
    end

    it "deletes tokens by user IDs" do
      stub_request(:delete, "#{base_url}/rbac-api/v2/tokens")
        .with(
          body: '{"revoke_tokens_by_ids":["user-id-1"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.delete(revoke_tokens_by_ids: ["user-id-1"])
      expect(response).to eq({})
    end
  end

  describe "#authenticate" do
    it "authenticates a token without updating last activity" do
      stub_request(:post, "#{base_url}/rbac-api/v2/auth/token/authenticate")
        .with(
          body: '{"token":"test-token","update_last_activity?":false}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"subject": "user1"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.authenticate("test-token")
      expect(response).to eq({"subject" => "user1"})
    end

    it "authenticates a token and updates last activity" do
      stub_request(:post, "#{base_url}/rbac-api/v2/auth/token/authenticate")
        .with(
          body: '{"token":"test-token","update_last_activity?":true}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.authenticate("test-token", update_last_activity: true)
      expect(response).to eq({})
    end
  end
end
