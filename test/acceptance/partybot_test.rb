require_relative '../test_helper' 
require 'rack/test'
require_relative '../../partybot.rb' 

class PartybotTest < ActiveSupport::TestCase
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

  test 'POST /subscriptions (happy path)' do
    payload = {
      :user => {
        :name => 'Dude',
        :email => 'dude@gmail.com'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 201
    assert @rockwork.reload.emails.include? 'dude@gmail.com'
    assert @londoncalling.reload.emails.include? 'dude@gmail.com'
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
    assert @rockwork.reload.emails.include? 'dude@gmail.com'
    assert @londoncalling.reload.emails.empty?
  end

  test 'POST /subscriptions (with no user)' do
    payload = { :party => '1' }
    post '/subscriptions', payload 
    assert last_response.status == 400
    assert @rockwork.reload.emails.empty?
    assert @londoncalling.reload.emails.empty?
  end

  test 'POST /subscriptions (with bad user)' do
    payload = {
      :user => {
        :name => 'Dude'
      }
    }
    post '/subscriptions', payload 
    assert last_response.status == 400
    assert @rockwork.reload.emails.empty?
    assert @londoncalling.reload.emails.empty?
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
    assert @rockwork.reload.emails.empty?
    assert @londoncalling.reload.emails.empty?
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
