require 'spec_helper'
require 'rack/app'
require_relative 'rack_app'

module Puma
  RSpec.describe RackApp do
    let(:dir) { Dir.pwd }
    let(:log_dir) { "#{dir}/log" }
    let(:puma_count) { ->() { `ps -ef | grep [p]uma | grep -v spec | wc -l`.strip.to_i } }
    let(:puma_kill_cmd) { 'pkill [p]uma; sleep 2; pkill -9 [p]uma' }
    before do
      FileUtils.rm_rf(log_dir) if Dir.exist?(log_dir)
      `#{puma_kill_cmd}`
    end

    after { `#{puma_kill_cmd}` }
    before { puts `#{command}` }

    context 'cluster mode' do
      let(:command) {
        %Q{bundle exec #{dir}/exe/pumad -v
            --debug -w 2
            -C #{dir}/config/puma_single.rb
            #{dir}/spec/app/rack_app.rb
         }.gsub(/\n/, ' ')
      }

      it 'should start RackApp in a cluster mode' do
        expect(puma_count[]).to eq 3
      end
    end

    context 'single mode' do
      let(:command) {
        %Q{bundle exec #{dir}/exe/pumad -v
            --debug
            -C #{dir}/config/puma_single.rb
            #{dir}/spec/app/rack_app.rb
         }.gsub(/\n/, ' ')
      }

      it 'should start RackApp in a single mode' do
        expect(puma_count[]).to eq 1
      end
    end
  end
end
