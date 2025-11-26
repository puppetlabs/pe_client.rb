# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/status.v1"

RSpec.describe PEClient::Resource::StatusV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#console_services" do
    context "when retrieving all services" do
      it "gets all console services" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/services")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"activity-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_services
        expect(result).to eq({"activity-service" => {"state" => "running"}})
      end

      it "includes level parameter when provided" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/services?level=critical")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"activity-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_services(level: "critical")
        expect(result).to be_a(Hash)
      end

      it "includes timeout parameter when provided" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/services?timeout=60")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"activity-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_services(timeout: 60)
        expect(result).to be_a(Hash)
      end

      it "includes both level and timeout parameters when provided" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/services?level=debug&timeout=60")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"activity-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_services(level: "debug", timeout: 60)
        expect(result).to be_a(Hash)
      end
    end

    context "when retrieving a specific service" do
      it "gets a specific console service" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/services/activity-service")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"state": "running"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_services(service_name: "activity-service")
        expect(result).to eq({"state" => "running"})
      end

      it "includes level parameter for specific service" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/services/rbac-service?level=info")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"state": "running"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_services(service_name: "rbac-service", level: "info")
        expect(result).to be_a(Hash)
      end
    end
  end

  describe "#puppet_server_services" do
    context "when retrieving all services" do
      it "gets all puppet server services" do
        stub_request(:get, "https://puppet.example.com:8140/status/v1/services")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"server": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppet_server_services
        expect(result).to eq({"server" => {"state" => "running"}})
      end

      it "includes level parameter when provided" do
        stub_request(:get, "https://puppet.example.com:8140/status/v1/services?level=debug")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"server": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppet_server_services(level: "debug")
        expect(result).to be_a(Hash)
      end
    end

    context "when retrieving a specific service" do
      it "gets a specific puppet server service" do
        stub_request(:get, "https://puppet.example.com:8140/status/v1/services/server")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"state": "running"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppet_server_services(service_name: "server")
        expect(result).to eq({"state" => "running"})
      end
    end
  end

  describe "#orchestrator_services" do
    context "when retrieving all services" do
      it "gets all orchestrator services" do
        stub_request(:get, "https://puppet.example.com:8143/status/v1/services")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"orchestrator-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.orchestrator_services
        expect(result).to eq({"orchestrator-service" => {"state" => "running"}})
      end

      it "includes timeout parameter when provided" do
        stub_request(:get, "https://puppet.example.com:8143/status/v1/services?timeout=45")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"orchestrator-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.orchestrator_services(timeout: 45)
        expect(result).to be_a(Hash)
      end
    end

    context "when retrieving a specific service" do
      it "gets a specific orchestrator service" do
        stub_request(:get, "https://puppet.example.com:8143/status/v1/services/orchestrator-service")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"state": "running"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.orchestrator_services(service_name: "orchestrator-service")
        expect(result).to eq({"state" => "running"})
      end
    end
  end

  describe "#puppetdb_services" do
    context "when retrieving all services" do
      it "gets all puppetdb services" do
        stub_request(:get, "https://puppet.example.com:8081/status/v1/services")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"puppetdb-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppetdb_services
        expect(result).to eq({"puppetdb-service" => {"state" => "running"}})
      end

      it "includes level and timeout parameters when provided" do
        stub_request(:get, "https://puppet.example.com:8081/status/v1/services?level=info&timeout=30")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"puppetdb-service": {"state": "running"}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppetdb_services(level: "info", timeout: 30)
        expect(result).to be_a(Hash)
      end
    end

    context "when retrieving a specific service" do
      it "gets a specific puppetdb service" do
        stub_request(:get, "https://puppet.example.com:8081/status/v1/services/puppetdb-service")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"state": "running"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppetdb_services(service_name: "puppetdb-service")
        expect(result).to eq({"state" => "running"})
      end
    end
  end

  describe "#console_simple" do
    context "when retrieving all services" do
      it "gets simple status for all console services" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/simple")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_simple
        expect(result).to eq("running")
      end
    end

    context "when retrieving a specific service" do
      it "gets simple status for a specific console service" do
        stub_request(:get, "https://puppet.example.com:4433/status/v1/simple/activity-service")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.console_simple(service_name: "activity-service")
        expect(result).to eq("running")
      end
    end
  end

  describe "#puppet_server_simple" do
    context "when retrieving all services" do
      it "gets simple status for all puppet server services" do
        stub_request(:get, "https://puppet.example.com:8140/status/v1/simple")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppet_server_simple
        expect(result).to eq("running")
      end
    end

    context "when retrieving a specific service" do
      it "gets simple status for a specific puppet server service" do
        stub_request(:get, "https://puppet.example.com:8140/status/v1/simple/server")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppet_server_simple(service_name: "server")
        expect(result).to eq("running")
      end
    end
  end

  describe "#orchestrator_simple" do
    context "when retrieving all services" do
      it "gets simple status for all orchestrator services" do
        stub_request(:get, "https://puppet.example.com:8143/status/v1/simple")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.orchestrator_simple
        expect(result).to eq("running")
      end
    end

    context "when retrieving a specific service" do
      it "gets simple status for a specific orchestrator service" do
        stub_request(:get, "https://puppet.example.com:8143/status/v1/simple/orchestrator-service")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.orchestrator_simple(service_name: "orchestrator-service")
        expect(result).to eq("running")
      end
    end
  end

  describe "#puppetdb_simple" do
    context "when retrieving all services" do
      it "gets simple status for all puppetdb services" do
        stub_request(:get, "https://puppet.example.com:8081/status/v1/simple")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppetdb_simple
        expect(result).to eq("running")
      end
    end

    context "when retrieving a specific service" do
      it "gets simple status for a specific puppetdb service" do
        stub_request(:get, "https://puppet.example.com:8081/status/v1/simple/puppetdb-service")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '"running"',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.puppetdb_simple(service_name: "puppetdb-service")
        expect(result).to eq("running")
      end
    end
  end

  describe "#pe_jruby_metrics" do
    it "gets pe-jruby-metrics with default debug level" do
      stub_request(:get, "https://puppet.example.com:8140/status/v1/services/pe-jruby-metrics?level=debug")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state": "running", "status": {"experimental": {"jruby-pools": {}}}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.pe_jruby_metrics
      expect(result).to be_a(Hash)
      expect(result).to have_key("state")
    end

    it "accepts custom level parameter" do
      stub_request(:get, "https://puppet.example.com:8140/status/v1/services/pe-jruby-metrics?level=info")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state": "running"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.pe_jruby_metrics(level: "info")
      expect(result).to be_a(Hash)
    end
  end

  describe "#pe_master" do
    it "gets pe-master information with default debug level" do
      stub_request(:get, "https://puppet.example.com:8140/status/v1/services/pe-master?level=debug")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state": "running", "status": {"experimental": {"http-metrics": {}}}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.pe_master
      expect(result).to be_a(Hash)
      expect(result).to have_key("state")
    end

    it "accepts custom level parameter" do
      stub_request(:get, "https://puppet.example.com:8140/status/v1/services/pe-master?level=critical")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state": "running"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.pe_master(level: "critical")
      expect(result).to be_a(Hash)
    end
  end

  describe "#pe_puppet_profiler" do
    it "gets pe-puppet-profiler statistics with default debug level" do
      stub_request(:get, "https://puppet.example.com:8140/status/v1/services/pe-puppet-profiler?level=debug")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state": "running", "status": {"experimental": {"function-metrics": {}}}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.pe_puppet_profiler
      expect(result).to be_a(Hash)
      expect(result).to have_key("state")
    end

    it "accepts custom level parameter" do
      stub_request(:get, "https://puppet.example.com:8140/status/v1/services/pe-puppet-profiler?level=info")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state": "running"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.pe_puppet_profiler(level: "info")
      expect(result).to be_a(Hash)
    end
  end
end
