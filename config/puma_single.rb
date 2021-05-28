# frozen_string_literal: true

require_relative 'hello_app'
config_name = 'single'
eval File.read(File.expand_path('./puma_shared.rb', __dir__))

