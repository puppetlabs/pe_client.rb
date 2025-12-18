# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet_ca.v1"
require_relative "../../../../lib/pe_client/resources/puppet_ca.v1/certificate_revocation_list"

RSpec.describe PEClient::Resource::PuppetCAV1::CertificateRevocationList do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:pem_crl) do
    <<~CRL
      -----BEGIN X509 CRL-----
      MIIBCjB0AgEBMA0GCSqGSIb3DQEBCwUAMBgxFjAUBgNVBAMMDVB1cHBldCBDQSAx
      -----END X509 CRL-----
    CRL
  end

  describe "#get" do
    context "when retrieving the CRL" do
      it "gets the certificate revocation list" do
        stub_request(:get, "#{base_url}/puppet-ca/v1/certificate_revocation_list/ca")
          .with(headers: {"Accept" => "text/plain", "Content-Type" => "text/plain"})
          .to_return(
            status: 200,
            body: pem_crl,
            headers: {"Content-Type" => "text/plain"}
          )

        result = resource.get
        expect(result).to eq(pem_crl)
        expect(result).to include("BEGIN X509 CRL")
        expect(result).to include("END X509 CRL")
      end
    end
  end

  describe "#update" do
    context "when updating upstream CRLs" do
      it "updates the CRL with valid PEM-encoded data" do
        stub_request(:put, "#{base_url}/puppet-ca/v1/certificate_revocation_list/ca")
          .with(
            body: pem_crl,
            headers: {"Accept" => "text/plain", "Content-Type" => "text/plain"}
          )
          .to_return(
            status: 200,
            body: pem_crl,
            headers: {"Content-Type" => "text/plain"}
          )

        result = resource.update(pem_crl)
        expect(result).to eq(pem_crl)
        expect(result).to include("BEGIN X509 CRL")
      end
    end

    context "when updating with multiple CRLs" do
      let(:multiple_crls) do
        <<~CRLS
          -----BEGIN X509 CRL-----
          MIIBCjB0AgEBMA0GCSqGSIb3DQEBCwUAMBgxFjAUBgNVBAMMDVB1cHBldCBDQSAx
          -----END X509 CRL-----
          -----BEGIN X509 CRL-----
          MIIBDjB2AgEBMA0GCSqGSIb3DQEBCwUAMBgxFjAUBgNVBAMMDVB1cHBldCBDQSAy
          -----END X509 CRL-----
        CRLS
      end

      it "updates with multiple PEM-encoded CRLs" do
        stub_request(:put, "#{base_url}/puppet-ca/v1/certificate_revocation_list/ca")
          .with(
            body: multiple_crls,
            headers: {"Accept" => "text/plain", "Content-Type" => "text/plain"}
          )
          .to_return(
            status: 200,
            body: multiple_crls,
            headers: {"Content-Type" => "text/plain"}
          )

        result = resource.update(multiple_crls)
        expect(result).to eq(multiple_crls)
      end
    end
  end
end
