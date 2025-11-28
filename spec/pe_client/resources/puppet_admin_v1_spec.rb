# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/puppet_admin.v1"

RSpec.describe PEClient::Resource::PuppetAdminV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#environment_cache" do
    context "without environment parameter" do
      it "sends a DELETE request to the correct endpoint" do
        stub_request(:delete, "#{base_url}/puppet-admin-api/v1/environment-cache")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(status: 204)

        response = resource.environment_cache
        expect(response).to eq({})
      end
    end

    context "with environment parameter" do
      it "sends a DELETE request with the environment parameter" do
        stub_request(:delete, "#{base_url}/puppet-admin-api/v1/environment-cache?environment=production")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(status: 204)

        response = resource.environment_cache(environment: "production")
        expect(response).to eq({})
      end
    end
  end

  describe "#jruby_pool" do
    it "sends a DELETE request to the correct endpoint" do
      stub_request(:delete, "#{base_url}/puppet-admin-api/v1/jruby-pool")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 204)

      response = resource.jruby_pool
      expect(response).to eq({})
    end
  end

  describe "#jruby_thread_dump" do
    it "sends a GET request to the correct endpoint" do
      stub_request(:get, "#{base_url}/puppet-admin-api/v1/jruby-pool/thread-dump")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 200, body: '{"dumps": []}', headers: {"Content-Type" => "application/json"})

      response = resource.jruby_thread_dump
      expect(response).to eq({"dumps" => []})
    end
  end
end
