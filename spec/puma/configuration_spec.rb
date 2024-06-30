# frozen_string_literal: true

require 'spec_helper'

module Puma
  RSpec.describe Configuration do
    let(:daemonize) { true }

    describe 'config: daemonize(true)' do
      let(:config) do
        ::Puma::Configuration.new({}) do |user_config|
          user_config.port 3001
          user_config.daemonize(daemonize)
        end
      end

      it(:puma_default_options) { is_expected.not_to be_nil }

      describe '#default_dsl' do
        subject { config.default_dsl.options }

        its([:daemon]) { is_expected.to be true }
      end

      describe '#user_dsl' do
        describe 'when using default options' do
          subject { config.user_dsl.options }

          its([:daemon]) { is_expected.to be true }
          its([:binds]) { is_expected.to eq ['tcp://0.0.0.0:3001'] }
        end

        describe 'when daemonize is false)' do
          subject { config.user_dsl.options }

          let(:daemonize) { false }

          its([:daemon]) { is_expected.to be false }
        end
      end

      describe 'file_dsl' do
        subject { config.options }

        let(:config) do
          ::Puma::Configuration.new do |c|
            c.rackup 'spec/rackup/bind.ru'
            c.port 3000
          end.tap(&:load)
        end

        its([:binds]) { is_expected.to eq ['tcp://0.0.0.0:3000'] }
        its([:daemon]) { is_expected.to be true }
      end

      describe 'pidfile' do
        subject { config.options }

        let(:pidfile) { Tempfile.new('pidfile') }
        let(:config) do
          ::Puma::Configuration.new do |c|
            c.pidfile(pidfile)
            c.port 3000
          end.tap(&:load)
        end

        its([:binds]) { is_expected.to eq ['tcp://0.0.0.0:3000'] }
        its([:daemon]) { is_expected.to be true }
      end
    end
  end
end
