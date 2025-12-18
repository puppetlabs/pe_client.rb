# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/node_classifier.v1"

RSpec.describe PEClient::Resource::NodeClassifierV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  subject(:resource) { described_class.new(client) }

  it_behaves_like "a memoized resource", :groups, "PEClient::Resource::NodeClassifierV1::Groups"
  it_behaves_like "a memoized resource", :classes, "PEClient::Resource::NodeClassifierV1::Classes"
  it_behaves_like "a memoized resource", :classification, "PEClient::Resource::NodeClassifierV1::Classification"
  it_behaves_like "a memoized resource", :commands, "PEClient::Resource::NodeClassifierV1::Commands"
  it_behaves_like "a memoized resource", :environments, "PEClient::Resource::NodeClassifierV1::Environments"
  it_behaves_like "a memoized resource", :nodes, "PEClient::Resource::NodeClassifierV1::Nodes"
  it_behaves_like "a memoized resource", :group_children, "PEClient::Resource::NodeClassifierV1::GroupChildren"
  it_behaves_like "a memoized resource", :rules, "PEClient::Resource::NodeClassifierV1::Rules"
  it_behaves_like "a memoized resource", :import_hierarchy, "PEClient::Resource::NodeClassifierV1::ImportHierarchy"
  it_behaves_like "a memoized resource", :last_class_update, "PEClient::Resource::NodeClassifierV1::LastClassUpdate"
  it_behaves_like "a memoized resource", :update_classes, "PEClient::Resource::NodeClassifierV1::UpdateClasses"
  it_behaves_like "a memoized resource", :validation, "PEClient::Resource::NodeClassifierV1::Validation"
end
