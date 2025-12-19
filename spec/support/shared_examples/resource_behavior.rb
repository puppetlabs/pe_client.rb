# frozen_string_literal: true

# Shared examples for resource behavior patterns
RSpec.shared_examples "a memoized resource" do |method_name, expected_class_name|
  describe "##{method_name}" do
    it "returns the correct type and memoizes the resource" do
      resource1 = subject.public_send(method_name)
      resource2 = subject.public_send(method_name)

      expected_class = Object.const_get(expected_class_name.to_s)
      expect(resource1).to be_a(expected_class)
      expect(resource1).to equal(resource2)
    end
  end
end

RSpec.shared_examples "a resource with port" do |default_port|
  it "initializes with the default port" do
    resource_client = subject.instance_variable_get(:@client)
    expect(resource_client.connection.url_prefix.port).to eq(default_port)
  end

  it "accepts a custom port parameter" do
    custom_resource = described_class.new(client, port: default_port + 1000)
    resource_client = custom_resource.instance_variable_get(:@client)
    expect(resource_client.connection.url_prefix.port).to eq(default_port + 1000)
  end
end
