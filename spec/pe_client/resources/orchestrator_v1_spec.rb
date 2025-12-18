# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/orchestrator.v1"

RSpec.describe PEClient::Resource::OrchestratorV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  subject(:resource) { described_class.new(client) }

  describe "#get" do
    it "retrieves metadata about the orchestrator API" do
      stub_request(:get, "#{base_url}/orchestrator/v1")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"version": "v1", "links": {}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"version" => "v1", "links" => {}})
    end
  end

  describe "#usage" do
    it "retrieves daily node usage with all parameters" do
      stub_request(:get, "#{base_url}/orchestrator/v1/usage?start_date=2025-11-01&end_date=2025-11-25&events=exclude")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"node_count": 100}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.usage(start_date: "2025-11-01", end_date: "2025-11-25", events: "exclude")
      expect(response).to eq({"node_count" => 100})
    end
  end

  include_examples "a memoized resource", :command, "PEClient::Resource::OrchestratorV1::Command"
  include_examples "a memoized resource", :inventory, "PEClient::Resource::OrchestratorV1::Inventory"
  include_examples "a memoized resource", :jobs, "PEClient::Resource::OrchestratorV1::Jobs"
  include_examples "a memoized resource", :scheduled_jobs, "PEClient::Resource::OrchestratorV1::ScheduledJobs"
  include_examples "a memoized resource", :plans, "PEClient::Resource::OrchestratorV1::Plans"
  include_examples "a memoized resource", :plan_jobs, "PEClient::Resource::OrchestratorV1::PlanJobs"
  include_examples "a memoized resource", :tasks, "PEClient::Resource::OrchestratorV1::Tasks"
  include_examples "a memoized resource", :scopes, "PEClient::Resource::OrchestratorV1::Scopes"
end
