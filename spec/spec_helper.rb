# frozen_string_literal: true

require 'rspec'
require 'rspec/its'
require 'tempfile'

require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.at_fork do |pid|
  # This needs a unique name so it won't be overwritten
  SimpleCov.command_name "#{SimpleCov.command_name} (subprocess: #{pid})"
  # be quiet, the parent process will be in charge of output and checking coverage totals
  SimpleCov.print_error_status = true
  SimpleCov.minimum_coverage 0
  # start
  SimpleCov.formatter SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::SimpleFormatter,
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 SimpleCov::Formatter::CoberturaFormatter
                                                               ])
  SimpleCov.start
  SimpleCov.track_files 'lib/**/*.rb'
end

SimpleCov.start do
  add_filter 'spec'
  at_exit do
    SimpleCov.result.format!
  end
end

require_relative 'support/puma_helpers'
require 'puma/daemon'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
