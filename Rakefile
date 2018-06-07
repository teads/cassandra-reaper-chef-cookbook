require 'foodcritic'
require 'rspec/core/rake_task'

desc 'Run linter and unit tests'
task unit: %w(foodcritic spec)

desc 'Run linter, unit tests and integration tests'
task default: %w(foodcritic spec integration)

desc 'Run foodcritic linter'
FoodCritic::Rake::LintTask.new do |fc|
  fc.options = {
    fail_tags: ['any'],
  }
end

desc 'Run ChefSpec'
task :spec do
  RSpec::Core::RakeTask.new(:spec)
end

desc 'Run integration tests with kitchen-vagrant'
task :integration do
  require 'kitchen'
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end
