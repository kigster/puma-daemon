# frozen_string_literal: true

require 'puma'
require 'puma/const'
require 'puma/runner'
require 'puma/single'
require 'puma/cluster'
require 'puma/dsl'
require 'puma/cli'

require 'puma/daemon/version'
require 'puma/daemon/runner_adapter'
require 'puma/daemon/configuration'
require 'puma/daemon/cli'
require 'puma/daemon/dsl'

module Puma
  module Daemon
    def self.daemonize!
      ::Puma::Single.include(::Puma::Daemon::RunnerAdapter)
      ::Puma::Cluster.include(::Puma::Daemon::RunnerAdapter)
      ::Puma::DSL.include(::Puma::Daemon::DSL)
      ::Puma::Configuration.prepend(::Puma::Daemon::Configuration)
      ::Puma::CLI.instance_eval { attr_reader :options }
    end
  end
end

Puma::Daemon.daemonize!
