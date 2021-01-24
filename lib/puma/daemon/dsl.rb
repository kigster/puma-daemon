# frozen_string_literal: true

module Puma
  module Daemon
    module DSL
      # Daemonize the server into the background. It's highly recommended to
      # use this in combination with +pidfile+ and +stdout_redirect+.
      #
      # The default is "false".
      #
      # @example
      #   daemonize
      #
      # @example
      #   daemonize false
      def daemonize(which = true)
        @options[:daemon] = which
      end

      attr_reader :options
    end
  end
end
