require_relative 'config/environment'

get '/' do
  status 200
end

post '/subscriptions' do
  user = User.new(params[:user]) 
  return status(400) unless user.valid?
  if params[:party]
    party = Party.where(:public_id => params[:party]).first
    return status(400) unless party
    Nightclub.current.subscribe(user, party)
  else
    Nightclub.current.bulk_subscribe(user, party)
  end
  status(200)
end

