require_relative '../test_helper' 
require 'rack/test'
require_relative '../../partybot.rb' 

class PartybotTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  setup do
    Party.delete_all 
    Party.create(:public_id => '1', :emails => ['bro@foo.com'])
    Party.create(:public_id => '2', :emails => ['bro@foo.com'])
    @payload = {
      :parties => ['1', '2'],
      :user => {:name => 'Dude', :email => 'dude@gmail.com'}
    }
  end

  test 'successful subscription' do
    post '/subscriptions', @payload 
    assert last_response.status == 201
    assert last_response.body == '{"1":"200","2":"200"}'
  end

  test 'no user' do
    @payload[:user] = nil
    post '/subscriptions', @payload 
    assert last_response.status == 400
  end

  test 'bad user' do
    @payload[:user][:email] = nil
    post '/subscriptions', @payload 
    assert last_response.status == 400
  end

  test 'no parties' do
    @payload[:parties] = nil
    post '/subscriptions', @payload 
    assert last_response.status == 404
  end

  test 'bad parties' do
    @payload[:parties] = ['3']
    post '/subscriptions', @payload 
    assert last_response.status == 404
  end

  test 'duplicated subscription' do
    @payload[:user][:email] = 'bro@foo.com'
    post '/subscriptions', @payload 
    assert last_response.status == 204
  end
end

