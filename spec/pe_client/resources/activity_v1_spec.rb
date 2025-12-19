# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/activity.v1"

RSpec.describe PEClient::Resource::ActivityV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#events" do
    it "gets events for a specific service with minimal parameters" do
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

    it "supports all filter and pagination parameters" do
      stub_request(:get, "https://puppet.example.com:4433/activity-api/v1/events?service_id=rbac&subject_type=user&subject_id=user123&object_type=role&object_id=role1&offset=20&order=desc&limit=100&after_service_commit_time=2025-11-01T00:00:00Z")
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
        offset: 20,
        order: "desc",
        limit: 100,
        after_service_commit_time: "2025-11-01T00:00:00Z"
      )
      expect(result).to be_a(Hash)
      expect(result["commits"]).to be_an(Array)
    end
  end
end
