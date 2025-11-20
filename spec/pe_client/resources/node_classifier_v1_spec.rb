# frozen_string_literal: true

require_relative "../../../lib/pe_client/resources/node_classifier.v1"

RSpec.describe PEClient::Resource::NodeClassifierV1 do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://puppet.example.com:8143" }
  let(:client) { PEClient::Client.new(api_key: api_key, base_url: base_url) }
  let(:resource) { described_class.new(client) }

  describe "#groups" do
    it "returns a Groups resource" do
      groups = resource.groups
      expect(groups).to be_a(PEClient::Resource::NodeClassifierV1::Groups)
    end

    it "memorizes the resource" do
      groups1 = resource.groups
      groups2 = resource.groups
      expect(groups1).to equal(groups2)
    end
  end

  describe "#classes" do
    it "returns a Classes resource" do
      classes = resource.classes
      expect(classes).to be_a(PEClient::Resource::NodeClassifierV1::Classes)
    end

    it "memorizes the resource" do
      classes1 = resource.classes
      classes2 = resource.classes
      expect(classes1).to equal(classes2)
    end
  end

  describe "#classification" do
    it "returns a Classification resource" do
      classification = resource.classification
      expect(classification).to be_a(PEClient::Resource::NodeClassifierV1::Classification)
    end

    it "memorizes the resource" do
      classification1 = resource.classification
      classification2 = resource.classification
      expect(classification1).to equal(classification2)
    end
  end

  describe "#commands" do
    it "returns a Commands resource" do
      commands = resource.commands
      expect(commands).to be_a(PEClient::Resource::NodeClassifierV1::Commands)
    end

    it "memorizes the resource" do
      commands1 = resource.commands
      commands2 = resource.commands
      expect(commands1).to equal(commands2)
    end
  end

  describe "#environments" do
    it "returns an Environments resource" do
      environments = resource.environments
      expect(environments).to be_a(PEClient::Resource::NodeClassifierV1::Environments)
    end

    it "memorizes the resource" do
      environments1 = resource.environments
      environments2 = resource.environments
      expect(environments1).to equal(environments2)
    end
  end

  describe "#nodes" do
    it "returns a Nodes resource" do
      nodes = resource.nodes
      expect(nodes).to be_a(PEClient::Resource::NodeClassifierV1::Nodes)
    end

    it "memorizes the resource" do
      nodes1 = resource.nodes
      nodes2 = resource.nodes
      expect(nodes1).to equal(nodes2)
    end
  end

  describe "#group_children" do
    it "returns a GroupChildren resource" do
      group_children = resource.group_children
      expect(group_children).to be_a(PEClient::Resource::NodeClassifierV1::GroupChildren)
    end

    it "memorizes the resource" do
      group_children1 = resource.group_children
      group_children2 = resource.group_children
      expect(group_children1).to equal(group_children2)
    end
  end

  describe "#rules" do
    it "returns a Rules resource" do
      rules = resource.rules
      expect(rules).to be_a(PEClient::Resource::NodeClassifierV1::Rules)
    end

    it "memorizes the resource" do
      rules1 = resource.rules
      rules2 = resource.rules
      expect(rules1).to equal(rules2)
    end
  end

  describe "#import_hierarchy" do
    it "returns an ImportHierarchy resource" do
      import_hierarchy = resource.import_hierarchy
      expect(import_hierarchy).to be_a(PEClient::Resource::NodeClassifierV1::ImportHierarchy)
    end

    it "memorizes the resource" do
      import_hierarchy1 = resource.import_hierarchy
      import_hierarchy2 = resource.import_hierarchy
      expect(import_hierarchy1).to equal(import_hierarchy2)
    end
  end

  describe "#last_class_update" do
    it "returns a LastClassUpdate resource" do
      last_class_update = resource.last_class_update
      expect(last_class_update).to be_a(PEClient::Resource::NodeClassifierV1::LastClassUpdate)
    end

    it "memorizes the resource" do
      last_class_update1 = resource.last_class_update
      last_class_update2 = resource.last_class_update
      expect(last_class_update1).to equal(last_class_update2)
    end
  end

  describe "#update_classes" do
    it "returns an UpdateClasses resource" do
      update_classes = resource.update_classes
      expect(update_classes).to be_a(PEClient::Resource::NodeClassifierV1::UpdateClasses)
    end

    it "memorizes the resource" do
      update_classes1 = resource.update_classes
      update_classes2 = resource.update_classes
      expect(update_classes1).to equal(update_classes2)
    end
  end

  describe "#validation" do
    it "returns a Validation resource" do
      validation = resource.validation
      expect(validation).to be_a(PEClient::Resource::NodeClassifierV1::Validation)
    end

    it "memorizes the resource" do
      validation1 = resource.validation
      validation2 = resource.validation
      expect(validation1).to equal(validation2)
    end
  end
end
