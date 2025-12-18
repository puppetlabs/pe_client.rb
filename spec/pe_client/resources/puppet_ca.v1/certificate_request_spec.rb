# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet_ca.v1"
require_relative "../../../../lib/pe_client/resources/puppet_ca.v1/certificate_request"

RSpec.describe PEClient::Resource::PuppetCAV1::CertificateRequest do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:node_name) { "test-node.example.com" }
  let(:pem_csr) do
    <<~CSR
      -----BEGIN CERTIFICATE REQUEST-----
      MIICijCCAXICAQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUx
      -----END CERTIFICATE REQUEST-----
    CSR
  end

  describe "#get" do
    context "when retrieving an existing CSR" do
      it "gets a CSR for the specified node" do
        stub_request(:get, "#{base_url}/puppet-ca/v1/certificate_request/#{node_name}")
          .with(headers: {"Accept" => "text/plain", "Content-Type" => "text/plain"})
          .to_return(
            status: 200,
            body: pem_csr,
            headers: {"Content-Type" => "text/plain"}
          )

        result = resource.get(node_name)
        expect(result).to eq(pem_csr)
        expect(result).to include("BEGIN CERTIFICATE REQUEST")
        expect(result).to include("END CERTIFICATE REQUEST")
      end
    end
  end

  describe "#submit" do
    context "when submitting a valid CSR" do
      it "submits a CSR for the specified node" do
        stub_request(:put, "#{base_url}/puppet-ca/v1/certificate_request/#{node_name}")
          .with(
            body: pem_csr,
            headers: {"Accept" => "text/plain", "Content-Type" => "text/plain"}
          )
          .to_return(
            status: 200,
            body: pem_csr,
            headers: {"Content-Type" => "text/plain"}
          )

        result = resource.submit(node_name, pem_csr)
        expect(result).to eq(pem_csr)
        expect(result).to include("BEGIN CERTIFICATE REQUEST")
      end
    end
  end

  describe "#delete" do
    context "when deleting an existing CSR" do
      it "deletes a CSR for the specified node" do
        stub_request(:delete, "#{base_url}/puppet-ca/v1/certificate_request/#{node_name}")
          .with(headers: {"Accept" => "text/plain", "Content-Type" => "text/plain"})
          .to_return(
            status: 200,
            body: "Deleted certificate_request for #{node_name}",
            headers: {"Content-Type" => "text/plain"}
          )

        result = resource.delete(node_name)
        expect(result).to be_a(String)
        expect(result).to include("Deleted")
      end
    end
  end
end
