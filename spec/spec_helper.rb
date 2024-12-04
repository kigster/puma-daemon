# frozen_string_literal: true

# vim: ft=ruby

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
require 'puma/daemon/version'
require 'puma/daemon'
require 'stringio'

RSpec.configure do |config|
  output = StringIO.new

  config.before do
    $stdout = output
  end

  config.after do
    $stdout = STDOUT
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    puts "Testing Puma Daemon v#{Puma::Daemon::VERSION} for Puma v#{Puma::Server::VERSION}"
  end

  config.after :suite do
    puts
    puts output.string
  end
end
