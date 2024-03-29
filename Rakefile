# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

def shell(*args)
  puts "running: #{args.join(' ')}"
  system(args.join(' '))
end

task :clean do
  shell('rm -rf pkg/ tmp/ coverage/ doc/ ')
end

task gem: [:build] do
  shell('gem install pkg/*')
end

task permissions: [:clean] do
  shell('chmod -v o+r,g+r * */* */*/* */*/*/* */*/*/*/* */*/*/*/*/*')
  shell('find . -type d -exec chmod o+x,g+x {} \\;')
end

task build: :permissions

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = %w[lib/**/*.rb exe/* - README.adoc CHANGELOG.md LICENSE.txt]
  t.options.unshift('--title', '"Puma Daemon"')
  t.after = -> { exec('open doc/index.html') }
end

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

task default: %i[spec rubocop]
