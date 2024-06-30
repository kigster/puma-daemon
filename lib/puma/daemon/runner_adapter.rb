# frozen_string_literal: true

require_relative 'version'

module Puma
  module Daemon
    # noinspection RubySuperCallWithoutSuperclassInspection
    module RunnerAdapter
      class << self
        def included(base)
          base.class_eval do
            attr_reader :options
            attr_accessor :has_demonized
          end

          base.class_eval do
            def output_header(mode)
              super

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
              return if str.include?('Ctrl-C')

              begin
                super
              rescue StandardError
                puts(str)
              end
            end
          end
        end
      end
    end
  end
end
