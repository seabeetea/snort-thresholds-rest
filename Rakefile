require 'bundler'
require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :test

RSpec::Core::RakeTask.new(:test) do |task|
    task.pattern = "test/test_*.rb"
end
=begin
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end
=end
