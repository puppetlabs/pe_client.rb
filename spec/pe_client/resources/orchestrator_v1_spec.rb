# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/orchestrator.v1"

RSpec.describe PEClient::Resource::OrchestratorV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

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
    it "retrieves daily node usage without parameters" do
      stub_request(:get, "#{base_url}/orchestrator/v1/usage")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"node_count": 100}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.usage
      expect(response).to eq({"node_count" => 100})
    end

    it "retrieves daily node usage with date range" do
      stub_request(:get, "#{base_url}/orchestrator/v1/usage?start_date=2025-11-01&end_date=2025-11-25")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"node_count": 100}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.usage(start_date: "2025-11-01", end_date: "2025-11-25")
      expect(response).to eq({"node_count" => 100})
    end

    it "retrieves daily node usage excluding events" do
      stub_request(:get, "#{base_url}/orchestrator/v1/usage?events=exclude")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"node_count": 100}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.usage(events: "exclude")
      expect(response).to eq({"node_count" => 100})
    end
  end

  describe "#command" do
    it "returns a Command resource" do
      command = resource.command
      expect(command).to be_a(PEClient::Resource::OrchestratorV1::Command)
    end

    it "memorizes the resource" do
      command1 = resource.command
      command2 = resource.command
      expect(command1).to equal(command2)
    end
  end

  describe "#inventory" do
    it "returns an Inventory resource" do
      inventory = resource.inventory
      expect(inventory).to be_a(PEClient::Resource::OrchestratorV1::Inventory)
    end

    it "memorizes the resource" do
      inventory1 = resource.inventory
      inventory2 = resource.inventory
      expect(inventory1).to equal(inventory2)
    end
  end

  describe "#jobs" do
    it "returns a Jobs resource" do
      jobs = resource.jobs
      expect(jobs).to be_a(PEClient::Resource::OrchestratorV1::Jobs)
    end

    it "memorizes the resource" do
      jobs1 = resource.jobs
      jobs2 = resource.jobs
      expect(jobs1).to equal(jobs2)
    end
  end

  describe "#scheduled_jobs" do
    it "returns a ScheduledJobs resource" do
      scheduled_jobs = resource.scheduled_jobs
      expect(scheduled_jobs).to be_a(PEClient::Resource::OrchestratorV1::ScheduledJobs)
    end

    it "memorizes the resource" do
      scheduled_jobs1 = resource.scheduled_jobs
      scheduled_jobs2 = resource.scheduled_jobs
      expect(scheduled_jobs1).to equal(scheduled_jobs2)
    end
  end

  describe "#plans" do
    it "returns a Plans resource" do
      plans = resource.plans
      expect(plans).to be_a(PEClient::Resource::OrchestratorV1::Plans)
    end

    it "memorizes the resource" do
      plans1 = resource.plans
      plans2 = resource.plans
      expect(plans1).to equal(plans2)
    end
  end

  describe "#plan_jobs" do
    it "returns a PlanJobs resource" do
      plan_jobs = resource.plan_jobs
      expect(plan_jobs).to be_a(PEClient::Resource::OrchestratorV1::PlanJobs)
    end

    it "memorizes the resource" do
      plan_jobs1 = resource.plan_jobs
      plan_jobs2 = resource.plan_jobs
      expect(plan_jobs1).to equal(plan_jobs2)
    end
  end

  describe "#tasks" do
    it "returns a Tasks resource" do
      tasks = resource.tasks
      expect(tasks).to be_a(PEClient::Resource::OrchestratorV1::Tasks)
    end

    it "memorizes the resource" do
      tasks1 = resource.tasks
      tasks2 = resource.tasks
      expect(tasks1).to equal(tasks2)
    end
  end

  describe "#scopes" do
    it "returns a Scopes resource" do
      scopes = resource.scopes
      expect(scopes).to be_a(PEClient::Resource::OrchestratorV1::Scopes)
    end

    it "memorizes the resource" do
      scopes1 = resource.scopes
      scopes2 = resource.scopes
      expect(scopes1).to equal(scopes2)
    end
  end
end
