# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/activity.v2"

RSpec.describe PEClient::Resource::ActivityV2 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#events" do
    it "gets events without any filters" do
      stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"commits": [{"service_id": "rbac"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.events
      expect(result).to eq({"commits" => [{"service_id" => "rbac"}]})
    end

    it "supports pagination parameters" do
      stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?offset=20&order=asc&limit=100")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"commits": []}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.events(offset: 20, order: "asc", limit: 100)
      expect(result).to be_a(Hash)
    end

    it "supports complex query filters" do
      query_param = [
        {subject_type: "user", subject_id: "user123"},
        {object_type: "role", object_id: "role1"},
        {ip_address: "192.168.1.100"},
        {start: "2025-11-01T00:00:00Z", end: "2025-11-27T23:59:59Z"}
      ]
      stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?query=#{CGI.escape(query_param.to_json)}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"commits": []}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.events(query: query_param)
      expect(result).to be_a(Hash)
    end

    it "combines service_id, pagination, and query parameters" do
      query_param = [{subject_type: "user", subject_id: "user123"}]
      stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?service_id=rbac&offset=10&order=desc&limit=100&query=#{CGI.escape(query_param.to_json)}")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"commits": [{"service_id": "rbac"}]}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.events(
        service_id: "rbac",
        offset: 10,
        order: "desc",
        limit: 100,
        query: query_param
      )
      expect(result).to be_a(Hash)
    end
  end
end
