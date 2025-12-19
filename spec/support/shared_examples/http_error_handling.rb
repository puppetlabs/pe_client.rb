# frozen_string_literal: true

# Shared examples for HTTP client error handling
RSpec.shared_examples "http error handling" do |method, path, options = {}|
  [[400, PEClient::BadRequestError],
    [401, PEClient::UnauthorizedError],
    [403, PEClient::ForbiddenError],
    [404, PEClient::NotFoundError],
    [409, PEClient::ConflictError],
    [500, PEClient::ServerError],
    [418, PEClient::HTTPError]].each do |status_code, error_class|
    it "raises #{error_class.name} on #{status_code}" do
      stub_request(method, "#{base_url}#{path}")
        .to_return(status: status_code, body: '{"error": "test"}', headers: {"Content-Type" => "application/json"})

      expect {
        if options[:params]
          client.public_send(method, path, **options)
        else
          client.public_send(method, path)
        end
      }.to raise_error(error_class)
    end
  end
end
