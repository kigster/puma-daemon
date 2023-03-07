# frozen_string_literal: true

require_relative 'version'

module Puma
  module Daemon
    module RunnerAdapter
      attr_reader :options
      attr_accessor :has_demonized

      def output_header(mode)
        super(mode)

        daemonize! if daemon?
      end

      def daemon?
        options[:daemon]
      end

      def daemonize!
        return if has_demonized

        log '*  Puma Daemon: Demonizing...'
        log "*  Gem: puma-daemon v#{::Puma::Daemon::VERSION}"
        log "*  Gem: puma v#{::Puma::Const::VERSION}"

        Process.daemon(true, true)
        self.has_demonized = true
      end

      def log(str)
        super(str) unless str == 'Use Ctrl-C to stop'
      end
    end
  end
end
