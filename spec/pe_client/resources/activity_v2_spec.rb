# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/activity.v2"

RSpec.describe PEClient::Resource::ActivityV2 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#events" do
    context "when retrieving all events" do
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
    end

    context "when filtering by service_id" do
      it "includes service_id parameter" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?service_id=rbac")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"service_id": "rbac"}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac")
        expect(result).to be_a(Hash)
      end
    end

    context "when using pagination parameters" do
      it "includes offset parameter" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?offset=10")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(offset: 10)
        expect(result).to be_a(Hash)
      end

      it "includes order parameter for ascending order" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?order=asc")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(order: "asc")
        expect(result).to be_a(Hash)
      end

      it "includes order parameter for descending order" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?order=desc")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(order: "desc")
        expect(result).to be_a(Hash)
      end

      it "includes limit parameter" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?limit=50")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(limit: 50)
        expect(result).to be_a(Hash)
      end

      it "includes all pagination parameters together" do
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
    end

    context "when filtering with query parameter" do
      it "includes query with subject_id" do
        query_param = [{subject_id: "user123"}]
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?query=#{CGI.escape(query_param.to_json)}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"subject": {"id": "user123"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(query: query_param)
        expect(result).to be_a(Hash)
      end

      it "includes query with subject_type and subject_id" do
        query_param = [{subject_type: "user", subject_id: "user123"}]
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?query=#{CGI.escape(query_param.to_json)}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"subject": {"type": "user", "id": "user123"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(query: query_param)
        expect(result).to be_a(Hash)
      end

      it "includes query with object_type and object_id" do
        query_param = [{object_type: "role", object_id: "role1"}]
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?query=#{CGI.escape(query_param.to_json)}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"object": {"type": "role", "id": "role1"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(query: query_param)
        expect(result).to be_a(Hash)
      end

      it "includes query with ip_address" do
        query_param = [{ip_address: "192.168.1.100"}]
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?query=#{CGI.escape(query_param.to_json)}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"ip": "192.168.1.100"}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(query: query_param)
        expect(result).to be_a(Hash)
      end

      it "includes query with time range using start and end" do
        query_param = [{start: "2025-11-01T00:00:00Z", end: "2025-11-27T23:59:59Z"}]
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

      it "includes query with multiple filters" do
        query_param = [
          {subject_type: "user", subject_id: "user123"},
          {object_type: "role", object_id: "role1"}
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

      it "includes query with symbol keys" do
        query_param = [{subject_id: "user123", object_type: "role"}]
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

      it "includes query with string keys" do
        query_param = [{"subject_id" => "user123", "object_type" => "role"}]
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
    end

    context "when combining service_id with query filters" do
      it "includes both service_id and query parameters" do
        query_param = [{subject_id: "user123"}]
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events?service_id=rbac&query=#{CGI.escape(query_param.to_json)}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"service_id": "rbac", "subject": {"id": "user123"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", query: query_param)
        expect(result).to be_a(Hash)
      end
    end

    context "when combining all parameters" do
      it "includes service_id, pagination, and query parameters" do
        query_param = [
          {subject_type: "user", subject_id: "user123"},
          {start: "2025-11-01T00:00:00Z", end: "2025-11-27T23:59:59Z"}
        ]
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

    context "when omitting optional parameters" do
      it "only includes non-nil parameters" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v2/events")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events
        expect(result).to be_a(Hash)
      end
    end
  end
end
