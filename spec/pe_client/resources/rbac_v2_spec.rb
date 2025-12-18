# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/rbac.v2"

RSpec.describe PEClient::Resource::RBACV2 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  subject(:resource) { described_class.new(client) }

  it_behaves_like "a memoized resource", :users, "PEClient::Resource::RBACV2::Users"
  it_behaves_like "a memoized resource", :groups, "PEClient::Resource::RBACV2::Groups"
  it_behaves_like "a memoized resource", :tokens, "PEClient::Resource::RBACV2::Tokens"
  it_behaves_like "a memoized resource", :ldap, "PEClient::Resource::RBACV2::LDAP"
end
