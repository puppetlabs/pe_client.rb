# frozen_string_literal: true

require "pe_client"
require "webmock/rspec"

ENV["RBS_TEST_TARGET"] ||= "PEClient::*"
ENV["RBS_TEST_LOGLEVEL"] ||= "fatal"
require "rbs/test/setup"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # WebMock configuration
  WebMock.disable_net_connect!(allow_localhost: true)
end
