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
    2.times.map{ |id| Party.create(:public_id => id.to_s) }
  end

  test 'POST /subscriptions (happy path)' do
    payload = {
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 201
    assert last_response.body == '{"0":"200","1":"200"}'
  end

  test 'POST /subscriptions (with party)' do
    payload = {
      :party => '1',
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 201
    assert last_response.body == '{"1":"200"}'
  end

  test 'POST /subscriptions (with no user)' do
    payload = { :party => '1' }
    post '/subscriptions', payload 
    assert last_response.status == 400
  end

  test 'POST /subscriptions (with bad user)' do
    payload = {
      :user => {
        :name => 'Dude'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 400
  end


  test 'POST /subscription (with absent party)' do
    payload = {
      :party => '3',
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 404
  end

  test 'POST /subscriptions (twice)' do
    payload = {
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    2.times{ post '/subscriptions', payload }
    assert last_response.status == 404
  end
end
