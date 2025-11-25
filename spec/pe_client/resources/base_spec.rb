# frozen_string_literal: true

require_relative "../../../lib/pe_client/resource"
require_relative "../../../lib/pe_client/resources/base"

RSpec.describe PEClient::Resource::Base do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }

  describe "#initialize" do
    it "accepts a client" do
      resource = described_class.new(client)
      expect(resource.instance_variable_get(:@client)).to eq(client)
    end
  end
end
