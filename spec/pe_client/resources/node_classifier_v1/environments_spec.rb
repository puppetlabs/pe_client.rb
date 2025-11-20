# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/node_classifier.v1"
require_relative "../../../../lib/pe_client/resources/node_classifier.v1/environments"

RSpec.describe PEClient::Resource::NodeClassifierV1::Environments do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:4433" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves all environments" do
      stub_request(:get, "#{base_url}/classifier-api/v1/environments")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name": "production"}, {"name": "development"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([{"name" => "production"}, {"name" => "development"}])
    end

    it "retrieves a specific environment" do
      stub_request(:get, "#{base_url}/classifier-api/v1/environments/production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"name": "production"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get("production")
      expect(response).to eq([{ "name" => "production" }])
    end
  end

  describe "#create" do
    it "creates a new environment" do
      stub_request(:put, "#{base_url}/classifier-api/v1/environments")
        .with(
          body: '{"name":"staging"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"name": "staging"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create("staging")
      expect(response).to eq({"name" => "staging"})
    end
  end

  describe "#classes" do
    it "retrieves all classes in an environment" do
      stub_request(:get, "#{base_url}/classifier-api/v1/environments/production/classes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"classes": []}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.classes("production")
      expect(response).to eq({"classes" => []})
    end

    it "retrieves a specific class in an environment" do
      stub_request(:get, "#{base_url}/classifier-api/v1/environments/production/classes/apache")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name": "apache"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.classes("production", "apache")
      expect(response).to eq({"name" => "apache"})
    end
  end
end
