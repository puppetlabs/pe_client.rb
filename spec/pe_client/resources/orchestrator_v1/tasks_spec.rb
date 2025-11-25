# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/tasks"

RSpec.describe PEClient::Resource::OrchestratorV1::Tasks do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#get" do
    it "lists all tasks in the default environment" do
      stub_request(:get, "#{base_url}/orchestrator/v1/tasks")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"name":"package"},{"name":"service"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"items" => [{"name" => "package"}, {"name" => "service"}]})
    end

    it "lists all tasks in a specific environment" do
      stub_request(:get, "#{base_url}/orchestrator/v1/tasks?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"name":"package"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(environment: "production")
      expect(response).to eq({"items" => [{"name" => "package"}]})
    end

    it "gets information about a specific task" do
      stub_request(:get, "#{base_url}/orchestrator/v1/tasks/mymodule/mytask")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"mymodule::mytask","metadata":{"description":"My task"}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(module_name: "mymodule", task_name: "mytask")
      expect(response).to eq({"name" => "mymodule::mytask", "metadata" => {"description" => "My task"}})
    end

    it "gets information about a specific task in a specific environment" do
      stub_request(:get, "#{base_url}/orchestrator/v1/tasks/mymodule/mytask?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"mymodule::mytask","environment":"production"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(module_name: "mymodule", task_name: "mytask", environment: "production")
      expect(response).to eq({"name" => "mymodule::mytask", "environment" => "production"})
    end
  end
end
