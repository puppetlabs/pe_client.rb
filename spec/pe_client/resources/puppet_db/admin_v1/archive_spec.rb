# frozen_string_literal: true

require_relative "../../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../../lib/pe_client/resources/puppet_db/admin.v1"
require_relative "../../../../../lib/pe_client/resources/puppet_db/admin.v1/archive"
require "tempfile"

RSpec.describe PEClient::Resource::PuppetDB::AdminV1::Archive do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:puppetdb_client) { puppetdb.instance_variable_get(:@client) }
  let(:resource) { described_class.new(puppetdb_client) }
  subject { resource }

  describe "#import" do
    let(:archive_file) { Tempfile.new(["test-archive", ".tgz"]) }

    before do
      archive_file.write("test archive content")
      archive_file.rewind
    end

    after do
      archive_file.close
      archive_file.unlink
    end

    it "imports a PuppetDB archive successfully" do
      stub_request(:post, "https://puppet.example.com:8081/pdb/admin/v1/archive")
        .with(
          headers: {
            "X-Authentication" => api_key
          }
        )
        .to_return(
          status: 200,
          body: '{"ok": true}',
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.import(archive: archive_file.path)

      expect(response).to eq({"ok" => true})
    end
  end

  describe "#export" do
    let(:export_path) { File.join(Dir.tmpdir, "test-export-#{Time.now.to_i}.tgz") }

    after do
      File.delete(export_path) if File.exist?(export_path)
    end

    it "exports a PuppetDB archive successfully" do
      archive_content = "mock archive data"

      stub_request(:get, "https://puppet.example.com:8081/pdb/admin/v1/archive")
        .with(
          headers: {
            "X-Authentication" => api_key,
            "Accepts" => "application/octet-stream"
          }
        )
        .to_return(
          status: 200,
          body: archive_content,
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.export(path: export_path)

      expect(result).to eq(export_path)
      expect(File.exist?(export_path)).to be true
      expect(File.read(export_path)).to eq(archive_content)
    end

    it "exports a PuppetDB archive with anonymization profile" do
      archive_content = "mock anonymized archive data"

      stub_request(:get, "https://puppet.example.com:8081/pdb/admin/v1/archive")
        .with(
          query: {"anonymization_profile" => "moderate"},
          headers: {
            "X-Authentication" => api_key,
            "Accepts" => "application/octet-stream"
          }
        )
        .to_return(
          status: 200,
          body: archive_content,
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.export(path: export_path, anonymization_profile: "moderate")

      expect(result).to eq(export_path)
      expect(File.exist?(export_path)).to be true
      expect(File.read(export_path)).to eq(archive_content)
    end

    it "handles streaming large archives" do
      # Simulate a large archive with chunked response
      large_content = "x" * 10000

      stub_request(:get, "https://puppet.example.com:8081/pdb/admin/v1/archive")
        .with(
          headers: {
            "X-Authentication" => api_key,
            "Accepts" => "application/octet-stream"
          }
        )
        .to_return(
          status: 200,
          body: large_content,
          headers: {"Content-Type" => "application/octet-stream"}
        )

      result = resource.export(path: export_path)

      expect(result).to eq(export_path)
      expect(File.exist?(export_path)).to be true
      expect(File.size(export_path)).to eq(large_content.bytesize)
    end
  end
end
