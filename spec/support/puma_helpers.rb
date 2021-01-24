# frozen_string_literal: true

require 'puma/daemon'

module RSpec
  module PumaHelpers
    HAS_FORK           = ::Process.respond_to? :fork
    NO_FORK_MESSAGE    = "Kernel.fork isn't available on #{RUBY_ENGINE} on #{RUBY_PLATFORM}"
    HAS_SOCKETS        = Object.const_defined? :UNIXSocket
    NO_SOCKETS_MESSAGE = "UnixSockets aren't available on the #{RUBY_PLATFORM} platform"
    SIGNAL_LIST        = Signal.list.keys.map(&:to_sym) - (::Puma.windows? ? [:INT, :TERM] : [])

    def skip_fork
      skip NO_FORK_MESSAGE unless HAS_FORK
    end

    def skip_sockets
      skip NO_SOCKETS_MESSAGE unless HAS_SOCKETS
    end
  end
end

require_relative 'tmp_path'
