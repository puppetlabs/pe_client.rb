# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/code_manager.v1"

RSpec.describe PEClient::Resource::CodeManagerV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8170" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#deploys" do
    context "when deploying to all environments" do
      it "posts to the deploys endpoint with deploy-all true" do
        stub_request(:post, "#{base_url}/code-manager/v1/deploys")
          .with(
            body: '{"deploy-all":true}',
            headers: {"X-Authentication" => api_key}
          )
          .to_return(
            status: 200,
            body: '[{"status":"queued"}]',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.deploys(deploy_all: true)
        expect(result).to eq([{"status" => "queued"}])
      end

      it "includes optional parameters when provided" do
        stub_request(:post, "#{base_url}/code-manager/v1/deploys")
          .with(
            body: hash_including(
              "deploy-all" => true,
              "deploy-modules" => false,
              "modules" => ["apache", "nginx"],
              "wait" => true,
              "dry-run" => false
            ),
            headers: {"X-Authentication" => api_key}
          )
          .to_return(
            status: 200,
            body: '[{"status":"complete"}]',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.deploys(
          deploy_all: true,
          deploy_modules: false,
          modules: ["apache", "nginx"],
          wait: true,
          dry_run: false
        )
        expect(result).to be_an(Array)
      end
    end

    context "when deploying to specific environments" do
      it "posts with environments array" do
        stub_request(:post, "#{base_url}/code-manager/v1/deploys")
          .with(
            body: '{"environments":["production","development"]}',
            headers: {"X-Authentication" => api_key}
          )
          .to_return(
            status: 200,
            body: '[{"status":"queued"}]',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.deploys(environments: ["production", "development"])
        expect(result).to eq([{"status" => "queued"}])
      end
    end

    context "when performing a dry run" do
      it "includes dry-run parameter" do
        stub_request(:post, "#{base_url}/code-manager/v1/deploys")
          .with(
            body: '{"deploy-all":true,"dry-run":true}',
            headers: {"X-Authentication" => api_key}
          )
          .to_return(
            status: 200,
            body: '[{"status":"dry-run"}]',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.deploys(deploy_all: true, dry_run: true)
        expect(result).to be_an(Array)
      end
    end
  end

  describe "#webhook" do
    it "posts to the webhook endpoint with required type parameter" do
      stub_request(:post, "#{base_url}/code-manager/v1/webhook?type=github")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"status":"ok"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.webhook(type: "github")
      expect(result).to eq({"status" => "ok"})
    end


    it "includes all optional parameters when provided" do
      stub_request(:post, "#{base_url}/code-manager/v1/webhook?type=bitbucket&prefix=custom&token=xyz789")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"status":"ok"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.webhook(type: "bitbucket", prefix: "custom", token: "xyz789")
      expect(result).to be_a(Hash)
    end
  end

  describe "#status" do
    context "without deployment id" do
      it "gets the status of all deployments" do
        stub_request(:get, "#{base_url}/code-manager/v1/deploys/status")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"deployments":[]}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.status
        expect(result).to eq({"deployments" => []})
      end
    end

    context "with deployment id" do
      it "gets the status of a specific deployment" do
        stub_request(:get, "#{base_url}/code-manager/v1/deploys/status?id=42")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"id":42,"status":"complete"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.status(id: 42)
        expect(result).to eq({"id" => 42, "status" => "complete"})
      end
    end
  end
end
