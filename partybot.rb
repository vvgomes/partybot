require_relative 'config/environment'

helpers do
  def nightclub
    @nightclub ||= Nightclub.new(Kernel.const_get(ENV['DRIVER']).new)
  end
end

get '/' do
  status 200
end

post 'subscriptions' do
end

