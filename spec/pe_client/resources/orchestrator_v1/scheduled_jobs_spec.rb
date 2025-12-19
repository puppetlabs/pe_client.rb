# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/scheduled_jobs"

RSpec.describe PEClient::Resource::OrchestratorV1::ScheduledJobs do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:job_id) { "sched-job-123" }

  describe "#get" do
    it "retrieves information about all scheduled environment jobs" do
      stub_request(:get, "#{base_url}/orchestrator/v1/scheduled_jobs/environment_jobs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":"sched-job-123","type":"deploy"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"items" => [{"id" => "sched-job-123", "type" => "deploy"}]})
    end

    it "retrieves information about a specific scheduled environment job" do
      stub_request(:get, "#{base_url}/orchestrator/v1/scheduled_jobs/environment_jobs/#{job_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id":"sched-job-123","type":"deploy","environment":"production"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(job_id: job_id)
      expect(response).to eq({"id" => "sched-job-123", "type" => "deploy", "environment" => "production"})
    end

    it "retrieves scheduled jobs with all query parameters" do
      stub_request(:get, "#{base_url}/orchestrator/v1/scheduled_jobs/environment_jobs?limit=10&offset=0&order=asc&order_by=next_run_time&type=task")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":"sched-job-456","type":"task"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(limit: 10, offset: 0, order_by: "next_run_time", order: "asc", type: "task")
      expect(response).to eq({"items" => [{"id" => "sched-job-456", "type" => "task"}]})
    end
  end

  describe "#create" do
    it "creates a one-time scheduled deploy job" do
      stub_request(:post, "#{base_url}/orchestrator/v1/scheduled_jobs/environment_jobs")
        .with(
          body: hash_including(
            "type" => "deploy",
            "environment" => "production",
            "schedule" => {"start_time" => "2025-12-01T10:00:00Z", "interval" => nil}
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id":"new-sched-job-123"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(
        type: "deploy",
        input: {scope: {nodes: ["node1.example.com"]}},
        environment: "production",
        schedule: {start_time: "2025-12-01T10:00:00Z", interval: nil},
        description: "One-time deploy"
      )
      expect(response).to eq({"id" => "new-sched-job-123"})
    end

    it "creates a recurring scheduled task job" do
      stub_request(:post, "#{base_url}/orchestrator/v1/scheduled_jobs/environment_jobs")
        .with(
          body: hash_including(
            "type" => "task",
            "environment" => "production",
            "schedule" => {"start_time" => "2025-12-01T10:00:00Z", "interval" => {"units" => "seconds", "value" => 3600}}
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id":"new-sched-job-456"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(
        type: "task",
        input: {task: "package", params: {action: "status"}, scope: {nodes: ["node1.example.com"]}},
        environment: "production",
        schedule: {
          start_time: "2025-12-01T10:00:00Z",
          interval: {units: "seconds", value: 3600}
        },
        description: "Hourly package check"
      )
      expect(response).to eq({"id" => "new-sched-job-456"})
    end

    it "creates a scheduled plan job with userdata" do
      stub_request(:post, "#{base_url}/orchestrator/v1/scheduled_jobs/environment_jobs")
        .with(
          body: hash_including(
            "type" => "plan",
            "userdata" => {"ticket" => "TICKET-123"}
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id":"new-sched-job-789"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.create(
        type: "plan",
        input: {plan_name: "mymodule::myplan", params: {}},
        environment: "production",
        schedule: {start_time: "2025-12-01T10:00:00Z", interval: nil},
        description: "Scheduled plan execution",
        userdata: {ticket: "TICKET-123"}
      )
      expect(response).to eq({"id" => "new-sched-job-789"})
    end
  end
end
