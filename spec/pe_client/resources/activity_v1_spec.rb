# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/activity.v1"

RSpec.describe PEClient::Resource::ActivityV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#events" do
    context "when retrieving events with service_id only" do
      it "gets events for a specific service" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"service_id": "rbac", "subject": {"type": "user"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac")
        expect(result).to eq({"commits" => [{"service_id" => "rbac", "subject" => {"type" => "user"}}]})
      end
    end

    context "when filtering by subject_type" do
      it "includes subject_type parameter" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&subject_type=user")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", subject_type: "user")
        expect(result).to be_a(Hash)
      end

      it "includes subject_id parameter when subject_type is provided" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&subject_type=user&subject_id=user123&subject_id=user456")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"subject": {"id": "user123"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", subject_type: "user", subject_id: ["user123", "user456"])
        expect(result).to be_a(Hash)
      end
    end

    context "when filtering by object_type" do
      it "includes object_type parameter" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&object_type=role")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", object_type: "role")
        expect(result).to be_a(Hash)
      end

      it "includes object_id parameter when object_type is provided" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&object_type=role&object_id=role1&object_id=role2")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"object": {"id": "role1"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", object_type: "role", object_id: ["role1", "role2"])
        expect(result).to be_a(Hash)
      end
    end

    context "when using pagination parameters" do
      it "includes offset parameter" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&offset=10")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", offset: 10)
        expect(result).to be_a(Hash)
      end

      it "includes limit parameter" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&limit=50")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", limit: 50)
        expect(result).to be_a(Hash)
      end

      it "includes order parameter for ascending order" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&order=asc")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", order: "asc")
        expect(result).to be_a(Hash)
      end

      it "includes order parameter for descending order" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&order=desc")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", order: "desc")
        expect(result).to be_a(Hash)
      end

      it "includes all pagination parameters together" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&offset=20&order=asc&limit=100")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", offset: 20, order: "asc", limit: 100)
        expect(result).to be_a(Hash)
      end
    end

    context "when filtering by time" do
      it "includes after_service_commit_time parameter" do
        timestamp = "2025-11-27T00:00:00Z"
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&after_service_commit_time=#{timestamp}")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(service_id: "rbac", after_service_commit_time: timestamp)
        expect(result).to be_a(Hash)
      end
    end

    context "when combining multiple filters" do
      it "includes all filter parameters" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&subject_type=user&subject_id=user123&object_type=role&object_id=role1&offset=0&order=desc&limit=1000&after_service_commit_time=2025-11-01T00:00:00Z")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": [{"service_id": "rbac", "subject": {"type": "user", "id": "user123"}, "object": {"type": "role", "id": "role1"}}]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(
          service_id: "rbac",
          subject_type: "user",
          subject_id: ["user123"],
          object_type: "role",
          object_id: ["role1"],
          offset: 0,
          order: "desc",
          limit: 1000,
          after_service_commit_time: "2025-11-01T00:00:00Z"
        )
        expect(result).to be_a(Hash)
        expect(result["commits"]).to be_an(Array)
      end
    end

    context "when omitting optional parameters" do
      it "only includes service_id when other parameters are nil" do
        stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"commits": []}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.events(
          service_id: "rbac"
        )
        expect(result).to be_a(Hash)
      end
    end
  end
end
