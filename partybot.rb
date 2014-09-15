require_relative 'config/environment'
require 'sinatra'
require 'json'

get '/parties' do
  content_type :json
  Party.asc(:public_id).map(&:to_h).to_json
end

post '/guests' do
  logger.info "NEW GUEST => #{params}"

  user = User.new(params)
  return status(400) unless user.valid?

  parties = Party.for(user)
  return status(204) if parties.empty?

  Nightclub.current.subscribe(user, parties)
  status(201)
end

