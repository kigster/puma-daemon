# frozen_string_literal: true

module Puma
  module Daemon
    module Configuration
      attr_reader :default_dsl, :file_dsl, :user_dsl

      def puma_default_options(*args, **opts, &block)
        super.merge({ daemon: true })
      end

      def daemonize
        super.merge({ daemon: true })
      end
    end
  end
end
