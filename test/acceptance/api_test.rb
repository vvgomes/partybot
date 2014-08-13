require_relative '../test_helper' 
require 'rack/test'
require_relative '../../partybot.rb' 

class APITest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  setup do
    ENV['DRIVER'] = NullDriver.to_s
    Party.delete_all 
    @rockwork = Party.create(:public_id => '1')
    @londoncalling = Party.create(:public_id => '2')
  end

  test 'subscribe an user to a party' do
    payload = {
      :party => '1',
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 200
    assert @rockwork.reload.emails.include? 'dude@gmail.com'
    assert @londoncalling.reload.emails.empty?
  end

  test 'subscribe an user to all parties' do
    payload = {
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 200
    assert @rockwork.reload.emails.include? 'dude@gmail.com'
    assert @londoncalling.reload.emails.include? 'dude@gmail.com'
  end


  test 'subscribe with no user' do
    payload = { :party => '99' }
    post '/subscriptions', payload 
    assert last_response.status == 400
    assert @rockwork.reload.emails.empty?
    assert @londoncalling.reload.emails.empty?
  end

  test 'subscribe with invalid user' do
    payload = {
      :party => '99',
      :user => {
        :name => 'Dude'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 400
    assert @rockwork.reload.emails.empty?
    assert @londoncalling.reload.emails.empty?
  end


  test 'subscribe with absent party' do
    payload = {
      :party => '3',
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 404
    assert @rockwork.reload.emails.empty?
    assert @londoncalling.reload.emails.empty?
  end
end
