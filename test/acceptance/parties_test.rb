require_relative '../test_helper' 
require 'rack/test'
require_relative '../../partybot.rb' 

class PartiesTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  setup do
    Party.delete_all 
    Party.create(:public_id => '1', :emails => ['bro@foo.com'])
    Party.create(:public_id => '2', :emails => ['sis@foo.com'])
  end

  test 'all parties' do
    get '/parties'
    assert last_response.status == 200
    assert last_response.body == 
      '[{"public_id":"1","emails":["bro@foo.com"]},'+
      '{"public_id":"2","emails":["sis@foo.com"]}]'
  end

  test 'parties including user' do
    get '/parties', :including => 'bro@foo.com'
    assert last_response.status == 200
    assert last_response.body ==
      '[{"public_id":"1","emails":["bro@foo.com"]}]'
  end

  test 'parties missing user' do
    get '/parties', :missing => 'bro@foo.com'
    assert last_response.status == 200
    assert last_response.body ==
      '[{"public_id":"2","emails":["sis@foo.com"]}]'
  end

  test 'no parties found' do
    get '/parties', :including => 'dude@foo.com'
    assert last_response.status == 404
  end
end
