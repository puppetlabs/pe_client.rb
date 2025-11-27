# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/metrics.v1"

RSpec.describe PEClient::Resource::MetricsV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#mbeans" do
    it "lists available MBeans" do
      stub_request(:get, "#{base_url}/metrics/v1/mbeans")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"domains":["java.lang","java.util.logging"]}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.mbeans
      expect(result).to eq({"domains" => ["java.lang", "java.util.logging"]})
    end
  end

  describe "#get" do
    context "when requesting a single metric" do
      it "retrieves the requested MBean metric" do
        metric_name = "java.lang:type=Memory"
        stub_request(:get, "#{base_url}/metrics/v1/mbeans/#{metric_name}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"HeapMemoryUsage":{"used":1000000}}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.get(metric_name)
        expect(result).to eq({"HeapMemoryUsage" => {"used" => 1000000}})
      end

      it "returns a Hash for a single metric" do
        metric_name = "java.lang:type=Runtime"
        stub_request(:get, "#{base_url}/metrics/v1/mbeans/#{metric_name}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"Uptime":123456}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.get(metric_name)
        expect(result).to be_a(Hash)
      end
    end

    context "when requesting multiple metrics" do
      it "posts to the mbeans endpoint with an array of metrics" do
        metrics = ["java.lang:type=Memory", "java.lang:type=Runtime"]
        stub_request(:post, "#{base_url}/metrics/v1/mbeans")
          .with(
            body: '["java.lang:type=Memory","java.lang:type=Runtime"]',
            headers: {"X-Authentication" => api_key, "Content-Type" => "application/json"}
          )
          .to_return(
            status: 200,
            body: '[{"HeapMemoryUsage":{"used":1000000}},{"Uptime":123456}]',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.get(metrics)
        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
      end

      it "returns an Array for multiple metrics" do
        metrics = ["java.lang:type=Memory", "java.lang:type=Runtime"]
        stub_request(:post, "#{base_url}/metrics/v1/mbeans")
          .with(
            body: '["java.lang:type=Memory","java.lang:type=Runtime"]',
            headers: {"X-Authentication" => api_key}
          )
          .to_return(
            status: 200,
            body: '[{"metric1":"value1"},{"metric2":"value2"}]',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.get(metrics)
        expect(result).to be_an(Array)
      end
    end
  end
end
