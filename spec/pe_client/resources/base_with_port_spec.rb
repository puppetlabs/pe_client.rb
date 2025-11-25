# frozen_string_literal: true

require_relative "../../../lib/pe_client/resource"
require_relative "../../../lib/pe_client/resources/base_with_port"

RSpec.describe PEClient::Resource::BaseWithPort do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }

  # Create a test class that uses BaseWithPort
  before(:all) do
    # Define test class outside of let to avoid redefining constant
    unless defined?(TestResourceWithPort)
      class TestResourceWithPort < PEClient::Resource::BaseWithPort
        PORT = 4433

        attr_reader :client
      end
    end
  end

  describe "#initialize" do
    it "accepts a client and creates a copy" do
      resource = TestResourceWithPort.new(client)
      resource_client = resource.instance_variable_get(:@client)
      expect(resource_client).not_to equal(client)
      expect(resource_client.api_key).to eq(client.api_key)
    end

    it "changes the port to the resource's PORT constant" do
      resource = TestResourceWithPort.new(client)
      resource_client = resource.instance_variable_get(:@client)
      expect(resource_client.connection.url_prefix.port).to eq(4433)
    end

    it "accepts a custom port parameter" do
      resource = TestResourceWithPort.new(client, port: 9999)
      resource_client = resource.instance_variable_get(:@client)
      expect(resource_client.connection.url_prefix.port).to eq(9999)
    end

    it "modifies the client's connection" do
      test = TestResourceWithPort.new(client)
      expect(test.client.connection.url_prefix.port).to eq(4433) # modified port
      expect(client.connection.url_prefix.port).to eq(8143) # original client remains unchanged
    end
  end
end
