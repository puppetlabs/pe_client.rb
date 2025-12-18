# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet_ca.v1"
require_relative "../../../../lib/pe_client/resources/puppet_ca.v1/certificate_status"

RSpec.describe PEClient::Resource::PuppetCAV1::CertificateStatus do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:certname) { "test-node.example.com" }

  describe "#get" do
    it "gets the certificate status for a signed certificate" do
      response_body = {
        "name" => certname,
        "state" => "signed",
        "fingerprint" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16",
        "fingerprints" => {
          "SHA1" => "E5:B0:F5:0B:7D:E4:70:78:AC:64:D1:72:C3:26:EB:06:2C:4A:45:F0",
          "SHA256" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16",
          "SHA512" => "69:AD:BB:92:5C:A0:E1:3A:93:EF:08:93:4D:7F:6E:F7:E8:4B:4F:77:62:46:D7:63:A3:04:F7:29:5E:AA:96:74:BE:EF:09:12:2A:CA:97:29:1E:98:BE:58:07:D8:D2:9A:29:65:0E:9D:E3:ED:F9:E5:53:81:E2:BA:90:6F:12:86"
        },
        "dns_alt_names" => [
          "DNS:puppet",
          "DNS:test-node.example.com"
        ]
      }

      stub_request(:get, "#{base_url}/puppet-ca/v1/certificate_status/#{certname}")
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.get(certname)
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq(certname)
      expect(result["state"]).to eq("signed")
      expect(result["fingerprint"]).to be_a(String)
      expect(result["fingerprints"]).to be_a(Hash)
      expect(result["dns_alt_names"]).to be_an(Array)
    end
  end

  describe "#list" do
    it "gets information about all known certificates without filter" do
      response_body = [
        {
          "name" => "node1.example.com",
          "state" => "signed",
          "fingerprint" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16",
          "fingerprints" => {
            "SHA256" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16"
          },
          "dns_alt_names" => ["DNS:node1.example.com"]
        },
        {
          "name" => "node2.example.com",
          "state" => "requested",
          "fingerprint" => "A1:B2:C3:D4:E5:F6:A7:B8:C9:D0:E1:F2:A3:B4:C5:D6:E7:F8:A9:B0:C1:D2:E3:F4:A5:B6:C7:D8:E9:F0:A1:B2",
          "fingerprints" => {
            "SHA256" => "A1:B2:C3:D4:E5:F6:A7:B8:C9:D0:E1:F2:A3:B4:C5:D6:E7:F8:A9:B0:C1:D2:E3:F4:A5:B6:C7:D8:E9:F0:A1:B2"
          },
          "dns_alt_names" => ["DNS:node2.example.com"]
        },
        {
          "name" => "node3.example.com",
          "state" => "revoked",
          "fingerprint" => "B1:C2:D3:E4:F5:A6:B7:C8:D9:E0:F1:A2:B3:C4:D5:E6:F7:A8:B9:C0:D1:E2:F3:A4:B5:C6:D7:E8:F9:A0:B1:C2",
          "fingerprints" => {
            "SHA256" => "B1:C2:D3:E4:F5:A6:B7:C8:D9:E0:F1:A2:B3:C4:D5:E6:F7:A8:B9:C0:D1:E2:F3:A4:B5:C6:D7:E8:F9:A0:B1:C2"
          },
          "dns_alt_names" => ["DNS:node3.example.com"]
        }
      ]

      stub_request(:get, "#{base_url}/puppet-ca/v1/certificate_statuses/any_key")
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.list
      expect(result).to be_an(Array)
      expect(result.length).to eq(3)
      expect(result[0]["name"]).to eq("node1.example.com")
      expect(result[0]["state"]).to eq("signed")
      expect(result[1]["state"]).to eq("requested")
      expect(result[2]["state"]).to eq("revoked")
    end

    it "filters certificates by state parameter" do
      response_body = [
        {
          "name" => "node2.example.com",
          "state" => "requested",
          "fingerprint" => "A1:B2:C3:D4:E5:F6:A7:B8:C9:D0:E1:F2:A3:B4:C5:D6:E7:F8:A9:B0:C1:D2:E3:F4:A5:B6:C7:D8:E9:F0:A1:B2",
          "fingerprints" => {
            "SHA256" => "A1:B2:C3:D4:E5:F6:A7:B8:C9:D0:E1:F2:A3:B4:C5:D6:E7:F8:A9:B0:C1:D2:E3:F4:A5:B6:C7:D8:E9:F0:A1:B2"
          },
          "dns_alt_names" => ["DNS:node2.example.com"]
        },
        {
          "name" => "node4.example.com",
          "state" => "requested",
          "fingerprint" => "D1:E2:F3:A4:B5:C6:D7:E8:F9:A0:B1:C2:D3:E4:F5:A6:B7:C8:D9:E0:F1:A2:B3:C4:D5:E6:F7:A8:B9:C0:D1:E2",
          "fingerprints" => {
            "SHA256" => "D1:E2:F3:A4:B5:C6:D7:E8:F9:A0:B1:C2:D3:E4:F5:A6:B7:C8:D9:E0:F1:A2:B3:C4:D5:E6:F7:A8:B9:C0:D1:E2"
          },
          "dns_alt_names" => ["DNS:node4.example.com"]
        }
      ]

      stub_request(:get, "#{base_url}/puppet-ca/v1/certificate_statuses/any_key?state=requested")
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.list(state: "requested")
      expect(result).to be_an(Array)
      expect(result.length).to eq(2)
      expect(result.all? { |cert| cert["state"] == "requested" }).to be true
    end
  end

  describe "#update" do
    it "updates the certificate status to signed with custom TTL" do
      response_body = {
        "name" => certname,
        "state" => "signed",
        "fingerprint" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16",
        "fingerprints" => {
          "SHA256" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16"
        },
        "dns_alt_names" => ["DNS:test-node.example.com"]
      }

      stub_request(:put, "#{base_url}/puppet-ca/v1/certificate_status/#{certname}")
        .with(body: {desired_state: "signed", cert_ttl: "2y"})
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.update(certname, "signed", cert_ttl: "2y")
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq(certname)
      expect(result["state"]).to eq("signed")
    end

    it "updates the certificate status to revoked" do
      response_body = {
        "name" => certname,
        "state" => "revoked",
        "fingerprint" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16",
        "fingerprints" => {
          "SHA256" => "C2:FD:F0:1A:9F:A7:BD:F2:87:D6:0D:F8:D0:43:B1:E0:63:E2:5F:33:92:A2:B9:93:8A:56:20:38:E6:70:A4:16"
        },
        "dns_alt_names" => ["DNS:test-node.example.com"]
      }

      stub_request(:put, "#{base_url}/puppet-ca/v1/certificate_status/#{certname}")
        .with(body: {desired_state: "revoked"})
        .to_return(
          status: 200,
          body: response_body.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.update(certname, "revoked")
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq(certname)
      expect(result["state"]).to eq("revoked")
    end
  end

  describe "#delete" do
    it "deletes all SSL information for the specified hostname" do
      hostname = "test-node.example.com"
      response_body = "Deleted for #{hostname}: Puppet::SSL::Certificate, Puppet::SSL::Key"

      stub_request(:delete, "#{base_url}/puppet-ca/v1/certificate_status/#{hostname}")
        .to_return(
          status: 200,
          body: response_body,
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.delete(hostname)
      expect(result).to be_a(String)
      expect(result).to include("Deleted for #{hostname}")
      expect(result).to include("Puppet::SSL::Certificate")
    end
  end
end
