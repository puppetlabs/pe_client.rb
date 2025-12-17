# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet.v3"
require_relative "../../../../lib/pe_client/resources/puppet.v3/file_metadata"

RSpec.describe PEClient::Resource::PuppetV3::FileMetadata do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8140" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppet_v3) { PEClient::Resource::PuppetV3.new(client) }
  let(:resource) { puppet_v3.file_metadata }

  describe "#find" do
    it "retrieves metadata for a single file" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/modules/apache/httpd.conf?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/httpd.conf","relative_path":"httpd.conf","links":"manage","owner":0,"group":0,"mode":420,"type":"file","destination":null,"checksum":{"type":"md5","value":"{md5}abc123def456"}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(mount: "modules/apache", file_path: "httpd.conf", environment: "production")
      expect(result).to be_a(Hash)
      expect(result["path"]).to include("httpd.conf")
      expect(result["type"]).to eq("file")
      expect(result["checksum"]).to have_key("type")
      expect(result["checksum"]["type"]).to eq("md5")
    end

    it "retrieves metadata with custom links parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/modules/apache/httpd.conf?environment=production&links=follow")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/httpd.conf","type":"file"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(
        mount: "modules/apache",
        file_path: "httpd.conf",
        environment: "production",
        links: "follow"
      )
      expect(result).to be_a(Hash)
    end

    it "retrieves metadata with custom checksum_type" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/modules/apache/httpd.conf?environment=production&checksum_type=sha256")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/httpd.conf","type":"file","checksum":{"type":"sha256","value":"{sha256}def456abc789"}}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(
        mount: "modules/apache",
        file_path: "httpd.conf",
        environment: "production",
        checksum_type: "sha256"
      )
      expect(result).to be_a(Hash)
      expect(result["checksum"]["type"]).to eq("sha256")
    end

    it "retrieves metadata with source_permissions parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/modules/apache/httpd.conf?environment=production&source_permissions=use")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/httpd.conf","type":"file","owner":0,"group":0,"mode":420}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(
        mount: "modules/apache",
        file_path: "httpd.conf",
        environment: "production",
        source_permissions: "use"
      )
      expect(result).to be_a(Hash)
    end

    it "retrieves metadata for a directory" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/modules/apache/conf.d?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/conf.d","type":"directory","mode":493}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(mount: "modules/apache", file_path: "conf.d", environment: "production")
      expect(result).to be_a(Hash)
      expect(result["type"]).to eq("directory")
    end

    it "retrieves metadata for a symbolic link" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/modules/apache/current?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/current","type":"link","destination":"/etc/apache2/sites-enabled"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(mount: "modules/apache", file_path: "current", environment: "production")
      expect(result).to be_a(Hash)
      expect(result["type"]).to eq("link")
      expect(result["destination"]).to eq("/etc/apache2/sites-enabled")
    end

    it "retrieves metadata from plugins mount point" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/plugins/mylib.rb?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/mymodule/lib/mylib.rb","type":"file"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(mount: "plugins", file_path: "mylib.rb", environment: "production")
      expect(result).to be_a(Hash)
    end

    it "retrieves metadata from tasks mount point" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadata/tasks/mymodule/install.sh?environment=production")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '{"path":"/etc/puppetlabs/code/environments/production/modules/mymodule/tasks/install.sh","type":"file"}',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.find(mount: "tasks/mymodule", file_path: "install.sh", environment: "production")
      expect(result).to be_a(Hash)
    end
  end

  describe "#search" do
    it "retrieves metadata for multiple files" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/apache?environment=production&recurse=yes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files","type":"directory"},{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/httpd.conf","type":"file"}]',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(file_path: "modules/apache", environment: "production")
      expect(result).to be_an(Array)
      expect(result.length).to eq(2)
      expect(result[0]["type"]).to eq("directory")
      expect(result[1]["type"]).to eq("file")
    end

    it "uses recurse=yes by default" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/apache?environment=production&recurse=yes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(file_path: "modules/apache", environment: "production")
      expect(result).to be_an(Array)
    end

    it "accepts custom recurse parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/apache?environment=production&recurse=no")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(file_path: "modules/apache", environment: "production", recurse: "no")
      expect(result).to be_an(Array)
    end

    it "accepts ignore parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/apache?environment=production&recurse=yes&ignore=*.swp&ignore=.git")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"path":"/etc/puppetlabs/code/environments/production/modules/apache/files/httpd.conf","type":"file"}]',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(
        file_path: "modules/apache",
        environment: "production",
        ignore: ["*.swp", ".git"]
      )
      expect(result).to be_an(Array)
    end

    it "accepts links parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/apache?environment=production&recurse=yes&links=follow")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(
        file_path: "modules/apache",
        environment: "production",
        links: "follow"
      )
      expect(result).to be_an(Array)
    end

    it "accepts checksum_type parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/apache?environment=production&recurse=yes&checksum_type=sha256")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"path":"/file","type":"file","checksum":{"type":"sha256","value":"{sha256}abc123"}}]',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(
        file_path: "modules/apache",
        environment: "production",
        checksum_type: "sha256"
      )
      expect(result).to be_an(Array)
      expect(result[0]["checksum"]["type"]).to eq("sha256")
    end

    it "accepts source_permissions parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/apache?environment=production&recurse=yes&source_permissions=use_when_creating")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(
        file_path: "modules/apache",
        environment: "production",
        source_permissions: "use_when_creating"
      )
      expect(result).to be_an(Array)
    end

    it "handles empty results" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/modules/empty?environment=production&recurse=yes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "[]",
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(file_path: "modules/empty", environment: "production")
      expect(result).to eq([])
    end

    it "retrieves metadata from plugins mount point" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/plugins?environment=production&recurse=yes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"path":"/lib/mylib.rb","type":"file"}]',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(file_path: "plugins", environment: "production")
      expect(result).to be_an(Array)
    end

    it "retrieves metadata from pluginfacts mount point" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_metadatas/pluginfacts?environment=production&recurse=yes")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: '[{"path":"/facts.d/custom.sh","type":"file"}]',
          headers: {"Content-Type" => "application/json"}
        )

      result = resource.search(file_path: "pluginfacts", environment: "production")
      expect(result).to be_an(Array)
    end
  end

  describe "BASE_PATH constant" do
    it "uses /puppet/v3/file_metadata as base path" do
      expect(described_class::BASE_PATH).to eq("/puppet/v3/file_metadata")
    end
  end

  describe "SEARCH_BASE_PATH constant" do
    it "uses /puppet/v3/file_metadatas as search base path" do
      expect(described_class::SEARCH_BASE_PATH).to eq("/puppet/v3/file_metadatas")
    end
  end
end
