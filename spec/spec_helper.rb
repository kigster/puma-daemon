# frozen_string_literal: true

require 'rspec'
require 'rspec/its'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

if ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
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
