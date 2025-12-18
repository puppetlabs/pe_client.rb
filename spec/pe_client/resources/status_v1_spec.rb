# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/status.v1"

RSpec.shared_examples "a service status endpoint" do |service_type, base_path, port|
  let(:service_base_url) { "https://puppet.example.com:#{port}" }

  context "when retrieving all services" do
    it "gets all #{service_type} services with optional parameters" do
      stub_request(:get, "#{service_base_url}#{base_path}/services?level=debug&timeout=60")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"service": {"state": "running"}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.public_send("#{service_type}_services", level: "debug", timeout: 60)
      expect(result).to be_a(Hash)
    end
  end

  context "when retrieving a specific service" do
    it "gets a specific #{service_type} service" do
      stub_request(:get, "#{service_base_url}#{base_path}/services/test-service")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"state": "running"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.public_send("#{service_type}_services", service_name: "test-service")
      expect(result).to eq({"state" => "running"})
    end
  end
end

RSpec.shared_examples "a simple service status endpoint" do |service_type, base_path, port|
  let(:service_base_url) { "https://puppet.example.com:#{port}" }

  it "gets simple status for all #{service_type} services" do
    stub_request(:get, "#{service_base_url}#{base_path}/simple")
      .with(headers: {"X-Authentication" => api_key})
      .to_return(
        status: 200,
        body: '"running"',
        headers: {"Content-Type" => "application/json"}
      )

    result = resource.public_send("#{service_type}_simple")
    expect(result).to eq("running")
  end

  it "gets simple status for a specific #{service_type} service" do
    stub_request(:get, "#{service_base_url}#{base_path}/simple/test-service")
      .with(headers: {"X-Authentication" => api_key})
      .to_return(
        status: 200,
        body: '"running"',
        headers: {"Content-Type" => "application/json"}
      )

    result = resource.public_send("#{service_type}_simple", service_name: "test-service")
    expect(result).to eq("running")
  end
end


RSpec.describe PEClient::Resource::StatusV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#console_services" do
    include_examples "a service status endpoint", :console, "/status/v1", 4433
  end

  describe "#console_simple" do
    include_examples "a simple service status endpoint", :console, "/status/v1", 4433
  end

  describe "#puppet_server_services" do
    include_examples "a service status endpoint", :puppet_server, "/status/v1", 8140
  end

  describe "#puppet_server_simple" do
    include_examples "a simple service status endpoint", :puppet_server, "/status/v1", 8140
  end

  describe "#orchestrator_services" do
    include_examples "a service status endpoint", :orchestrator, "/status/v1", 8143
  end

  describe "#orchestrator_simple" do
    include_examples "a simple service status endpoint", :orchestrator, "/status/v1", 8143
  end

  describe "#puppetdb_services" do
    include_examples "a service status endpoint", :puppetdb, "/status/v1", 8081
  end

  describe "#puppetdb_simple" do
    include_examples "a simple service status endpoint", :puppetdb, "/status/v1", 8081
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
  end
end
