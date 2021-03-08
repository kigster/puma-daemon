#!/usr/bin/env ruby -I lib
require 'rack/app'
require 'puma/daemon'

module Puma
  class RackApp < ::Rack::App

    desc 'Awesome Test Endpoint'
    get '/hello' do
      'Hello World!'
    end
  end
end


if $0 == __FILE__
  require 'rack'
  Rack::Server.start(
    app: Rack::ShowExceptions.new(Rack::Lint.new(Puma::RackApp.new)), Port: 3001
  )
end
