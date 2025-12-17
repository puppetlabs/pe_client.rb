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
  end

  describe "#deep_dup" do
    it "creates a deep duplicate of the client" do
      client = described_class.new(api_key: api_key, base_url: base_url, ca_file: "/path/to/ca.pem")

      duplicate = client.deep_dup
      expect(duplicate).to be_a(PEClient::Client)
      expect(duplicate.object_id).not_to equal(client.object_id)
      expect(duplicate.api_key.object_id).not_to eq(client.api_key.object_id)
      expect(duplicate.base_url.object_id).not_to eq(client.base_url.object_id)
      expect(duplicate.connection.ssl[:ca_file].object_id).not_to eq(client.connection.ssl[:ca_file].object_id)
    end

    # Some API endpoints don't require an api_key
    it "handles nil api_key in deep_dup" do
      client_with_nil_api_key = described_class.new(api_key: nil, base_url: base_url, ca_file: nil)
      duplicate = client_with_nil_api_key.deep_dup
      expect(duplicate.api_key).to eq(nil)
    end

    # While ca_file = nil is not recommended in production, we test it here to ensure
    # that the deep_dup method handles nil values without raising errors.
    it "handles nil ca_file in deep_dup" do
      duplicate = client.deep_dup
      expect(duplicate.connection.ssl[:ca_file]).to eq(nil)
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

    it "raises BadRequestError on 400" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 400, body: '{"error": "bad request"}', headers: {"Content-Type" => "application/json"})

      expect { client.get("/test/path") }.to raise_error(PEClient::BadRequestError)
    end

    it "raises UnauthorizedError on 401" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 401, body: '{"error": "unauthorized"}', headers: {"Content-Type" => "application/json"})

      expect { client.get("/test/path") }.to raise_error(PEClient::UnauthorizedError)
    end

    it "raises ForbiddenError on 403" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 403, body: '{"error": "forbidden"}', headers: {"Content-Type" => "application/json"})

      expect { client.get("/test/path") }.to raise_error(PEClient::ForbiddenError)
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 404, body: '{"error": "not found"}', headers: {"Content-Type" => "application/json"})

      expect { client.get("/test/path") }.to raise_error(PEClient::NotFoundError)
    end

    it "raises ConflictError on 409" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 409, body: '{"error": "conflict"}', headers: {"Content-Type" => "application/json"})

      expect { client.get("/test/path") }.to raise_error(PEClient::ConflictError)
    end

    it "raises ServerError on 500" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 500, body: '{"error": "server error"}', headers: {"Content-Type" => "application/json"})

      expect { client.get("/test/path") }.to raise_error(PEClient::ServerError)
    end

    it "raises HTTPError on other status codes" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 418, body: "I'm a teapot")

      expect { client.get("/test/path") }.to raise_error(PEClient::HTTPError)
    end

    it "handles 204 No Content" do
      stub_request(:get, "#{base_url}/test/path")
        .to_return(status: 204, body: "", headers: {})

      response = client.get("/test/path")
      expect(response).to eq({})
    end
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

  describe "resource methods" do
    describe "#node_inventory_v1" do
      it "returns a NodeInventoryV1 resource" do
        resource = client.node_inventory_v1
        expect(resource).to be_a(PEClient::Resource::NodeInventoryV1)
      end

      it "memorizes the resource" do
        resource1 = client.node_inventory_v1
        resource2 = client.node_inventory_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#rbac_v1" do
      it "returns an RBACV1 resource" do
        resource = client.rbac_v1
        expect(resource).to be_a(PEClient::Resource::RBACV1)
      end

      it "memorizes the resource" do
        resource1 = client.rbac_v1
        resource2 = client.rbac_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#rbac_v2" do
      it "returns an RBACV2 resource" do
        resource = client.rbac_v2
        expect(resource).to be_a(PEClient::Resource::RBACV2)
      end

      it "memorizes the resource" do
        resource1 = client.rbac_v2
        resource2 = client.rbac_v2
        expect(resource1).to equal(resource2)
      end
    end

    describe "#node_classifier_v1" do
      it "returns a NodeClassifierV1 resource" do
        resource = client.node_classifier_v1
        expect(resource).to be_a(PEClient::Resource::NodeClassifierV1)
      end

      it "memorizes the resource" do
        resource1 = client.node_classifier_v1
        resource2 = client.node_classifier_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#orchestrator_v1" do
      it "returns an OrchestratorV1 resource" do
        resource = client.orchestrator_v1
        expect(resource).to be_a(PEClient::Resource::OrchestratorV1)
      end

      it "memorizes the resource" do
        resource1 = client.orchestrator_v1
        resource2 = client.orchestrator_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#code_manager_v1" do
      it "returns a CodeManagerV1 resource" do
        resource = client.code_manager_v1
        expect(resource).to be_a(PEClient::Resource::CodeManagerV1)
      end

      it "memorizes the resource" do
        resource1 = client.code_manager_v1
        resource2 = client.code_manager_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#status_v1" do
      it "returns a StatusV1 resource" do
        resource = client.status_v1
        expect(resource).to be_a(PEClient::Resource::StatusV1)
      end

      it "memorizes the resource" do
        resource1 = client.status_v1
        resource2 = client.status_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#activity_v1" do
      it "returns an ActivityV1 resource" do
        resource = client.activity_v1
        expect(resource).to be_a(PEClient::Resource::ActivityV1)
      end

      it "memorizes the resource" do
        resource1 = client.activity_v1
        resource2 = client.activity_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#activity_v2" do
      it "returns an ActivityV2 resource" do
        resource = client.activity_v2
        expect(resource).to be_a(PEClient::Resource::ActivityV2)
      end

      it "memorizes the resource" do
        resource1 = client.activity_v2
        resource2 = client.activity_v2
        expect(resource1).to equal(resource2)
      end
    end

    describe "#metrics_v1" do
      it "returns a MetricsV1 resource" do
        resource = client.metrics_v1
        expect(resource).to be_a(PEClient::Resource::MetricsV1)
      end

      it "memorizes the resource" do
        resource1 = client.metrics_v1
        resource2 = client.metrics_v1
        expect(resource1).to equal(resource2)
      end
    end

    describe "#metrics_v2" do
      it "returns a MetricsV2 resource" do
        resource = client.metrics_v2
        expect(resource).to be_a(PEClient::Resource::MetricsV2)
      end

      it "memorizes the resource" do
        resource1 = client.metrics_v2
        resource2 = client.metrics_v2
        expect(resource1).to equal(resource2)
      end
    end

    describe "#puppet_server_v3" do
      it "returns a PuppetServerV3 resource" do
        resource = client.puppet_server_v3
        expect(resource).to be_a(PEClient::Resource::PuppetServerV3)
      end

      it "memorizes the resource" do
        resource1 = client.puppet_server_v3
        resource2 = client.puppet_server_v3
        expect(resource1).to equal(resource2)
      end
    end

    describe "#puppet_server_v3" do
      it "returns a PuppetServerV3 resource" do
        resource = client.puppet_server_v3
        expect(resource).to be_a(PEClient::Resource::PuppetServerV3)
      end

      it "memorizes the resource" do
        resource1 = client.puppet_server_v3
        resource2 = client.puppet_server_v3
        expect(resource1).to equal(resource2)
      end
    end
  end
end
