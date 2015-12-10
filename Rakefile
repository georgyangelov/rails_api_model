require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :environment do
  $LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
  require 'rails_api_model'

  include RailsApiModel
end

task console: :environment do
  require 'pry'

  Pry.start
end
