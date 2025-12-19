# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/metrics.v2"

RSpec.describe PEClient::Resource::MetricsV2 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8081" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#list" do
    it "retrieves a list of all valid MBeans" do
      stub_request(:get, "#{base_url}/metrics/v2/list")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"value":{"java.lang":{"type=Memory":{}}}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.list
      expect(result).to eq({"value" => {"java.lang" => {"type=Memory" => {}}}})
    end
  end

  describe "#read" do
    it "retrieves orchestrator service metrics data" do
      stub_request(:get, "#{base_url}/metrics/v2/read/java.util.logging:type=Logging/LoggerNames")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"value":["logger1","logger2"]}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.read(mbean_names: "java.util.logging:type=Logging", attributes: "LoggerNames")
      expect(result).to eq({"value" => ["logger1", "logger2"]})
    end

    it "supports comma-separated MBean names" do
      stub_request(:get, "#{base_url}/metrics/v2/read/java.lang:name=*,type=GarbageCollector/CollectionCount")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"value":{"java.lang:name=PS Scavenge,type=GarbageCollector":{"CollectionCount":10}}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.read(
        mbean_names: "java.lang:name=*,type=GarbageCollector",
        attributes: "CollectionCount"
      )
      expect(result).to be_a(Hash)
    end

    it "includes inner path filter when provided" do
      stub_request(:get, "#{base_url}/metrics/v2/read/java.lang:type=Memory/HeapMemoryUsage/used")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"value":1000000}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.read(
        mbean_names: "java.lang:type=Memory",
        attributes: "HeapMemoryUsage",
        inner_path_filter: "used"
      )
      expect(result).to eq({"value" => 1000000})
    end
  end

  describe "#complex_read" do
    it "posts a complex query to retrieve metrics data" do
      request_body = {
        type: "read",
        mbean: "java.lang:type=Memory",
        attribute: "HeapMemoryUsage",
        path: "used"
      }

      stub_request(:post, "#{base_url}/metrics/v2/read")
        .with(
          body: request_body.to_json,
          headers: {"X-Authentication" => api_key, "Content-Type" => "application/json"}
        )
        .to_return(
          status: 200,
          body: '{"value":1000000,"status":200}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.complex_read(request_body)
      expect(result).to eq({"value" => 1000000, "status" => 200})
    end

    it "posts multiple complex queries" do
      request_body = [
        {type: "read", mbean: "java.lang:type=Memory", attribute: "HeapMemoryUsage"},
        {type: "read", mbean: "java.lang:type=Runtime", attribute: "Uptime"}
      ]

      stub_request(:post, "#{base_url}/metrics/v2/read")
        .with(
          body: request_body.to_json,
          headers: {"X-Authentication" => api_key, "Content-Type" => "application/json"}
        )
        .to_return(
          status: 200,
          body: '{"results":[{"value":{"used":1000000},"status":200},{"value":123456,"status":200}]}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.complex_read(request_body)
      expect(result).to be_a(Hash)
      expect(result["results"]).to be_an(Array)
    end

    it "supports Jolokia protocol requests" do
      jolokia_request = {
        type: "read",
        mbean: "java.lang:type=Memory",
        attribute: ["HeapMemoryUsage", "NonHeapMemoryUsage"],
        config: {ignoreErrors: true}
      }

      stub_request(:post, "#{base_url}/metrics/v2/read")
        .with(
          body: jolokia_request.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"value":{"HeapMemoryUsage":{},"NonHeapMemoryUsage":{}},"status":200}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.complex_read(jolokia_request)
      expect(result).to be_a(Hash)
    end
  end
end
