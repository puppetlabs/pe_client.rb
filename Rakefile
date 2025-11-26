# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

task :yard_lint do
  sh "yard-lint ."
end

task default: %i[spec standard yard_lint]
