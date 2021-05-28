require 'rack/app'
require 'puma/daemon'

class HelloApp < ::Rack::App
  desc 'Hello Endpoint'
  get '/' do
    '<html><body><h1 style="margin: 40px auto;">Hello World!</h1></body></html>'
  end
end
