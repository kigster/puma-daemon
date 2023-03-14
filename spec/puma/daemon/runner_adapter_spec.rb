require 'spec_helper'

class Adapter
  include Puma::Daemon::RunnerAdapter

  def log(str)
    puts str
  end
end

module Puma
  module Daemon
    RSpec.describe RunnerAdapter do
      subject(:adapter) { Adapter.new }

      before {
        adapter.has_demonized = false
        expect(::Process).to receive(:daemon)
      }

      its(:daemonize!) { is_expected.to be_truthy }
    end
  end
end
