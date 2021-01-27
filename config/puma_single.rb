# frozen_string_literal: true

require 'puma/daemon'

# workers     3
threads     2, 8
port        3000
environment ENV['RAILS_ENV'] || 'production'
daemonize   ENV['NO_DAEMON'] ? false : true
