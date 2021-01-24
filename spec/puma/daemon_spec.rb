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
    let(:events) {  Puma::Events.strings }

    include TmpPath

    before do
      @environment  = 'production'
      @events       = Events.strings
      @wait, @ready = ::IO.pipe
      @events&.on_booted { ready << '!' }

      @tmp_path  = tmp_path('puma-test')
      @tmp_path2 = "#{@tmp_path}2"

      File.unlink @tmp_path if File.exist? @tmp_path
      File.unlink @tmp_path2 if File.exist? @tmp_path2

      @wait, @ready = IO.pipe

      events.on_booted { @ready << '!' }
    end

    after do
      @wait&.close
      @ready&.close
    end

    let(:cli) { ::Puma::Daemon::CLI.new(argv, events).cli }

    context 'runners' do
      subject(:runner) { described_class.new(cli, events) }

      describe 'single-process daemon' do
        let(:argv) { [] }

        describe Single do
          subject(:single) { described_class.new(cli, events) }
          it { is_expected.to respond_to :daemonize! }
        end
      end

      describe 'multi-process cluster daemon' do
        describe Cluster do
          let(:url) { "unix://#{@tmp_path}" }
          let(:argv) do
            ['-b', "unix://#{@tmp_path2}",
             '-t', '2:2',
             '-w', '2',
             '--control-url', url,
             '--control-token', '',
             'spec/rackup/lobster.ru']
          end

          it { is_expected.to respond_to :daemonize! }
        end
      end
    end
  end
end
