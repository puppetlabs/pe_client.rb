# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/puppet_db"

RSpec.describe PEClient::Resource::PuppetDB do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8081" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  subject(:resource) { described_class.new(client) }

  describe "#state_overview" do
    it "gets the node state overview for the provided threshold" do
      stub_request(:get, "#{base_url}/pdb/ext/v1/state-overview?unresponsive_threshold=3600")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"unreported":1,"noop":2,"unchanged":3,"changed":4,"failed":5}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.state_overview(unresponsive_threshold: 3600)

      expect(result).to eq(
        {
          "unreported" => 1,
          "noop" => 2,
          "unchanged" => 3,
          "changed" => 4,
          "failed" => 5
        }
      )
    end
  end

  describe "#status" do
    it "gets the PuppetDB service status" do
      stub_request(:get, "#{base_url}/status/v1/services/puppetdb-status")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state":"running","status":{"service_version":"8.8.1"}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.status

      expect(result).to eq(
        {
          "state" => "running",
          "status" => {"service_version" => "8.8.1"}
        }
      )
    end
  end

  include_examples "a resource with port", 8081

  include_examples "a memoized resource", :query_v4, "PEClient::Resource::PuppetDB::QueryV4"
  include_examples "a memoized resource", :admin_v1, "PEClient::Resource::PuppetDB::AdminV1"
  include_examples "a memoized resource", :metadata_v1, "PEClient::Resource::PuppetDB::MetadataV1"
end
