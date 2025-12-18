# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/jobs"

RSpec.describe PEClient::Resource::OrchestratorV1::Jobs do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }
  let(:job_id) { "1234" }

  describe "#get" do
    it "retrieves details about all jobs" do
      stub_request(:get, "#{base_url}/orchestrator/v1/jobs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":"1234","name":"deploy"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq({"items" => [{"id" => "1234", "name" => "deploy"}]})
    end

    it "retrieves details of a specific job" do
      stub_request(:get, "#{base_url}/orchestrator/v1/jobs/#{job_id}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"id":"1234","name":"deploy","state":"finished"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(job_id: job_id)
      expect(response).to eq({"id" => "1234", "name" => "deploy", "state" => "finished"})
    end

    it "retrieves jobs with all query parameters" do
      stub_request(:get, "#{base_url}/orchestrator/v1/jobs?limit=10&max_finish_timestamp=2025-11-25T23:59:59Z&min_finish_timestamp=2025-11-01T00:00:00Z&offset=0&order=asc&order_by=timestamp&type=task")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":"1234","type":"task"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(
        limit: 10,
        offset: 0,
        order_by: "timestamp",
        order: "asc",
        type: "task",
        min_finish_timestamp: "2025-11-01T00:00:00Z",
        max_finish_timestamp: "2025-11-25T23:59:59Z"
      )
      expect(response).to eq({"items" => [{"id" => "1234", "type" => "task"}]})
    end
  end

  describe "#nodes" do
    it "retrieves nodes with all query parameters" do
      stub_request(:get, "#{base_url}/orchestrator/v1/jobs/#{job_id}/nodes?limit=10&offset=0&order=asc&order_by=name&state=finished")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"name":"node1.example.com","state":"finished"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.nodes(
        job_id,
        limit: 10,
        offset: 0,
        order_by: "name",
        order: "asc",
        state: "finished"
      )
      expect(response).to eq({"items" => [{"name" => "node1.example.com", "state" => "finished"}]})
    end
  end

  describe "#report" do
    it "returns a report that summarizes a specific job" do
      stub_request(:get, "#{base_url}/orchestrator/v1/jobs/#{job_id}/report")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"job_id":"1234","summary":"Job completed successfully"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.report(job_id)
      expect(response).to eq({"job_id" => "1234", "summary" => "Job completed successfully"})
    end
  end

  describe "#events" do
    it "retrieves events with optional start parameter" do
      stub_request(:get, "#{base_url}/orchestrator/v1/jobs/#{job_id}/events?start=5")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"items":[{"id":5,"type":"progress"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(job_id, start: 5)
      expect(response).to eq({"items" => [{"id" => 5, "type" => "progress"}]})
    end
  end
end
