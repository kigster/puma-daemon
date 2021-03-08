require 'fileutils'
require 'puma'
require 'puma/daemon'

config_name ||= 'unknown'

dir         = Dir.pwd
require "#{dir}/config/hello_app"

log_dir = dir + '/' + "log"
FileUtils.mkdir_p(log_dir)

threads 2, 8
port 3000
environment ENV['RAILS_ENV'] || 'production'
stdout_redirect "#{log_dir}/puma-#{config_name}.stdout.log",
                "#{log_dir}/puma-#{config_name}.stderr.log"

app HelloApp

daemonize ENV['NO_DAEMON'] ? false : true
