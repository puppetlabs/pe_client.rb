# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../lib/pe_client/resources/puppet_db/metadata.v1"

RSpec.describe PEClient::Resource::PuppetDB::MetadataV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:resource) { described_class.new(puppetdb.instance_variable_get(:@client)) }
  subject { resource }

  describe "#version" do
    context "when retrieving current version" do
      it "returns the current PuppetDB version" do
        stub_request(:get, "https://puppet.example.com:8081/pdb/meta/v1/version")
          .with(
            headers: {
              "X-Authentication" => api_key
            }
          )
          .to_return(
            status: 200,
            body: '{"version": "7.12.1"}',
            headers: {"Content-Type" => "application/json"}
          )

        response = resource.version

        expect(response).to eq({"version" => "7.12.1"})
      end

      it "returns the latest PuppetDB version" do
        stub_request(:get, "https://puppet.example.com:8081/pdb/meta/v1/version/latest")
          .with(
            headers: {
              "X-Authentication" => api_key
            }
          )
          .to_return(
            status: 200,
            body: '{"newer": false, "product": "puppetdb", "link": "https://docs.puppetlabs.com/puppetdb/2.3/release_notes.markdown", "message": "Version 2.3.4 is now available!", "version": "2.3.4"}',
            headers: {"Content-Type" => "application/json"}
          )

        response = resource.version(latest: true)

        expect(response).to eq({"newer" => false, "product" => "puppetdb", "link" => "https://docs.puppetlabs.com/puppetdb/2.3/release_notes.markdown", "message" => "Version 2.3.4 is now available!", "version" => "2.3.4"})
      end
    end
  end

  describe "#server_time" do
    context "when retrieving server time" do
      it "returns the current server time in ISO 8601 format" do
        stub_request(:get, "https://puppet.example.com:8081/pdb/meta/v1/server-time")
          .with(
            headers: {
              "X-Authentication" => api_key
            }
          )
          .to_return(
            status: 200,
            body: '{"server-time": "2026-02-20T15:30:45.123Z"}',
            headers: {"Content-Type" => "application/json"}
          )

        response = resource.server_time

        expect(response).to eq({"server-time" => "2026-02-20T15:30:45.123Z"})
      end
    end
  end
end
