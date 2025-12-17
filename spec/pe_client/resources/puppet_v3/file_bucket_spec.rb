# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet.v3"
require_relative "../../../../lib/pe_client/resources/puppet.v3/file_bucket"

RSpec.describe PEClient::Resource::PuppetV3::FileBucket do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppet_v3) { PEClient::Resource::PuppetV3.new(client) }
  let(:resource) { puppet_v3.file_bucket }

  describe "#get" do
    it "retrieves a file from the file bucket by md5" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/abc123def456?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "file content here\n",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.get(md5: "abc123def456", environment: "production")
      expect(result).to be_a(String)
      expect(result).to eq("file content here\n")
    end

    it "retrieves a file with filename parameter" do
      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/abc123def456//etc/puppet/test.conf?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: "file content here\n",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.get(md5: "abc123def456", environment: "production", filename: "/etc/puppet/test.conf")
      expect(result).to be_a(String)
      expect(result).to eq("file content here\n")
    end

    it "retrieves binary file content" do
      binary_content = "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR"

      stub_request(:get, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/def789abc123?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: binary_content,
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.get(md5: "def789abc123", environment: "production")
      expect(result).to eq(binary_content)
    end
  end

  describe "#head" do
    it "checks if a file exists in the file bucket" do
      stub_request(:head, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/abc123def456?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          headers: {"Content-Type" => "application/octet-stream", "Content-Length" => "1024"}
        )

      result = resource.head(md5: "abc123def456", environment: "production")
      expect(result).to be_a(Hash)
      expect(result["content-type"]).to eq("application/octet-stream")
      expect(result["content-length"]).to eq("1024")
    end

    it "checks if a file exists with filename parameter" do
      stub_request(:head, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/abc123def456//etc/puppet/test.conf?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.head(md5: "abc123def456", environment: "production", filename: "/etc/puppet/test.conf")
      expect(result).to be_a(Hash)
    end

    it "handles 404 for missing file" do
      stub_request(:head, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/missing123?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(status: 404)

      expect { resource.head(md5: "missing123", environment: "production") }
        .to raise_error(PEClient::NotFoundError)
    end
  end

  describe "#save" do
    it "saves a file to the file bucket" do
      file_content = "This is the file content\n"

      stub_request(:put, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/abc123def456?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(
          body: file_content,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "abc123def456",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.save(md5: "abc123def456", file: file_content, environment: "production")
      expect(result).to eq("abc123def456")
    end

    it "saves a file with filename parameter" do
      file_content = "This is the file content\n"

      stub_request(:put, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/abc123def456//etc/puppet/test.conf?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(
          body: file_content,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "abc123def456",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.save(
        md5: "abc123def456",
        file: file_content,
        environment: "production",
        filename: "/etc/puppet/test.conf"
      )
      expect(result).to eq("abc123def456")
    end

    it "saves binary file content" do
      binary_content = "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR"

      stub_request(:put, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/def789abc123?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(
          body: binary_content,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "def789abc123",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.save(md5: "def789abc123", file: binary_content, environment: "production")
      expect(result).to eq("def789abc123")
    end

    it "returns corrected md5 if provided md5 is incorrect" do
      file_content = "This is the file content\n"

      stub_request(:put, "https://puppet.example.com:8140/puppet/v3/file_bucket_file/wrongmd5?environment=production&Content-Type=application%2Foctet-stream&Accept=application%2Foctet-stream")
        .with(
          body: file_content,
          headers: {"X-Authentication" => api_key}
        )
        .to_return(
          status: 200,
          body: "correctmd5hash",
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.save(md5: "wrongmd5", file: file_content, environment: "production")
      expect(result).to eq("correctmd5hash")
    end
  end

  describe "BASE_PATH constant" do
    it "uses /puppet/v3/file_bucket_file as base path" do
      expect(described_class::BASE_PATH).to eq("/puppet/v3/file_bucket_file")
    end
  end

  describe "HEADERS constant" do
    it "includes Content-Type and Accept headers for octet-stream" do
      expect(described_class::HEADERS).to eq({
        "Content-Type": "application/octet-stream",
        Accept: "application/octet-stream"
      })
    end
  end
end
