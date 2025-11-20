# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/rbac.v1"
require_relative "../../../../lib/pe_client/resources/rbac.v1/disclaimer"

RSpec.describe PEClient::Resource::RBACV1::Disclaimer do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves the current disclaimer text" do
      stub_request(:get, "#{base_url}/rbac-api/v1/config/disclaimer")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"disclaimer": "This is a disclaimer"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"disclaimer" => "This is a disclaimer"})
    end
  end

  describe "#set" do
    it "sets the disclaimer text" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/config/set-disclaimer")
        .with(
          body: '{"disclaimer":"New disclaimer text"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 204)

      response = resource.set("New disclaimer text")
      expect(response).to eq({})
    end
  end

  describe "#remove" do
    it "removes the disclaimer text" do
      stub_request(:post, "#{base_url}/rbac-api/v1/command/config/remove-disclaimer")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.remove
      expect(response).to eq({})
    end
  end
end
