# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/rbac.v2"

RSpec.describe PEClient::Resource::RBACV2 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#users" do
    it "returns a Users resource" do
      users = resource.users
      expect(users).to be_a(PEClient::Resource::RBACV2::Users)
    end

    it "memorizes the resource" do
      users1 = resource.users
      users2 = resource.users
      expect(users1).to equal(users2)
    end
  end

  describe "#groups" do
    it "returns a Groups resource" do
      groups = resource.groups
      expect(groups).to be_a(PEClient::Resource::RBACV2::Groups)
    end

    it "memorizes the resource" do
      groups1 = resource.groups
      groups2 = resource.groups
      expect(groups1).to equal(groups2)
    end
  end

  describe "#tokens" do
    it "returns a Tokens resource" do
      tokens = resource.tokens
      expect(tokens).to be_a(PEClient::Resource::RBACV2::Tokens)
    end

    it "memorizes the resource" do
      tokens1 = resource.tokens
      tokens2 = resource.tokens
      expect(tokens1).to equal(tokens2)
    end
  end

  describe "#ldap" do
    it "returns an LDAP resource" do
      ldap = resource.ldap
      expect(ldap).to be_a(PEClient::Resource::RBACV2::LDAP)
    end

    it "memorizes the resource" do
      ldap1 = resource.ldap
      ldap2 = resource.ldap
      expect(ldap1).to equal(ldap2)
    end
  end
end
