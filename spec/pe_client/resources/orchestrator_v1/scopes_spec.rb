# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/scopes"

RSpec.describe PEClient::Resource::OrchestratorV1::Scopes do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:task_target_id) { "target-123" }

  describe "#get" do
    it "retrieves information about all orchestrator task-targets" do
      stub_request(:get, "#{base_url}/orchestrator/v1/scopes/task_targets")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":"target-123","display_name":"Test Target"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"items" => [{"id" => "target-123", "display_name" => "Test Target"}]})
    end

    it "gets information about a specific task-target" do
      stub_request(:get, "#{base_url}/orchestrator/v1/scopes/task_targets/#{task_target_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id":"target-123","display_name":"Test Target","tasks":["package","service"]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(task_target_id: task_target_id)
      expect(response).to eq({
        "id" => "target-123",
        "display_name" => "Test Target",
        "tasks" => ["package", "service"]
      })
    end
  end
end
