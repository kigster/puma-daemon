# frozen_string_literal: true

require 'puma/daemon'
require 'open3'
module RSpec
  module PumaHelpers
    HAS_FORK = ::Process.respond_to? :fork
    NO_FORK_MESSAGE = "Kernel.fork isn't available on #{RUBY_ENGINE} on #{RUBY_PLATFORM}"
    HAS_SOCKETS = Object.const_defined? :UNIXSocket
    NO_SOCKETS_MESSAGE = "UnixSockets aren't available on the #{RUBY_PLATFORM} platform"
    SIGNAL_LIST = Signal.list.keys.map(&:to_sym) - (::Puma.windows? ? [:INT, :TERM] : [])

    class << self
      def skip_fork
        skip NO_FORK_MESSAGE unless HAS_FORK
      end

      def skip_sockets
        skip NO_SOCKETS_MESSAGE unless HAS_SOCKETS
      end

      def runner_instance(cli)
        ::Puma::Const::VERSION.match?(/^5/) ? described_class.new(cli.launcher, cli.instance_variable_get(:@events)) : described_class.new(cli.launcher)
      end

      def fork!(input: '')
        pipes = {
          stdin: IO.pipe,
          stdout: IO.pipe,
          stderr: IO.pipe,
        }

        # Send our input into the write-end of our stdin pipe, for the child to read.
        pipes[:stdin][1].puts input

        pid = fork do
          # Child: close those pipe ends we don't need.
          pipes[:stdin][1].close
          pipes[:stdout][0].close
          pipes[:stderr][0].close

          # Reassign the child's global standard I/O handlers to point to our pipes.
          $stdin = pipes[:stdin][0]
          $stdout = pipes[:stdout][1]
          $stderr = pipes[:stderr][1]

          yield(self) if block_given?

          # Exit the child process.
          exit(0)
        end

        sleep 1

        # Parent: close those pipe ends we don't need.
        pipes[:stdin][0].close
        pipes[:stdin][1].close
        pipes[:stdout][1].close
        pipes[:stderr][1].close

        # Wait for our child to finish.
        Process.wait(pid)

        # Finally, return the contents of the child's stdout and stderr streams for testing.
        [pipes[:stdout][0].read, pipes[:stderr][0].read]
      end

      PROCESS_CMD = "bash -c \"ps -ef | grep [p]uma | grep -v -E 'rspec|rubocop|Makefile|Rakefile'\" 2>&1"

      def puma_pids
        lambda do
          stdout, code = Open3.capture2("#{PROCESS_CMD} | awk '{print $2}'")
          stdout&.split("\n") if code == 0
        end
      end

      def puma_pid_processes
        lambda do
          stdout, code = Open3.capture2(PROCESS_CMD)
          stdout&.split("\n") if code == 0
        end
      end

      def puma_kill
        lambda do
          process_descriptions = puma_pid_processes[]

          if process_descriptions.nil? || process_descriptions.empty?
            puts 'NOTE: no child processes found after fork()'
            return
          end

          current_pid = Process.pid

          warn "Detected the following forked processes (current pid is #{current_pid})"
          warn '———————————————————————————————————————————————————'
          warn process_descriptions.join("\n")
          warn '———————————————————————————————————————————————————'

          puma_pids[].each do |pid|
            next if pid == current_pid

            warn "killing puma pid #{pid}"

            begin
              Process.kill('SIGTERM', pid.to_i)
            rescue StandardError
              nil
            end

            begin
              Process.kill('SIGKILL', pid.to_i)
            rescue StandardError
              nil
            end
          end
        end
      end
    end
  end
end

require_relative 'tmp_path'
