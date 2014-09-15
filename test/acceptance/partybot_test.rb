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
    @p1 = Party.create(:public_id => '1', :emails => ['sis@gmail.com'])
    @p2 = Party.create(:public_id => '2', :emails => ['sis@gmail.com'])
  end

  test 'adds a new guest to all parties' do
    post '/guests', :name => 'bro', :email => 'bro@gmail.com' 
    assert last_response.status == 201
    assert @p1.reload.emails.include? 'bro@gmail.com'
    assert @p2.reload.emails.include? 'bro@gmail.com'
  end

  test 'does not add a new guest twice' do
    post '/guests', :name => 'bro', :email => 'bro@gmail.com' 
    post '/guests', :name => 'bro', :email => 'bro@gmail.com' 
    assert last_response.status == 204
    assert @p1.reload.emails == ['sis@gmail.com', 'bro@gmail.com']
    assert @p2.reload.emails == ['sis@gmail.com', 'bro@gmail.com']
  end

  test 'does not accept a guest without email' do
    post '/guests', :email => 'bro@gmail.com' 
    assert last_response.status == 400
    assert !(@p1.reload.emails.include? 'bro@gmail.com')
    assert !(@p2.reload.emails.include? 'bro@gmail.com')
  end

  test 'does not accept a guest without name' do
    post '/guests', :name => 'bro'
    assert last_response.status == 400
    assert !(@p1.reload.emails.include? 'bro@gmail.com')
    assert !(@p2.reload.emails.include? 'bro@gmail.com')
  end

  test 'retrieves information about all the parties' do
    get '/parties'
    assert last_response.status == 200
    assert last_response.body == 
      '[{"public_id":"1","emails":["sis@gmail.com"]},'+
      '{"public_id":"2","emails":["sis@gmail.com"]}]'
  end
end

