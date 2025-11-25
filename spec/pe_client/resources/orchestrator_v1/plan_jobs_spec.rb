# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/plan_jobs"

RSpec.describe PEClient::Resource::OrchestratorV1::PlanJobs do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:job_id) { 1234 }

  describe "#get" do
    it "retrieves details about all plan jobs" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"name":1234,"plan_name":"mymodule::myplan"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"items" => [{"name" => 1234, "plan_name" => "mymodule::myplan"}]})
    end

    it "retrieves details of a specific plan job" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs/#{job_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":1234,"plan_name":"mymodule::myplan","state":"finished"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(job_id: job_id)
      expect(response).to eq({"name" => 1234, "plan_name" => "mymodule::myplan", "state" => "finished"})
    end

    it "retrieves plan jobs with query parameters" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs?limit=10&offset=0&order=asc&order_by=timestamp")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(limit: 10, offset: 0, order_by: "timestamp", order: "asc")
      expect(response).to eq({"items" => []})
    end

    it "retrieves plan jobs excluding results" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs?results=exclude")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(results: "exclude")
      expect(response).to eq({"items" => []})
    end

    it "retrieves plan jobs filtered by timestamp range" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs?min_finish_timestamp=2025-11-01T00:00:00Z&max_finish_timestamp=2025-11-25T23:59:59Z")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(
        min_finish_timestamp: "2025-11-01T00:00:00Z",
        max_finish_timestamp: "2025-11-25T23:59:59Z"
      )
      expect(response).to eq({"items" => []})
    end
  end

  describe "#events" do
    it "retrieves a list of events for a plan job" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs/#{job_id}/events")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":1,"type":"started"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(job_id: job_id)
      expect(response).to eq({"items" => [{"id" => 1, "type" => "started"}]})
    end

    it "retrieves events starting from a specific event ID" do
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs/#{job_id}/events?start=5")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":5,"type":"progress"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(job_id: job_id, start: 5)
      expect(response).to eq({"items" => [{"id" => 5, "type" => "progress"}]})
    end

    it "retrieves details of a specific event for a plan job" do
      event_id = 10
      stub_request(:get, "#{base_url}/orchestrator/v1/plan_jobs/#{job_id}/events/#{event_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id":10,"type":"completed","details":{}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(job_id: job_id, event_id: event_id)
      expect(response).to eq({"id" => 10, "type" => "completed", "details" => {}})
    end
  end
end
