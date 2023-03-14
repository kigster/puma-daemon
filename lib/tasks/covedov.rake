namespace :codecov do
  desc 'Upload coverage to codecov'
  task :upload do
    require 'simplecov'
    require 'codecov'

    formatter = SimpleCov::Formatter::Codecov.new
    formatter.format(SimpleCov::ResultMerger.merged_result)
  end
end

