# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/passwords"

RSpec.describe PEClient::Resource::RBACV1::Passwords do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:user_uuid) { "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" }

  describe "#generate_reset_token" do
    it "generates a password reset token" do
      stub_request(:post, "#{base_url}/rbac-api/v1/users/#{user_uuid}/password/reset")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"token": "reset-token-123"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.generate_reset_token(user_uuid)
      expect(response).to eq({"token" => "reset-token-123"})
    end
  end

  describe "#reset" do
    it "resets a password using a token" do
      stub_request(:post, "#{base_url}/rbac-api/v1/auth/reset")
        .with(
          body: '{"token":"reset-token-123","password":"newpassword"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{}', headers: {"Content-Type" => "application/json"})

      response = resource.reset("reset-token-123", "newpassword")
      expect(response).to eq({})
    end
  end

  describe "#change" do
    it "changes the current user's password" do
      stub_request(:put, "#{base_url}/rbac-api/v1/users/current/password")
        .with(
          body: '{"current_password":"oldpassword","password":"newpassword"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.change("oldpassword", "newpassword")
      expect(response).to eq({})
    end
  end

  describe "#validate_password" do
    it "validates a password" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/validate-password")
        .with(
          body: '{"password":"testpassword"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"valid": true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.validate_password("testpassword")
      expect(response).to eq({"valid" => true})
    end

    it "validates a password with reset token" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/validate-password")
        .with(
          body: '{"password":"testpassword","reset_token":"token-123"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"valid": true}', headers: {"Content-Type" => "application/json"})

      response = resource.validate_password("testpassword", reset_token: "token-123")
      expect(response).to eq({"valid" => true})
    end
  end

  describe "#validate_login" do
    it "validates a login name" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/validate-login")
        .with(
          body: '{"login":"testuser"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"valid": true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.validate_login("testuser")
      expect(response).to eq({"valid" => true})
    end
  end
end
