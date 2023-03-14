# frozen_string_literal: true

require 'spec_helper'
require 'httparty'

module Puma
  RSpec.describe Daemon do
    def start_server_and_verify!(port, cli)
      ::RSpec::PumaHelpers.fork!(input: $stdin) do
        require 'simplecov' # this will also pick up whatever config is in .simplecov
        # so ensure it just contains configuration, and doesn't call SimpleCov.start.
        SimpleCov.command_name "puma-daemon#{port}" # As this is not for a test runner directly, script doesn't have a pre-defined base command_name
        SimpleCov.at_fork.call(Process.pid) # Use the per-process setup described previously
        SimpleCov.start do
          add_filter 'spec' # Ensure we don't get coverage from the spec files
        end

        response = nil

        Thread.new do
          # runner.include(::Puma::Daemon::RunnerAdapter)
          runner_instance(cli).daemonize!
          runner_instance(cli).run
          response = HTTParty.get("http://127.0.0.1:#{port}")
        end

        Thread.join

        expect(response).to_not be_nil

        expect(response.code).to eq(200)
        expect(response.body).to eq('Hello World')
      end

      sleep 1
    end

    let(:environment) { 'production' }
    let(:wait_booted) { -> { wait.sysread 1 } }
    let(:argv) { [] }

    include TmpPath

    before do
      @environment = 'production'
      @wait, @ready = ::IO.pipe

      @tmp_path1 = tmp_path('puma-test-1')
      @tmp_path2 = tmp_path('puma-test-2')

      @port1 = 61_234
      @port2 = 61_235

      File.unlink @tmp_path1 if File.exist? @tmp_path1
      File.unlink @tmp_path2 if File.exist? @tmp_path2

      @wait, @ready = IO.pipe
    end

    after do
      @wait&.close
      @ready&.close
    end

    context 'runners' do
      describe 'single-process daemon' do
        describe Single do
          let(:argv) { %W[-b tcp://0.0.0.0:#{@port1} spec/rackup/bind.ru] }
          let(:cli) { ::Puma::Daemon::CLI.new(argv).cli }
          let(:runner) { runner_instance(cli) }
          let(:port) { @port1 }

          before { ::RSpec::PumaHelpers.puma_kill[] }

          it 'should have puma running on the background' do
            start_server_and_verify!(port, cli)
          end

          after do
            expect(::RSpec::PumaHelpers.puma_pids[]).to be_empty
          end
        end

        describe Cluster do
          let(:argv) { %W[-b tcp://0.0.0.0:#{@port1} spec/rackup/bind.ru -w 2] }
          let(:cli) { ::Puma::Daemon::CLI.new(argv).cli }
          let(:runner) { ::RSpec::PumaHelpers.runner_instance(cli) }
          let(:port) { @port2 }

          before { ::RSpec::PumaHelpers.puma_kill[] }

          it 'should have puma running on the background' do
            start_server_and_verify!(port, cli)
          end

          after do
            expect(::RSpec::PumaHelpers.puma_pids[]).to be_empty
          end
        end
      end
    end
  end
end
