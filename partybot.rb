require_relative 'config/environment'
require 'sinatra'
require 'json'

get '/' do
  status(200)
end

get '/parties' do
  content_type :json
  Party.asc(:public_id).map(&:to_h).to_json
end

post '/guests' do
  logger.info "NEW GUEST => #{params}"

  return status(400) unless (guest = Guest.new(params)).valid?
  return status(204) if (parties = Party.for(guest)).empty?

  Club.current.subscribe(guest, parties)
  status(201)
end

