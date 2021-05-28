# frozen_string_literal: true

require 'puma'
require 'puma/runner'
require 'puma/single'
require 'puma/cluster'
require 'puma/dsl'
require 'puma/cli'

require 'puma/daemon/version'
require 'puma/daemon/runner'
require 'puma/daemon/configuration'
require 'puma/daemon/dsl'
require 'puma/daemon/cli'

module Puma
  module Daemon
    def self.daemonize!
      # Monkey Patch Various Methods to re-enable
      # Daemonization. We worked backwards to revert
      # most of the https://github.com/puma/puma/pull/2170/
      # pull request, but it is possible future versions of
      # Puma will further diverge from the 4.0 and more monkey
      # patching will be needed.
      ::Puma::Cluster.prepend(::Puma::Daemon::Runner)
      ::Puma::Single.prepend(::Puma::Daemon::Runner)
      ::Puma::DSL.include(::Puma::Daemon::DSL)
      ::Puma::Configuration.prepend(::Puma::Daemon::Configuration)
      ::Puma::CLI.instance_eval { attr_reader :options }
    end
  end
end

Puma::Daemon.daemonize!


