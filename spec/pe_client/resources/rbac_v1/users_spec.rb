# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/users"

RSpec.describe PEClient::Resource::RBACV1::Users do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }
  let(:user_sid) { "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" }

  describe "#get" do
    it "retrieves all users when no SID is provided" do
      stub_request(:get, "#{base_url}/rbac-api/v1/users")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "user1", "login": "admin"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"id" => "user1", "login" => "admin"})
    end

    it "retrieves a specific user when SID is provided" do
      stub_request(:get, "#{base_url}/rbac-api/v1/users/#{user_sid}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "user1", "login": "admin", "email": "admin@example.com"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(user_sid)
      expect(response).to eq({"id" => "user1", "login" => "admin", "email" => "admin@example.com"})
    end
  end

  describe "#current" do
    it "retrieves information about the current user" do
      stub_request(:get, "#{base_url}/rbac-api/v1/users/current")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id": "current_user", "login": "current"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.current
      expect(response).to eq({"id" => "current_user", "login" => "current"})
    end
  end

  describe "#tokens" do
    it "retrieves tokens for a user" do
      stub_request(:get, "#{base_url}/rbac-api/v1/users/#{user_sid}/tokens")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"token": "abc123"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.tokens(user_sid)
      expect(response).to eq({"token" => "abc123"})
    end
  end

  describe "#create" do
    it "creates a new local user" do
      stub_request(:post, "#{base_url}/rbac-api/v1/users")
        .with(
          body: '{"email":"user@example.com","display_name":"Test User","login":"testuser","role_ids":[],"password":null}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})

      response = resource.create(
        email: "user@example.com",
        display_name: "Test User",
        login: "testuser"
      )
      expect(response).to eq({})
    end

    it "creates a user with role_ids and password" do
      stub_request(:post, "#{base_url}/rbac-api/v1/users")
        .with(
          body: hash_including(
            "role_ids" => ["role1", "role2"],
            "password" => "secure_password"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})

      response = resource.create(
        email: "user@example.com",
        display_name: "Test User",
        login: "testuser",
        role_ids: ["role1", "role2"],
        password: "secure_password"
      )
      expect(response).to eq({})
    end
  end

  describe "#edit" do
    it "edits a user's attributes" do
      attributes = {
        "id" => user_sid,
        "login" => "testuser",
        "email" => "newemail@example.com",
        "display_name" => "Updated Name"
      }

      stub_request(:put, "#{base_url}/rbac-api/v1/users/#{user_sid}")
        .with(
          body: attributes.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})

      response = resource.edit(user_sid, attributes)
      expect(response).to eq({})
    end
  end

  describe "#delete" do
    it "deletes a user" do
      stub_request(:delete, "#{base_url}/rbac-api/v1/users/#{user_sid}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.delete(user_sid)
      expect(response).to eq({})
    end
  end

  describe "#add_roles" do
    it "adds roles to a user" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/users/command/users/add-roles")
        .with(
          body: '{"user_id":"user123","role_ids":["role1","role2"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.add_roles("user123", ["role1", "role2"])
      expect(response).to eq({})
    end
  end

  describe "#remove_roles" do
    it "removes roles from a user" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/users/command/users/remove-roles")
        .with(
          body: '{"user_id":"user123","role_ids":["role1"]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.remove_roles("user123", ["role1"])
      expect(response).to eq({})
    end
  end

  describe "#revoke" do
    it "revokes a user's access" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/users/command/users/revoke")
        .with(
          body: '{"user_id":"user123"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.revoke("user123")
      expect(response).to eq({})
    end
  end

  describe "#reinstate" do
    it "reinstates a revoked user" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/users/command/users/reinstate")
        .with(
          body: '{"user_id":"user123"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.reinstate("user123")
      expect(response).to eq({})
    end
  end
end
