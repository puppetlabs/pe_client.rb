# frozen_string_literal: true

RSpec.describe PEClient::Client do
  let(:api_key) { "test_api_key_12345" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { described_class.new(api_key: api_key, base_url: base_url, ca_file: nil) }

  describe "#initialize" do
    it "creates a client with required parameters" do
      expect(client).to be_a(PEClient::Client)
      expect(client.api_key).to eq(api_key)
      expect(client.base_url).to be_a(URI)
      expect(client.base_url.to_s).to eq(base_url)
    end

    it "accepts a URI object as base_url" do
      uri = URI.parse(base_url)
      client = described_class.new(api_key: api_key, base_url: uri, ca_file: nil)
      expect(client.base_url).to eq(uri)
    end

    it "creates a Faraday connection" do
      expect(client.connection).to be_a(Faraday::Connection)
    end

    it "sets proper headers" do
      headers = client.connection.headers
      expect(headers["X-Authentication"]).to eq(api_key)
      expect(headers["User-Agent"]).to match(/PEClient\/#{PEClient::VERSION}/o)
      expect(headers["User-Agent"]).to match(/Ruby\/#{RUBY_VERSION}/o)
    end

    it "allows customizing the Faraday connection with a block" do
      custom_client = described_class.new(api_key: api_key, base_url: base_url, ca_file: nil) do |conn|
        conn.headers["Custom-Header"] = "custom_value"
      end
      expect(custom_client.connection.headers["Custom-Header"]).to eq("custom_value")
    end

    it "allows configuring client certificate authentication" do
      custom_client = described_class.new(api_key: api_key, base_url: base_url, ca_file: nil) do |conn|
        conn.ssl[:client_cert] = "/path/to/client_cert.pem"
        conn.ssl[:client_key] = "/path/to/client_key.pem"
      end
      expect(custom_client.connection.ssl[:client_cert]).to eq("/path/to/client_cert.pem")
      expect(custom_client.connection.ssl[:client_key]).to eq("/path/to/client_key.pem")
    end
  end

  describe "#deep_dup" do
    it "creates an independent copy that preserves configuration" do
      client = described_class.new(api_key: api_key, base_url: base_url, ca_file: "/path/to/ca.pem")

      duplicate = client.deep_dup
      expect(duplicate).to be_a(PEClient::Client)
      expect(duplicate.object_id).not_to equal(client.object_id)
      expect(duplicate.api_key.object_id).not_to eq(client.api_key.object_id)
      expect(duplicate.base_url.object_id).not_to eq(client.base_url.object_id)
      expect(duplicate.connection.ssl[:ca_file].object_id).not_to eq(client.connection.ssl[:ca_file].object_id)
    end

    it "preserves the provisioning block" do
      block_called = false
      provisioning_block = proc { |conn| block_called = true }

      client = described_class.new(api_key: api_key, base_url: base_url, ca_file: nil, &provisioning_block)
      expect(block_called).to be true
      block_called = false

      client.deep_dup
      expect(block_called).to be true
    end
  end

  describe "#get" do
    it "makes a GET request" do
      stub_request(:get, "#{base_url}/test/path")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 200, body: '{"result": "success"}', headers: {"Content-Type" => "application/json"})

      response = client.get("/test/path")
      expect(response).to eq({"result" => "success"})
    end

    it "includes query parameters" do
      stub_request(:get, "#{base_url}/test/path?foo=bar&baz=qux")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 200, body: '{"result": "success"}', headers: {"Content-Type" => "application/json"})

      response = client.get("/test/path", params: {foo: "bar", baz: "qux"})
      expect(response).to eq({"result" => "success"})
    end

    it "includes custom headers" do
      stub_request(:get, "#{base_url}/test/path")
        .with(headers: {"X-Authentication" => api_key, "Custom-Header" => "value"})
        .to_return(status: 200, body: '{"result": "success"}', headers: {"Content-Type" => "application/json"})

      response = client.get("/test/path", headers: {"Custom-Header" => "value"})
      expect(response).to eq({"result" => "success"})
    end

    it "handles 303 redirects" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 303, headers: {"Location" => "https://example.com/new-location"})

      response = client.get("/test/path")
      expect(response).to eq({"location" => "https://example.com/new-location"})
    end

    it "handles 204 No Content" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 204, body: "", headers: {})

      response = client.get("/test/path")
      expect(response).to eq({})
    end

    include_examples "http error handling", :get, "/test/path"
  end

  describe "#post" do
    it "makes a POST request with body" do
      stub_request(:post, "#{base_url}/test/path")
        .with(
          body: '{"key":"value"}',
          headers: {"X-Authentication" => api_key, "Content-Type" => "application/json"}
        )
        .to_return(status: 200, body: '{"result": "created"}', headers: {"Content-Type" => "application/json"})

      response = client.post("/test/path", body: {key: "value"})
      expect(response).to eq({"result" => "created"})
    end

    it "includes query parameters in URL" do
      stub_request(:post, "#{base_url}/test/path?foo=bar")
        .with(
          body: '{"key":"value"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"result": "created"}', headers: {"Content-Type" => "application/json"})

      response = client.post("/test/path", body: {key: "value"}, params: {foo: "bar"})
      expect(response).to eq({"result" => "created"})
    end

    it "includes custom headers" do
      stub_request(:post, "#{base_url}/test/path")
        .with(
          body: '{"key":"value"}',
          headers: {"X-Authentication" => api_key, "Custom-Header" => "value"}
        )
        .to_return(status: 200, body: '{"result": "created"}', headers: {"Content-Type" => "application/json"})

      response = client.post("/test/path", body: {key: "value"}, headers: {"Custom-Header" => "value"})
      expect(response).to eq({"result" => "created"})
    end
  end

  describe "#put" do
    it "makes a PUT request with body" do
      stub_request(:put, "#{base_url}/test/path")
        .with(
          body: '{"key":"updated"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"result": "updated"}', headers: {"Content-Type" => "application/json"})

      response = client.put("/test/path", body: {key: "updated"})
      expect(response).to eq({"result" => "updated"})
    end

    it "includes query parameters in URL" do
      stub_request(:put, "#{base_url}/test/path?foo=bar")
        .with(
          body: '{"key":"updated"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"result": "updated"}', headers: {"Content-Type" => "application/json"})

      response = client.put("/test/path", body: {key: "updated"}, params: {foo: "bar"})
      expect(response).to eq({"result" => "updated"})
    end
  end

  describe "#delete" do
    it "makes a DELETE request" do
      stub_request(:delete, "#{base_url}/test/path")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 200, body: '{"result": "deleted"}', headers: {"Content-Type" => "application/json"})

      response = client.delete("/test/path")
      expect(response).to eq({"result" => "deleted"})
    end

    it "includes custom headers" do
      stub_request(:delete, "#{base_url}/test/path")
        .with(headers: {"X-Authentication" => api_key, "Custom-Header" => "value"})
        .to_return(status: 200, body: '{"result": "deleted"}', headers: {"Content-Type" => "application/json"})

      response = client.delete("/test/path", headers: {"Custom-Header" => "value"})
      expect(response).to eq({"result" => "deleted"})
    end

    it "makes a DELETE request with body" do
      stub_request(:delete, "#{base_url}/test/path")
        .with(
          body: '{"key":"value"}',
          headers: {"X-Authentication" => api_key}
        )
        .to_return(status: 200, body: '{"result": "deleted"}', headers: {"Content-Type" => "application/json"})

      response = client.delete("/test/path", body: {key: "value"})
      expect(response).to eq({"result" => "deleted"})
    end
  end

  describe "#head" do
    it "makes a HEAD request and returns headers" do
      stub_request(:head, "#{base_url}/test/path")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 200, headers: {"Content-Type" => "application/json", "X-Custom" => "header-value"})

      response = client.head("/test/path")
      expect(response).to be_a(Hash)
      expect(response["content-type"]).to eq("application/json")
      expect(response["x-custom"]).to eq("header-value")
    end

    it "includes query parameters" do
      stub_request(:head, "#{base_url}/test/path?foo=bar")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 200, headers: {"Content-Type" => "application/json"})

      response = client.head("/test/path", params: {foo: "bar"})
      expect(response).to be_a(Hash)
    end

    it "includes custom headers" do
      stub_request(:head, "#{base_url}/test/path")
        .with(headers: {"X-Authentication" => api_key, "Custom-Header" => "value"})
        .to_return(status: 200, headers: {"Content-Type" => "application/json"})

      response = client.head("/test/path", headers: {"Custom-Header" => "value"})
      expect(response).to be_a(Hash)
    end

    it "handles 204 No Content and returns headers" do
      stub_request(:head, "#{base_url}/test/path")
        .to_return(status: 204, headers: {"X-Custom" => "value"})

      response = client.head("/test/path")
      expect(response).to be_a(Hash)
      expect(response["x-custom"]).to eq("value")
    end
  end

  describe "resource methods" do
    subject { client }

    include_examples "a memoized resource", :node_inventory_v1, "PEClient::Resource::NodeInventoryV1"
    include_examples "a memoized resource", :rbac_v1, "PEClient::Resource::RBACV1"
    include_examples "a memoized resource", :rbac_v2, "PEClient::Resource::RBACV2"
    include_examples "a memoized resource", :node_classifier_v1, "PEClient::Resource::NodeClassifierV1"
    include_examples "a memoized resource", :orchestrator_v1, "PEClient::Resource::OrchestratorV1"
    include_examples "a memoized resource", :code_manager_v1, "PEClient::Resource::CodeManagerV1"
    include_examples "a memoized resource", :status_v1, "PEClient::Resource::StatusV1"
    include_examples "a memoized resource", :activity_v1, "PEClient::Resource::ActivityV1"
    include_examples "a memoized resource", :activity_v2, "PEClient::Resource::ActivityV2"
    include_examples "a memoized resource", :metrics_v1, "PEClient::Resource::MetricsV1"
    include_examples "a memoized resource", :metrics_v2, "PEClient::Resource::MetricsV2"
    include_examples "a memoized resource", :puppet_admin_v1, "PEClient::Resource::PuppetAdminV1"
    include_examples "a memoized resource", :puppet_v3, "PEClient::Resource::PuppetV3"
  end
end
