# frozen_string_literal: true

require_relative 'version'

module Puma
  module Daemon
    module Runner
      attr_reader :options

      def redirect_io
        super

        daemonize! if daemon?
      end

      def daemon?
        options[:daemon]
      end

      def daemonize!
        log "*  Puma Daemon: Daemonizing (puma-daemon v#{::Puma::Daemon::VERSION})..."
        Process.daemon(true)
      end

      def log(str)
        super(str) unless str == 'Use Ctrl-C to stop'
      end
    end
  end
end
