require 'sinatra'
require 'mongoid'
path = File.expand_path(File.dirname(__FILE__))
Dir[File.join(path, '..', 'lib', '*.rb')].each{ |f| require f }
Mongoid.load!(File.join(path, 'mongoid.yml'), ENV['RACK_ENV'])
