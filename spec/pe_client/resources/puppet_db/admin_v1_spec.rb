# frozen_string_literal: true

require_relative "../../../../lib/pe_client/resources/puppet_db"
require_relative "../../../../lib/pe_client/resources/puppet_db/admin.v1"

RSpec.describe PEClient::Resource::PuppetDB::AdminV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  let(:puppetdb) { PEClient::Resource::PuppetDB.new(client) }
  let(:resource) { described_class.new(puppetdb.instance_variable_get(:@client)) }
  subject { resource }

  describe "#cmd" do
    context "when executing 'clean' command version 1" do
      it "triggers maintenance operations with all operations requested" do
        stub_request(:post, "https://puppet.example.com:8081/pdb/admin/v1/cmd")
          .with(
            body: {
              command: "clean",
              version: 1,
              payload: ["expire_nodes", "purge_nodes", "purge_reports", "gc_packages", "other"]
            }.to_json,
            headers: {
              "X-Authentication" => api_key,
              "Content-Type" => "application/json"
            }
          )
          .to_return(
            status: 200,
            body: '{"ok": true}',
            headers: {"Content-Type" => "application/json"}
          )

        response = resource.cmd(
          command: "clean",
          version: 1,
          payload: ["expire_nodes", "purge_nodes", "purge_reports", "gc_packages", "other"]
        )

        expect(response).to eq({"ok" => true})
      end

      it "returns conflict when another maintenance operation is in progress" do
        stub_request(:post, "https://puppet.example.com:8081/pdb/admin/v1/cmd")
          .with(
            body: {
              command: "clean",
              version: 1,
              payload: ["expire_nodes"]
            }.to_json,
            headers: {
              "X-Authentication" => api_key,
              "Content-Type" => "application/json"
            }
          )
          .to_return(
            status: 409,
            body: '{"kind": "conflict", "msg": "Another cleanup is already in progress", "details": null}',
            headers: {"Content-Type" => "application/json"}
          )

        expect {
          resource.cmd(
            command: "clean",
            version: 1,
            payload: ["expire_nodes"]
          )
        }.to raise_error(PEClient::ConflictError)
      end
    end

    context "when executing 'delete' command version 1" do
      it "deletes a node by certname" do
        stub_request(:post, "https://puppet.example.com:8081/pdb/admin/v1/cmd")
          .with(
            body: {
              command: "delete",
              version: 1,
              payload: {"certname" => "node-1.example.com"}
            }.to_json,
            headers: {
              "X-Authentication" => api_key,
              "Content-Type" => "application/json"
            }
          )
          .to_return(
            status: 200,
            body: '{"deleted": "node-1.example.com"}',
            headers: {"Content-Type" => "application/json"}
          )

        response = resource.cmd(
          command: "delete",
          version: 1,
          payload: {"certname" => "node-1.example.com"}
        )

        expect(response).to eq({"deleted" => "node-1.example.com"})
      end
    end

    context "with invalid parameters" do
      it "handles errors for invalid command" do
        stub_request(:post, "https://puppet.example.com:8081/pdb/admin/v1/cmd")
          .with(
            body: {
              command: "invalid-command",
              version: 1,
              payload: {}
            }.to_json
          )
          .to_return(
            status: 400,
            body: '{"error": "Invalid command"}',
            headers: {"Content-Type" => "application/json"}
          )

        expect {
          resource.cmd(
            command: "invalid-command",
            version: 1,
            payload: {}
          )
        }.to raise_error(PEClient::BadRequestError)
      end
    end
  end

  describe "#summary_stats" do
    it "retrieves postgres usage statistics" do
      stub_request(:get, "https://puppet.example.com:8081/pdb/admin/v1/summary-stats")
        .with(headers: {"X-Authentication" => api_key})
        .to_return(
          status: 200,
          body: {}.to_json,
          headers: {"Content-Type" => "application/json"}
        )

      response = resource.summary_stats

      expect(response).to be_a(Hash)
    end
  end

  describe "#archive" do
    include_examples "a memoized resource", :archive, "PEClient::Resource::PuppetDB::AdminV1::Archive"
  end
end
