# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/plans"

RSpec.describe PEClient::Resource::OrchestratorV1::Plans do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "lists all plans in the default environment" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plans")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"name":"mymodule::plan1"},{"name":"mymodule::plan2"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"items" => [{"name" => "mymodule::plan1"}, {"name" => "mymodule::plan2"}]})
    end

    it "lists all plans in a specific environment" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plans?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"name":"mymodule::plan1"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(environment: "production")
      expect(response).to eq({"items" => [{"name" => "mymodule::plan1"}]})
    end

    it "gets information about a specific plan" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plans/mymodule/myplan")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"mymodule::myplan","metadata":{"description":"My plan"}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(module_name: "mymodule", plan_name: "myplan")
      expect(response).to eq({"name" => "mymodule::myplan", "metadata" => {"description" => "My plan"}})
    end

    it "gets information about a specific plan in a specific environment" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plans/mymodule/myplan?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"mymodule::myplan","environment":"production"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(module_name: "mymodule", plan_name: "myplan", environment: "production")
      expect(response).to eq({"name" => "mymodule::myplan", "environment" => "production"})
    end
  end
end
