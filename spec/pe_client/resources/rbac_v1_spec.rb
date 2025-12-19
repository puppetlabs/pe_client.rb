# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/rbac.v1"

RSpec.describe PEClient::Resource::RBACV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  subject(:resource) { described_class.new(client) }

  include_examples "a memoized resource", :users, "PEClient::Resource::RBACV1::Users"
  include_examples "a memoized resource", :groups, "PEClient::Resource::RBACV1::Groups"
  include_examples "a memoized resource", :roles, "PEClient::Resource::RBACV1::Roles"
  include_examples "a memoized resource", :permissions, "PEClient::Resource::RBACV1::Permissions"
  include_examples "a memoized resource", :tokens, "PEClient::Resource::RBACV1::Tokens"
  include_examples "a memoized resource", :ldap, "PEClient::Resource::RBACV1::LDAP"
  include_examples "a memoized resource", :saml, "PEClient::Resource::RBACV1::SAML"
  include_examples "a memoized resource", :passwords, "PEClient::Resource::RBACV1::Passwords"
  include_examples "a memoized resource", :disclaimer, "PEClient::Resource::RBACV1::Disclaimer"
end
