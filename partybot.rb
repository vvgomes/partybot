require_relative 'config/environment'
require 'sinatra'

get '/' do
  status 200
end

post '/subscriptions' do
  logger.info "NEW SUBSCRIPTION: #{params}"

  user = User.new(params[:user])
  return status(400) unless user.valid?

  parties = params[:party] ?
  Party.where(:public_id => params[:party]) : Party.available(user)
  return status(404) if parties.empty?

  out = Nightclub.current.subscribe(user, parties)
  logger.info "RESULTS: #{out}"
  out.values.find{ |s| s != '200' } ? status(500) : status(201)
end


