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

    Rake::TestTask.new(:acceptance) do |t|
      t.pattern = 'test/acceptance/*_test.rb'
    end
  end

  task :test => [n[:unit], n[:integration], n[:acceptance]]
  task :default => :test
end

task :sync do
  require_relative 'config/environment'
  puts "before sync: [#{Party.all.map(&:public_id).join(', ')}]"
  Nightclub.current.sync!
  puts "after sync: [#{Party.all.map(&:public_id).join(', ')}]"
end
