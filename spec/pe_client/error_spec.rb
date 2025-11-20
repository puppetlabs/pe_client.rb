# frozen_string_literal: true

RSpec.describe PEClient::HTTPError do
  let(:response) do
    instance_double(
      Faraday::Response,
      status: 500,
      body: {"error" => "test error"}
    )
  end

  describe "#initialize" do
    it "stores the response" do
      error = described_class.new(response)
      expect(error.response).to eq(response)
    end

    it "uses default error message" do
      error = described_class.new(response)
      expect(error.message).to match(/HTTP 500 Error/)
    end

    it "accepts a custom message" do
      error = described_class.new(response, "Custom error message")
      expect(error.message).to eq("Custom error message")
    end
  end

  describe "#response" do
    it "provides access to the HTTP response" do
      error = described_class.new(response)
      expect(error.response).to eq(response)
    end
  end
end
