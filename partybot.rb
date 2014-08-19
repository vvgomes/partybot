require_relative 'config/environment'
require 'sinatra'
require 'json'

get '/' do
  status 200
end

get '/subscriptions' do
  content_type :json
  Party.all.map(&:to_h).reduce(&:merge).to_json
end

post '/subscriptions' do
  content_type :json
  logger.info "SUBSCRIPTION: #{params}"

  user = User.new(params[:user])
  return status(400) unless user.valid?

  parties = params[:party] ?
  Party.where(:public_id => params[:party]) : Party.available(user)
  return status(404) if parties.empty?

  subscription = Nightclub.current.subscribe(user, parties)
  subscription.failed? ? status(500) : status(201)
  subscription.to_json
end

