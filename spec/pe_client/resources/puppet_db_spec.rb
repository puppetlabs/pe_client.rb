# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/puppet_db"

RSpec.describe PEClient::Resource::PuppetDB do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  subject(:resource) { described_class.new(client) }

  include_examples "a resource with port", 8080

  include_examples "a memoized resource", :query_v4, "PEClient::Resource::PuppetDB::QueryV4"
end
