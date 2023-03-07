# frozen_string_literal: true

require 'spec_helper'

module Puma
  RSpec.describe Daemon do
    it 'has a version number' do
      expect(Daemon::VERSION).not_to be nil
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

      File.unlink @tmp_path1 if File.exist? @tmp_path1
      File.unlink @tmp_path2 if File.exist? @tmp_path2

      @wait, @ready = IO.pipe
    end

    after do
      @wait&.close
      @ready&.close
    end

    let(:cli) { ::Puma::Daemon::CLI.new(argv).cli }

    context 'runners' do

      describe 'single-process daemon' do
        let(:argv) { [] }

        describe Single do
          subject(:single) { ::Puma::Const::VERSION =~ /^5/ ? described_class.new(cli.launcher, cli.instance_variable_get(:@events)) : described_class.new(cli.launcher) }
          # This is not a real test
          it { is_expected.to respond_to :daemonize! }
        end
      end

      describe 'multi-process cluster daemon' do
        describe Cluster do
          subject(:single) { ::Puma::Const::VERSION =~ /^5/ ? described_class.new(cli.launcher, cli.instance_variable_get(:@events)) : described_class.new(cli.launcher) }
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
