require 'rake'

unless ENV['RACK_ENV'] == 'production'
  require 'rake/testtask'

  test = namespace :test do
    Rake::TestTask.new(:unit) do |t|
      t.pattern = 'test/unit/*_test.rb'
      t.verbose = true
    end

    Rake::TestTask.new(:integration) do |t|
      t.pattern = 'test/integration/*_test.rb'
      t.verbose = true
    end

    Rake::TestTask.new(:acceptance) do |t|
      t.pattern = 'test/acceptance/*_test.rb'
      t.verbose = true
    end
  end

  task :test => [test[:unit], test[:integration], test[:acceptance]]
  task :default => :test

  deploy = namespace :deploy do
    execute = ->(cmd) do
      puts "$ #{cmd}"
      abort unless system(cmd)
    end
    ['beco', 'cucko', 'lab'].each do |club|
      task club.to_sym do
        puts "# deploing to #{club}..."
        app = ENV[club.upcase]
        unless `git remote -v`.include?(club)
          execute.("git remote add #{club} git@heroku.com:#{app}.git")
        end
        execute.("heroku maintenance:on -a #{app}")
        execute.("git push #{club} master")
        execute.("heroku maintenance:off -a #{app}")
        puts "# deploy to #{club} successful 🍺:"
      end
    end
  end

  task :deploy => [deploy[:beco], deploy[:cucko], deploy[:lab]]
end

task :sync do
  require_relative 'config/environment'
  puts "SYNC: before => [#{Party.all.map(&:public_id).join(', ')}]"
  Nightclub.current.sync!
  puts "SYNC: after => [#{Party.all.map(&:public_id).join(', ')}]"
end

task :wakeup do
  require_relative 'config/environment'
  puts 'WAKEUP!'
  Mechanize.new.get("http://partybot-#{ENV['DRIVER'].downcase}.herokuapp.com/")
end

