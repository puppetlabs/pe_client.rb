# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/puppet.v3"

RSpec.describe PEClient::Resource::PuppetV3 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:resource) { described_class.new(client) }

  describe "#environment_classes" do
    it "retrieves classes for the specified environment" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_classes?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"files":[{"path":"/etc/puppetlabs/code/environments/production/modules/apache/manifests/init.pp","classes":[{"name":"apache","params":[{"name":"default_vhost","type":"Boolean","default_literal":true,"default_source":"true"}]}]},{"path":"/etc/puppetlabs/code/environments/production/modules/nginx/manifests/init.pp","classes":[{"name":"nginx","params":[]}]}],"name":"production"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.environment_classes(environment: "production")
      expect(result).to be_a(Hash)
      expect(result).to have_key("files")
      expect(result).to have_key("name")
      expect(result["name"]).to eq("production")
      expect(result["files"]).to be_an(Array)
      expect(result["files"][0]).to have_key("path")
      expect(result["files"][0]).to have_key("classes")
      expect(result["files"][0]["classes"][0]["name"]).to eq("apache")
      expect(result["files"][0]["classes"][0]["params"][0]["name"]).to eq("default_vhost")
    end

    it "retrieves classes with Etag support" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_classes?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"files":[{"path":"/etc/puppetlabs/code/environments/production/manifests/site.pp","classes":[]}],"name":"production"}',
          headers: {
            "Content-Type" => "application/json",
            "Etag" => "b02ede6ecc432b134217a1cc681c406288ef9224"
          }
        )

      result = resource.environment_classes(environment: "production")
      expect(result).to be_a(Hash)
      expect(result["files"]).to be_an(Array)
      expect(result["name"]).to eq("production")
    end

    it "handles environment with manifest files but no classes" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_classes?environment=empty")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"files":[{"path":"/etc/puppetlabs/code/environments/empty/manifests/site.pp","classes":[]}],"name":"empty"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.environment_classes(environment: "empty")
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq("empty")
      expect(result["files"]).to be_an(Array)
      expect(result["files"][0]["classes"]).to eq([])
    end

    it "handles multiple class parameters with different types" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_classes?environment=dev")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"files":[{"path":"/etc/puppetlabs/code/environments/dev/modules/mymodule/manifests/init.pp","classes":[{"name":"mymodule","params":[{"name":"a_string","type":"String","default_literal":"this is a string","default_source":"\"this is a string\""},{"name":"an_integer","type":"Integer","default_literal":3,"default_source":"3"}]}]}],"name":"dev"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.environment_classes(environment: "dev")
      expect(result).to be_a(Hash)
      expect(result["files"][0]["classes"][0]["params"]).to be_an(Array)
      expect(result["files"][0]["classes"][0]["params"].length).to eq(2)
      expect(result["files"][0]["classes"][0]["params"][0]["type"]).to eq("String")
      expect(result["files"][0]["classes"][0]["params"][1]["type"]).to eq("Integer")
      expect(result["files"][0]["classes"][0]["params"][1]["default_literal"]).to eq(3)
    end

    it "includes error information for files with parse errors" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_classes?environment=broken")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"files":[{"path":"/etc/puppetlabs/code/environments/broken/modules/mymodule/manifests/good.pp","classes":[{"name":"mymodule","params":[]}]},{"path":"/etc/puppetlabs/code/environments/broken/modules/mymodule/manifests/bad.pp","error":"Syntax error at \'=>\' at /etc/puppetlabs/code/environments/broken/modules/mymodule/manifests/bad.pp:20:19"}],"name":"broken"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.environment_classes(environment: "broken")
      expect(result).to be_a(Hash)
      expect(result["files"].length).to eq(2)
      expect(result["files"][0]).to have_key("classes")
      expect(result["files"][1]).to have_key("error")
      expect(result["files"][1]["error"]).to include("Syntax error")
    end
  end

  describe "#environment_modules" do
    context "when retrieving all environments" do
      it "retrieves modules for all environments as an array" do
        stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_modules")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '[{"modules":[{"name":"puppetlabs/ntp","version":"6.0.0"},{"name":"puppetlabs/stdlib","version":"4.14.0"}],"name":"env"},{"modules":[{"name":"puppetlabs/stdlib","version":"4.14.0"},{"name":"puppetlabs/azure","version":"1.1.0"}],"name":"production"}]',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.environment_modules
        expect(result).to be_an(Array)
        expect(result.length).to eq(2)
        expect(result[0]).to have_key("name")
        expect(result[0]).to have_key("modules")
        expect(result[0]["name"]).to eq("env")
        expect(result[0]["modules"]).to be_an(Array)
        expect(result[0]["modules"][0]).to have_key("name")
        expect(result[0]["modules"][0]).to have_key("version")
        expect(result[0]["modules"][0]["name"]).to eq("puppetlabs/ntp")
      end

      it "returns empty array when no environments are available" do
        stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_modules")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: "[]",
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.environment_modules
        expect(result).to eq([])
      end
    end

    context "when retrieving modules for a specific environment" do
      it "retrieves modules for the specified environment as a hash" do
        stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_modules?environment=production")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"modules":[{"name":"puppetlabs/ntp","version":"6.0.0"},{"name":"puppetlabs/stdlib","version":"4.14.0"}],"name":"production"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.environment_modules(environment: "production")
        expect(result).to be_a(Hash)
        expect(result["name"]).to eq("production")
        expect(result["modules"]).to be_an(Array)
        expect(result["modules"][0]["name"]).to eq("puppetlabs/ntp")
        expect(result["modules"][0]["version"]).to eq("6.0.0")
      end

      it "retrieves modules for environment with empty module list" do
        stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_modules?environment=development")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"modules":[],"name":"development"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.environment_modules(environment: "development")
        expect(result).to be_a(Hash)
        expect(result["name"]).to eq("development")
        expect(result["modules"]).to eq([])
      end

      it "handles modules without version information" do
        stub_request(:get, "https://puppet.example.com:8140/puppet/v3/environment_modules?environment=test")
          .with(headers: {"X-Authentication" => api_key})
          .to_return(
            status: 200,
            body: '{"modules":[{"name":"puppetlabs/custom","version":null}],"name":"test"}',
            headers: {"Content-Type" => "application/json"}
          )

        result = resource.environment_modules(environment: "test")
        expect(result).to be_a(Hash)
        expect(result["modules"][0]["version"]).to be_nil
      end
    end
  end

  describe "#static_file_content" do
    it "retrieves static file content from module files directory" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/static_file_content/modules/apache/files/httpd.conf")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "# Apache Configuration\nServerRoot /etc/httpd\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.static_file_content(file_path: "modules/apache/files/httpd.conf")
      expect(result).to be_a(String)
      expect(result).to include("Apache Configuration")
      expect(result).to include("ServerRoot /etc/httpd")
    end

    it "retrieves static file content from module lib directory" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/static_file_content/modules/stdlib/lib/puppet/parser/functions/flatten.rb")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "# Flatten function\nmodule Puppet::Parser::Functions\n  newfunction(:flatten) do\n  end\nend\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.static_file_content(file_path: "modules/stdlib/lib/puppet/parser/functions/flatten.rb")
      expect(result).to be_a(String)
      expect(result).to include("Flatten function")
      expect(result).to include("newfunction(:flatten)")
    end

    it "retrieves static file content from module tasks directory" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/static_file_content/modules/package/tasks/install.sh")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "#!/bin/bash\napt-get install -y $PT_package\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.static_file_content(file_path: "modules/package/tasks/install.sh")
      expect(result).to be_a(String)
      expect(result).to include("#!/bin/bash")
      expect(result).to include("apt-get install")
    end

    it "retrieves static file content from module scripts directory" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/static_file_content/modules/mymodule/scripts/setup.sh")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "#!/bin/bash\necho 'Setup complete'\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.static_file_content(file_path: "modules/mymodule/scripts/setup.sh")
      expect(result).to be_a(String)
      expect(result).to include("Setup complete")
    end

    it "retrieves binary file content" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/static_file_content/modules/mymodule/files/logo.png")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR",
          headers: {"Content-Type" => "image/png"}
        )

      result = resource.static_file_content(file_path: "modules/mymodule/files/logo.png")
      expect(result).to be_a(String)
      expect(result).to start_with("\x89PNG")
    end

    it "handles nested directory paths" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/static_file_content/modules/apache/files/conf.d/ssl.conf")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "SSLEngine on\n",
          headers: {"Content-Type" => "text/plain"}
        )

      result = resource.static_file_content(file_path: "modules/apache/files/conf.d/ssl.conf")
      expect(result).to be_a(String)
      expect(result).to include("SSLEngine on")
    end
  end

  describe "#catalog" do
    it "retrieves catalog for a node" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/catalog/node1.example.com?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"node1.example.com","version":"1234567890","environment":"production","resources":[]}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.catalog(node_name: "node1.example.com", environment: "production")
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq("node1.example.com")
      expect(result["environment"]).to eq("production")
      expect(result["resources"]).to be_an(Array)
    end

    it "retrieves catalog without environment parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/catalog/node1.example.com")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"node1.example.com","version":"1234567890","resources":[]}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.catalog(node_name: "node1.example.com")
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq("node1.example.com")
    end
  end

  describe "#node" do
    it "retrieves node information" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/node/node1.example.com?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"node1.example.com","environment":"production","parameters":{"facts":{"os":"linux"}}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.node(certname: "node1.example.com", environment: "production")
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq("node1.example.com")
      expect(result["environment"]).to eq("production")
    end

    it "includes transaction_uuid and configured_environment" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/node/node1.example.com?environment=production&transaction_uuid=abc-123&configured_environment=development")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"name":"node1.example.com","environment":"production"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.node(
        certname: "node1.example.com",
        environment: "production",
        transaction_uuid: "abc-123",
        configured_environment: "development"
      )
      expect(result).to be_a(Hash)
    end
  end

  describe "#facts" do
    it "submits facts for a node" do
      facts_data = {"os" => "linux", "memory" => "16GB"}

      stub_request(:put, "https://puppet.example.com:8140/puppet/v3/facts/node1.example.com?environment=production")
        .with(
          body: facts_data.to_json,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"name":"node1.example.com"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.facts(node_name: "node1.example.com", facts: facts_data, environment: "production")
      expect(result).to be_a(Hash)
      expect(result["name"]).to eq("node1.example.com")
    end
  end

  describe "#file_content" do
    it "retrieves file content from modules mount point" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_content/modules/apache/httpd.conf?Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "ServerRoot /etc/httpd\n",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.file_content(mount_point: "modules/apache", name: "httpd.conf")
      expect(result).to be_a(String)
      expect(result).to include("ServerRoot")
    end

    it "retrieves file content from plugins mount point" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_content/plugins/mylib.rb?Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "module MyLib\nend\n",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.file_content(mount_point: "plugins", name: "mylib.rb")
      expect(result).to be_a(String)
      expect(result).to include("module MyLib")
    end
  end

  describe "#report" do
    it "submits a report for a node" do
      report_data = {
        "host" => "node1.example.com",
        "time" => "2025-12-17T10:00:00Z",
        "status" => "changed"
      }

      stub_request(:put, "https://puppet.example.com:8140/puppet/v3/report/node1.example.com?environment=production")
        .with(
          body: report_data,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: '{"status":"received"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.report(node_name: "node1.example.com", environment: "production", report: report_data)
      expect(result).to be_a(Hash)
      expect(result["status"]).to eq("received")
    end
  end

  describe "#file_bucket" do
    it "returns a FileBucket resource" do
      file_bucket = resource.file_bucket
      expect(file_bucket).to be_a(PEClient::Resource::PuppetV3::FileBucket)
    end

    it "memorizes the resource" do
      file_bucket1 = resource.file_bucket
      file_bucket2 = resource.file_bucket
      expect(file_bucket1).to equal(file_bucket2)
    end
  end

  describe "#file_metadata" do
    it "returns a FileMetadata resource" do
      file_metadata = resource.file_metadata
      expect(file_metadata).to be_a(PEClient::Resource::PuppetV3::FileMetadata)
    end

    it "memorizes the resource" do
      file_metadata1 = resource.file_metadata
      file_metadata2 = resource.file_metadata
      expect(file_metadata1).to equal(file_metadata2)
    end
  end

  describe "PORT constant" do
    it "uses port 8140 by default" do
      expect(described_class::PORT).to eq(8140)
    end

    it "initializes with port 8140" do
      resource_client = resource.instance_variable_get(:@client)
      expect(resource_client.connection.url_prefix.port).to eq(8140)
    end

    it "accepts a custom port parameter" do
      custom_resource = described_class.new(client, port: 9140)
      resource_client = custom_resource.instance_variable_get(:@client)
      expect(resource_client.connection.url_prefix.port).to eq(9140)
    end
  end

  describe "BASE_PATH constant" do
    it "uses /puppet/v3 as base path" do
      expect(described_class::BASE_PATH).to eq("/puppet/v3")
    end
  end
end
