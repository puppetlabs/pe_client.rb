# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/puppet_ca.v1"

RSpec.describe PEClient::Resource::PuppetCAV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#certificate" do
    it "retrieves a certificate for the specified node name" do
      node_name = "agent.example.com"
      stub_request(:get, "#{base_url}/puppet-ca/v1/certificate/#{node_name}")
        .with(headers: {"X-Authentication" => api_key, "Accept" => "text/plain"})
        .to_return(
          status: 200,
          body: "-----BEGIN CERTIFICATE-----\nMIIDExample\n-----END CERTIFICATE-----\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.certificate(node_name)
      expect(result).to be_a(String)
      expect(result).to include("BEGIN CERTIFICATE")
      expect(result).to include("END CERTIFICATE")
    end

    it "retrieves the CA certificate" do
      stub_request(:get, "#{base_url}/puppet-ca/v1/certificate/ca")
        .with(headers: {"X-Authentication" => api_key, "Accept" => "text/plain"})
        .to_return(
          status: 200,
          body: "-----BEGIN CERTIFICATE-----\nMIIDCACertificate\n-----END CERTIFICATE-----\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.certificate("ca")
      expect(result).to be_a(String)
      expect(result).to include("BEGIN CERTIFICATE")
    end
  end

  describe "#expirations" do
    it "retrieves expiration dates for all certificates and CRLs" do
      stub_request(:get, "#{base_url}/puppet-ca/v1/expirations")
        .with(headers: {"X-Authentication" => api_key, "Accept" => "text/plain"})
        .to_return(
          status: 200,
          body: "Certificate: ca\nExpiration: 2030-01-01T00:00:00Z\nCRL: ca\nNext Update: 2025-12-31T00:00:00Z\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.expirations
      expect(result).to be_a(String)
      expect(result).to include("Certificate:")
      expect(result).to include("Expiration:")
    end
  end

  describe "#clean" do
    it "revokes and deletes a list of certificates" do
      certnames = ["agent1.example.com", "agent2.example.com"]
      stub_request(:put, "#{base_url}/puppet-ca/v1/clean")
        .with(
          headers: {"X-Authentication" => api_key, "Accept" => "text/plain"},
          body: {certnames: certnames}
        )
        .to_return(
          status: 200,
          body: "Cleaned certificates: agent1.example.com, agent2.example.com",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.clean(certnames)
      expect(result).to be_a(String)
      expect(result).to include("Cleaned certificates")
    end

    it "handles a single certificate" do
      certnames = ["agent.example.com"]
      stub_request(:put, "#{base_url}/puppet-ca/v1/clean")
        .with(
          headers: {"X-Authentication" => api_key, "Accept" => "text/plain"},
          body: {certnames: certnames}
        )
        .to_return(
          status: 200,
          body: "Cleaned certificate: agent.example.com",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.clean(certnames)
      expect(result).to be_a(String)
    end
  end

  describe "#certificate_request" do
    it "returns a CertificateRequest resource" do
      result = resource.certificate_request
      expect(result).to be_a(PEClient::Resource::PuppetCAV1::CertificateRequest)
    end

    it "caches the CertificateRequest instance" do
      result1 = resource.certificate_request
      result2 = resource.certificate_request
      expect(result1).to equal(result2)
    end
  end

  describe "#certificate_status" do
    it "returns a CertificateStatus resource" do
      result = resource.certificate_status
      expect(result).to be_a(PEClient::Resource::PuppetCAV1::CertificateStatus)
    end

    it "caches the CertificateStatus instance" do
      result1 = resource.certificate_status
      result2 = resource.certificate_status
      expect(result1).to equal(result2)
    end
  end

  describe "#certificate_revocation_list" do
    it "returns a CertificateRevocationList resource" do
      result = resource.certificate_revocation_list
      expect(result).to be_a(PEClient::Resource::PuppetCAV1::CertificateRevocationList)
    end

    it "caches the CertificateRevocationList instance" do
      result1 = resource.certificate_revocation_list
      result2 = resource.certificate_revocation_list
      expect(result1).to equal(result2)
    end
  end

  describe "#bulk_certificate_sign" do
    it "returns a BulkCertificateSign resource" do
      result = resource.bulk_certificate_sign
      expect(result).to be_a(PEClient::Resource::PuppetCAV1::BulkCertificateSign)
    end

    it "caches the BulkCertificateSign instance" do
      result1 = resource.bulk_certificate_sign
      result2 = resource.bulk_certificate_sign
      expect(result1).to equal(result2)
    end
  end
end
