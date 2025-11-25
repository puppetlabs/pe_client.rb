# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/rbac.v1"

RSpec.describe PEClient::Resource::RBACV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#users" do
    it "returns a Users resource" do
      users = resource.users
      expect(users).to be_a(PEClient::Resource::RBACV1::Users)
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
      expect(groups).to be_a(PEClient::Resource::RBACV1::Groups)
    end

    it "memorizes the resource" do
      groups1 = resource.groups
      groups2 = resource.groups
      expect(groups1).to equal(groups2)
    end
  end

  describe "#roles" do
    it "returns a Roles resource" do
      roles = resource.roles
      expect(roles).to be_a(PEClient::Resource::RBACV1::Roles)
    end

    it "memorizes the resource" do
      roles1 = resource.roles
      roles2 = resource.roles
      expect(roles1).to equal(roles2)
    end
  end

  describe "#permissions" do
    it "returns a Permissions resource" do
      permissions = resource.permissions
      expect(permissions).to be_a(PEClient::Resource::RBACV1::Permissions)
    end

    it "memorizes the resource" do
      permissions1 = resource.permissions
      permissions2 = resource.permissions
      expect(permissions1).to equal(permissions2)
    end
  end

  describe "#tokens" do
    it "returns a Tokens resource" do
      tokens = resource.tokens
      expect(tokens).to be_a(PEClient::Resource::RBACV1::Tokens)
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
      expect(ldap).to be_a(PEClient::Resource::RBACV1::LDAP)
    end

    it "memorizes the resource" do
      ldap1 = resource.ldap
      ldap2 = resource.ldap
      expect(ldap1).to equal(ldap2)
    end
  end

  describe "#saml" do
    it "returns a SAML resource" do
      saml = resource.saml
      expect(saml).to be_a(PEClient::Resource::RBACV1::SAML)
    end

    it "memorizes the resource" do
      saml1 = resource.saml
      saml2 = resource.saml
      expect(saml1).to equal(saml2)
    end
  end

  describe "#passwords" do
    it "returns a Passwords resource" do
      passwords = resource.passwords
      expect(passwords).to be_a(PEClient::Resource::RBACV1::Passwords)
    end

    it "memorizes the resource" do
      passwords1 = resource.passwords
      passwords2 = resource.passwords
      expect(passwords1).to equal(passwords2)
    end
  end

  describe "#disclaimer" do
    it "returns a Disclaimer resource" do
      disclaimer = resource.disclaimer
      expect(disclaimer).to be_a(PEClient::Resource::RBACV1::Disclaimer)
    end

    it "memorizes the resource" do
      disclaimer1 = resource.disclaimer
      disclaimer2 = resource.disclaimer
      expect(disclaimer1).to equal(disclaimer2)
    end
  end
end
