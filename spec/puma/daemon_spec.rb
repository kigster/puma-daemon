# frozen_string_literal: true

require 'spec_helper'
require 'puma/daemon/version'

module Puma
  RSpec.describe Daemon do
    let(:cli) { ::Puma::Daemon::CLI.new(argv).cli }
    let(:argv) { [] }
    let(:wait_booted) { -> { wait.sysread 1 } }
    let(:environment) { 'production' }

    after do
      @wait&.close
      @ready&.close
    end

    before do
      @environment = 'production'
      @wait, @ready = ::IO.pipe

      @tmp_path1 = tmp_path('puma-test-1')
      @tmp_path2 = tmp_path('puma-test-2')

      FileUtils.rm_f @tmp_path1
      FileUtils.rm_f @tmp_path2

      @wait, @ready = IO.pipe
    end

    it 'has a version number' do
      expect(Daemon::VERSION).not_to be_nil
    end

    include TmpPath

    describe 'when starting Runners' do
      describe 'single-process daemon' do
        let(:argv) { [] }

        describe Single do
          subject(:single) { ::Puma::Const::VERSION.match?(/^5/) ? described_class.new(cli.launcher, cli.instance_variable_get(:@events)) : described_class.new(cli.launcher) }
          # This is not a real test
          it { is_expected.to respond_to :daemonize! }
        end
      end

      describe 'when using multi-process cluster daemon' do
        describe Cluster do
          subject(:single) { ::Puma::Const::VERSION.match?(/^5/) ? described_class.new(cli.launcher, cli.instance_variable_get(:@events)) : described_class.new(cli.launcher) }
          let(:url) { "unix://#{@tmp_path1}" }
          let(:argv) do
            ['-b', "unix://#{@tmp_path2}",
             '-t', '2:2',
             '-w', '2',
             '--control-url', url,
             '--control-token', '',
             'spec/rackup/lobster.ru']
          end

          # This is not a real test
          it { is_expected.to respond_to :daemonize! }
        end
      end
    end
  end
end
