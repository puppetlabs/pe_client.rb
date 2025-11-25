# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v2"
require_relative "../../../../lib/pe_client/resources/rbac.v2/users"

RSpec.describe PEClient::Resource::RBACV2::Users do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves all users with default parameters" do
      stub_request(:get, "#{base_url}/rbac-api/v2/users")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"users": [{"id": "user1", "login": "admin"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"users" => [{"id" => "user1", "login" => "admin"}]})
    end

    it "retrieves users with filtering and sorting" do
      stub_request(:get, "#{base_url}/rbac-api/v2/users?offset=10&limit=50&order=desc&order_by=login&filter=example&include_roles=true")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"users": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(
        offset: 10,
        limit: 50,
        order: "desc",
        order_by: "login",
        filter: "example",
        include_roles: true
      )
      expect(response).to eq({"users" => []})
    end
  end
end
