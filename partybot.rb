require_relative 'config/environment'
require 'sinatra'
require 'json'

get '/parties' do
  content_type :json
  Party.asc(:public_id).map(&:to_h).to_json
end

post '/guests' do
  logger.info "NEW GUEST => #{params}"

  guest = Guest.new(params)
  return status(400) unless guest.valid?

  parties = Party.for(guest)
  return status(204) if parties.empty?

  Nightclub.current.subscribe(guest, parties)
  status(201)
end

