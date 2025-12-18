# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet_ca.v1"
require_relative "../../../../lib/pe_client/resources/puppet_ca.v1/bulk_certificate_sign"

RSpec.describe PEClient::Resource::PuppetCAV1::BulkCertificateSign do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#sign" do
    context "when signing specific certificate requests" do
      it "posts to the sign endpoint with certnames" do
        certnames = ["node1.example.com", "node2.example.com"]

        stub_request(:post, "#{base_url}/puppet-ca/v1/sign")
          .with(body: {certnames: certnames})
          .to_return(
            status: 200,
            body: '{"signed":["node1.example.com","node2.example.com"]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.sign(certnames)
        expect(result).to eq({"signed" => ["node1.example.com", "node2.example.com"]})
      end
    end

    context "when signing a single certificate request" do
      it "posts to the sign endpoint with a single certname" do
        certnames = ["node1.example.com"]

        stub_request(:post, "#{base_url}/puppet-ca/v1/sign")
          .with(body: {certnames: certnames})
          .to_return(
            status: 200,
            body: '{"signed":["node1.example.com"]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.sign(certnames)
        expect(result).to be_a(Hash)
        expect(result["signed"]).to include("node1.example.com")
      end
    end
  end

  describe "#sign_all" do
    context "when signing all outstanding certificate requests" do
      it "posts to the sign/all endpoint" do
        stub_request(:post, "#{base_url}/puppet-ca/v1/sign/all")
          .to_return(
            status: 200,
            body: '{"signed":["node1.example.com","node2.example.com","node3.example.com"]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.sign_all
        expect(result).to eq({"signed" => ["node1.example.com", "node2.example.com", "node3.example.com"]})
      end
    end

    context "when there are no outstanding certificate requests" do
      it "returns an empty signed array" do
        stub_request(:post, "#{base_url}/puppet-ca/v1/sign/all")
          .to_return(
            status: 200,
            body: '{"signed":[]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.sign_all
        expect(result).to eq({"signed" => []})
      end
    end
  end
end
