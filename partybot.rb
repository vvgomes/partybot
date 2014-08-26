require_relative 'config/environment'
require 'sinatra'
require 'json'

get '/' do
  status 200
end

get '/parties' do
  content_type :json
  filters = params.slice('including', 'missing')
  parties = filters.reduce(Party.all) do |results, (filter, value)|
    results = results.send(filter, value)
  end
  return status(404) if parties.empty?
  parties.map(&:to_h).to_json
end

post '/subscriptions' do
  content_type :json
  logger.info "SUBSCRIPTION: #{params}"

  user = User.new(params[:user])
  return status(400) unless user.valid?

  parties = Party.in(:public_id => params[:parties])
  return status(404) if parties.empty?

  results = Nightclub.current.subscribe(user, parties)
  return status(204) if results.empty?

  results.values.find{ |s| s != '200' } ? status(500) : status(201)
  results.to_json
end

