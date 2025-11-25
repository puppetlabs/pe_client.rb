# frozen_string_literal: true

RSpec.describe PEClient do
  it "has a version number" do
    expect(PEClient::VERSION).not_to be_nil
  end

  describe ".new" do
    let(:api_key) { "test_api_key_12345" }
    let(:base_url) { "https://puppet.example.com:8143" }

    it "creates a new PEClient::Client instance" do
      client = described_class.new(api_key: api_key, base_url: base_url, ca_file: "")
      expect(client).to be_a(PEClient::Client)
      expect(client.api_key).to eq(api_key)
      expect(client.base_url.to_s).to eq(base_url)
    end

    it "passes a block to Client initialization" do
      client = described_class.new(api_key: api_key, base_url: base_url, ca_file: "") do |conn|
        conn.headers["Custom-Header"] = "test"
      end
      expect(client.connection.headers["Custom-Header"]).to eq("test")
    end
  end

  describe ".deprecated" do
    it "outputs a deprecation warning" do
      expect {
        described_class.deprecated("old_method", "new_method")
      }.to output(/\[DEPRECATION\] `old_method` is deprecated. Please use `new_method` instead./).to_stderr
    end
  end
end
