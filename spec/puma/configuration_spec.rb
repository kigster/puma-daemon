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

      it(:puma_default_options) { should_not be_nil }

      context 'default_dsl' do
        subject { config.default_dsl.options }
        its([:daemon]) { should be true }
      end

      context 'user_dsl' do
        subject { config.user_dsl.options }
        its([:daemon]) { should be true }
        its([:binds]) { should eq ["tcp://0.0.0.0:3001"] }
      end

      describe 'config: daemonize(false)' do
        let(:daemonize) { false }
        context 'user_dsl' do
          subject { config.user_dsl.options }
          its([:daemon]) { should be false }
        end
      end

      context 'file_dsl' do
        let(:config) do
          ::Puma::Configuration.new do |c|
            c.rackup "spec/rackup/bind.ru"
          end.tap { |config| config.load }
        end

        subject { config.options }

        its([:binds]) { should eq ["tcp://0.0.0.0:3000"] }
        its([:daemon]) { should be true }
      end
    end
  end
end
