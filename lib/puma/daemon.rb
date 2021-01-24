# frozen_string_literal: true

require 'puma/runner'
require 'puma/single'
require 'puma/cluster'
require 'puma/dsl'
require 'puma/cli'

require 'puma/daemon/version'
require 'puma/daemon/cli'
require 'puma/daemon/runner'
require 'puma/daemon/dsl'
require 'puma/daemon/configuration'

module Puma
  module Daemon
    def self.daemonize!
      ::Puma::Single.include(::Puma::Daemon::Runner)
      ::Puma::Cluster.include(::Puma::Daemon::Runner)
      ::Puma::DSL.include(::Puma::Daemon::DSL)
      ::Puma::Configuration.prepend(::Puma::Daemon::Configuration)
      ::Puma::CLI.instance_eval { attr_reader :options }
    end
  end
end

Puma::Daemon.daemonize!
