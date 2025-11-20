# frozen_string_literal: true

require_relative "lib/pe_client/version"

Gem::Specification.new do |spec|
  spec.name = "pe_client"
  spec.version = PEClient::VERSION
  spec.authors = ["Zach Bensley"]
  spec.email = ["zach.bensley@perforce.com"]
  spec.license = "Apache-2.0"

  spec.summary = "Client library for Puppet API endpoints"
  spec.description = <<-DESC
    Client library for interacting with Puppet Enterprise and Puppet Core API endpoints.

    See https://help.puppet.com/pe/2025.6/topics/api_index.html for more information about the API.
  DESC
  spec.homepage = "https://puppet.com"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/puppetlabs/pe_client.rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml .yard-lint.yml .ruby-version CODEOWNERS])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.14"
end
