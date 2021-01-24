# frozen_string_literal: true

module Puma
  module Daemon
    class CLI
      attr_accessor :argv, :cli

      def initialize(argv = ARGV, events = Events.stdio)
        self.argv = argv
        self.cli = ::Puma::CLI.new(argv, events)
      end

      def run
        cli.run
      end
    end
  end
end
