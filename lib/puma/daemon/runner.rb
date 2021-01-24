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
        log '* Daemonizing...'
        Process.daemon(true)
      end

      def log(str)
        super(str) unless str == "Use Ctrl-C to stop"
      end
    end
  end
end
