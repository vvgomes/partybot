require_relative 'config/environment'
require 'sinatra'
require 'json'

get '/' do
  status 200
end

post '/subscriptions' do
  content_type :json
  logger.info "NEW SUBSCRIPTION: #{params}"

  user = User.new(params[:user])
  return status(400) unless user.valid?

  parties = params[:party] ?
  Party.where(:public_id => params[:party]) : Party.available(user)
  return status(404) if parties.empty?

  Nightclub.current.subscribe(user, parties).tap do |subscription|
    logger.info "RESULTS: #{subscription}"
    subscription.failed? ? status(500) : status(201)
  end.to_json
end

