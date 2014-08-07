require 'sinatra'
require 'mongoid'

Mongoid.load!('mongoid.yml', ENV['RACK_ENV'])

get '/' do
  status 200
end

