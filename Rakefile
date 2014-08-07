require 'rake'

unless ENV['RACK_ENV'] == 'production'
  require 'rake/testtask'

  n = namespace :test do
    Rake::TestTask.new(:unit) do |t|
      t.pattern = 'test/unit/*_test.rb'
    end

    Rake::TestTask.new(:integration) do |t|
      t.pattern = 'test/integration/*_test.rb'
    end
  end

  task :test => [n[:unit], n[:integration]]
  task :default => :test
end

task :sync do
  puts 'sync'
end
