# frozen_string_literal: true

require_relative '../daemon'

module Puma
  module Daemon
    class CLI
      attr_accessor :argv, :cli

      def initialize(argv = ARGV)
        self.argv = argv
        self.cli = ::Puma::CLI.new(argv)
      end

      def run
        cli.run
      end
    end
  end
end
