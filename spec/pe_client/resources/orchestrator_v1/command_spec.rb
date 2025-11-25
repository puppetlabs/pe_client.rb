# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/orchestrator.v1"
require_relative "../../../../lib/pe_client/resources/orchestrator.v1/command"

RSpec.describe PEClient::Resource::OrchestratorV1::Command do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#deploy" do
    it "runs Puppet on demand across all nodes in an environment" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/deploy")
        .with(
          body: '{"environment":"production","scope":{"nodes":["node1.example.com","node2.example.com"]}}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"job":{"id":"1234","name":"deploy"}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.deploy(
        environment: "production",
        scope: {nodes: ["node1.example.com", "node2.example.com"]}
      )
      expect(response).to eq({"job" => {"id" => "1234", "name" => "deploy"}})
    end

    it "runs Puppet on demand with additional options" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/deploy")
        .with(
          body: hash_including(
            "environment" => "production",
            "noop" => true,
            "description" => "Test deployment"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"job":{"id":"1234"}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.deploy(
        environment: "production",
        scope: {nodes: ["node1.example.com"]},
        noop: true,
        description: "Test deployment"
      )
      expect(response).to eq({"job" => {"id" => "1234"}})
    end
  end

  describe "#stop" do
    it "stops an orchestrator job that is currently in progress" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/stop")
        .with(
          body: '{"job":"1234"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"stopped":true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.stop(job: "1234")
      expect(response).to eq({"stopped" => true})
    end

    it "forcibly stops an orchestrator job" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/stop")
        .with(
          body: '{"job":"1234","force":true}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"stopped":true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.stop(job: "1234", force: true)
      expect(response).to eq({"stopped" => true})
    end
  end

  describe "#stop_plan" do
    it "stops an orchestrator plan job that is currently in progress" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/stop_plan")
        .with(
          body: '{"plan_job":"5678"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"stopped":true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.stop_plan(plan_job: "5678")
      expect(response).to eq({"stopped" => true})
    end
  end

  describe "#task" do
    it "runs a task on a set of nodes" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/task")
        .with(
          body: '{"environment":"production","scope":{"nodes":["node1.example.com"]},"params":{},"targets":[],"task":"package"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"job":{"id":"1234","name":"task"}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.task(
        environment: "production",
        scope: {nodes: ["node1.example.com"]},
        params: {},
        targets: [],
        task: "package"
      )
      expect(response).to eq({"job" => {"id" => "1234", "name" => "task"}})
    end

    it "runs a task with parameters and options" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/task")
        .with(
          body: hash_including(
            "task" => "package",
            "params" => {"action" => "install", "name" => "httpd"},
            "noop" => true,
            "description" => "Install httpd package"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"job":{"id":"1234"}}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.task(
        environment: "production",
        scope: {nodes: ["node1.example.com"]},
        params: {action: "install", name: "httpd"},
        targets: [],
        task: "package",
        noop: true,
        description: "Install httpd package"
      )
      expect(response).to eq({"job" => {"id" => "1234"}})
    end
  end

  describe "#task_target" do
    it "creates a task-target with specific tasks" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/task_target")
        .with(
          body: '{"display_name":"Test Target","tasks":["package","service"],"nodes":[],"node_groups":[]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id":"target-123"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.task_target(
        display_name: "Test Target",
        tasks: ["package", "service"]
      )
      expect(response).to eq({"id" => "target-123"})
    end

    it "creates a task-target with all_tasks enabled" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/task_target")
        .with(
          body: '{"display_name":"All Tasks Target","all_tasks":true,"nodes":[],"node_groups":[]}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id":"target-456"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.task_target(
        display_name: "All Tasks Target",
        all_tasks: true
      )
      expect(response).to eq({"id" => "target-456"})
    end

    it "raises an error when neither tasks nor all_tasks is provided" do
      expect {
        resource.task_target(display_name: "Invalid Target")
      }.to raise_error(ArgumentError, "Either `tasks` or `all_tasks` must be provided")
    end

    it "creates a task-target with nodes, node_groups, and pql_query" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/task_target")
        .with(
          body: hash_including(
            "display_name" => "Complex Target",
            "tasks" => ["package"],
            "nodes" => ["node1.example.com"],
            "node_groups" => ["group-123"],
            "pql_query" => "nodes[certname] { environment = 'production' }"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"id":"target-789"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.task_target(
        display_name: "Complex Target",
        tasks: ["package"],
        nodes: ["node1.example.com"],
        node_groups: ["group-123"],
        pql_query: "nodes[certname] { environment = 'production' }"
      )
      expect(response).to eq({"id" => "target-789"})
    end
  end

  describe "#plan_run" do
    it "runs a plan using the plan executor" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/plan_run")
        .with(
          body: '{"plan_name":"mymodule::myplan"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"name":"1234"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.plan_run(plan_name: "mymodule::myplan")
      expect(response).to eq({"name" => "1234"})
    end

    it "runs a plan with parameters and options" do
      stub_request(:post, "#{base_url}/orchestrator/v1/command/plan_run")
        .with(
          body: hash_including(
            "plan_name" => "mymodule::myplan",
            "params" => {"nodes" => ["node1.example.com"]},
            "environment" => "production",
            "description" => "Test plan run"
          ),
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"name":"1234"}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.plan_run(
        plan_name: "mymodule::myplan",
        params: {nodes: ["node1.example.com"]},
        environment: "production",
        description: "Test plan run"
      )
      expect(response).to eq({"name" => "1234"})
    end
  end
end
