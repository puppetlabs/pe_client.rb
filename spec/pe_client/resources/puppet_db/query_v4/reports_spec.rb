# frozen_string_literal: true

require "uri"
require_relative "../../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4"
require_relative "../../../../../lib/pe_client/resources/puppet_db/query.v4/reports"

RSpec.describe PEClient::Resource::PuppetDB::QueryV4::Reports do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:resource) { described_class.new(puppetdb.instance_variable_get(:@client)) }
  let(:report_hash) { "abc123def456" }

  describe "#get" do
    it "retrieves all reports" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","hash":"abc123","start_time":"2025-01-01T00:00:00Z","end_time":"2025-01-01T00:30:00Z"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get
      expect(response).to eq([{
        "certname" => "node1.example.com",
        "hash" => "abc123",
        "start_time" => "2025-01-01T00:00:00Z",
        "end_time" => "2025-01-01T00:30:00Z"
      }])
    end

    it "supports query parameter" do
      query_param = URI.encode_www_form({"query" => ["=", "certname", "node1.example.com"].to_json})
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","hash":"abc123"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(query: ["=", "certname", "node1.example.com"])
      expect(response).to eq([{"certname" => "node1.example.com", "hash" => "abc123"}])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "10", "offset" => "5"})
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(limit: 10, offset: 5)
      expect(response).to eq([])
    end

    it "filters reports by status" do
      query_param = URI.encode_www_form({"query" => ["=", "status", "success"].to_json})
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","status":"success"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.get(query: ["=", "status", "success"])
      expect(response).to eq([{"certname" => "node1.example.com", "status" => "success"}])
    end
  end

  describe "#events" do
    it "retrieves events for a specific report" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/events")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"certname":"node1.example.com","status":"success","timestamp":"2025-01-01T00:15:00Z","resource_type":"File","resource_title":"/etc/hosts"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(hash: report_hash)
      expect(response).to eq([{
        "certname" => "node1.example.com",
        "status" => "success",
        "timestamp" => "2025-01-01T00:15:00Z",
        "resource_type" => "File",
        "resource_title" => "/etc/hosts"
      }])
    end

    it "supports query parameter" do
      query_param = URI.encode_www_form({"query" => ["=", "status", "success"].to_json})
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/events?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(hash: report_hash, query: ["=", "status", "success"])
      expect(response).to eq([])
    end

    it "supports paging parameters" do
      query_param = URI.encode_www_form({"limit" => "50"})
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/events?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(hash: report_hash, limit: 50)
      expect(response).to eq([])
    end

    it "filters events by resource type" do
      query_param = URI.encode_www_form({"query" => ["=", "resource_type", "File"].to_json})
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/events?#{query_param}")
        .with(
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '[{"resource_type":"File","status":"success"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.events(hash: report_hash, query: ["=", "resource_type", "File"])
      expect(response).to eq([{"resource_type" => "File", "status" => "success"}])
    end
  end

  describe "#metrics" do
    it "retrieves metrics for a specific report" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/metrics")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"category":"resources","name":"total","value":150},{"category":"time","name":"config_retrieval","value":5.5}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.metrics(hash: report_hash)
      expect(response).to eq([
        {"category" => "resources", "name" => "total", "value" => 150},
        {"category" => "time", "name" => "config_retrieval", "value" => 5.5}
      ])
    end

    it "returns empty array when no metrics are available" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/metrics")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.metrics(hash: report_hash)
      expect(response).to eq([])
    end

    it "returns metrics with various categories" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/metrics")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"category":"resources","name":"changed","value":5},{"category":"resources","name":"failed","value":0},{"category":"events","name":"success","value":5}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.metrics(hash: report_hash)
      expect(response).to eq([
        {"category" => "resources", "name" => "changed", "value" => 5},
        {"category" => "resources", "name" => "failed", "value" => 0},
        {"category" => "events", "name" => "success", "value" => 5}
      ])
    end
  end

  describe "#logs" do
    it "retrieves logs for a specific report" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/logs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"level":"info","message":"Applied catalog in 30.5 seconds","source":"Puppet","time":"2025-01-01T00:30:00Z"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.logs(hash: report_hash)
      expect(response).to eq([{
        "level" => "info",
        "message" => "Applied catalog in 30.5 seconds",
        "source" => "Puppet",
        "time" => "2025-01-01T00:30:00Z"
      }])
    end

    it "returns empty array when no logs are available" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/logs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.logs(hash: report_hash)
      expect(response).to eq([])
    end

    it "returns logs with various levels" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/query/v4/reports/#{report_hash}/logs")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"level":"notice","message":"Notice message"},{"level":"warning","message":"Warning message"},{"level":"err","message":"Error message"}]',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.logs(hash: report_hash)
      expect(response).to eq([
        {"level" => "notice", "message" => "Notice message"},
        {"level" => "warning", "message" => "Warning message"},
        {"level" => "err", "message" => "Error message"}
      ])
    end
  end
end
