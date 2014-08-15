require 'rake'

unless ENV['RACK_ENV'] == 'production'
  require 'rake/testtask'

  test = namespace :test do
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

  task :test => [test[:unit], test[:integration], test[:acceptance]]
  task :default => :test

  deploy = namespace :deploy do
    execute = ->(cmd) do
      puts "$ #{cmd}"
      abort unless system(cmd)
    end
    ['beco', 'cucko', 'cabaret'].each do |club|
      task club.to_sym do
        puts "# deploing to #{club}..."
        unless `git remote -v`.include?(club)
          execute.("git remote add #{club} git@heroku.com:partybot-#{club}.git")
        end
        execute.("heroku maintenance:on -a partybot-#{club}")
        execute.("git push #{club} master")
        execute.("heroku maintenance:off -a partybot-#{club}")
        puts "# deploy to #{club} successful 🍺:"
      end
    end
  end

  task :deploy => [deploy[:beco], deploy[:cucko], deploy[:lab]]
end

task :sync do
  require_relative 'config/environment'
  puts "before sync: [#{Party.all.map(&:public_id).join(', ')}]"
  Nightclub.current.sync!
  puts "after sync: [#{Party.all.map(&:public_id).join(', ')}]"
end

