# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/node_classifier.v1"

RSpec.describe PEClient::Resource::NodeClassifierV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url, ca_file: nil) }
  subject(:resource) { described_class.new(client) }

  include_examples "a memoized resource", :groups, "PEClient::Resource::NodeClassifierV1::Groups"
  include_examples "a memoized resource", :classes, "PEClient::Resource::NodeClassifierV1::Classes"
  include_examples "a memoized resource", :classification, "PEClient::Resource::NodeClassifierV1::Classification"
  include_examples "a memoized resource", :commands, "PEClient::Resource::NodeClassifierV1::Commands"
  include_examples "a memoized resource", :environments, "PEClient::Resource::NodeClassifierV1::Environments"
  include_examples "a memoized resource", :nodes, "PEClient::Resource::NodeClassifierV1::Nodes"
  include_examples "a memoized resource", :group_children, "PEClient::Resource::NodeClassifierV1::GroupChildren"
  include_examples "a memoized resource", :rules, "PEClient::Resource::NodeClassifierV1::Rules"
  include_examples "a memoized resource", :import_hierarchy, "PEClient::Resource::NodeClassifierV1::ImportHierarchy"
  include_examples "a memoized resource", :last_class_update, "PEClient::Resource::NodeClassifierV1::LastClassUpdate"
  include_examples "a memoized resource", :update_classes, "PEClient::Resource::NodeClassifierV1::UpdateClasses"
  include_examples "a memoized resource", :validation, "PEClient::Resource::NodeClassifierV1::Validation"
end
