require_relative '../test_helper' 

class NightclubBaseTest < ActiveSupport::TestCase
  setup do
    @club = Nightclub::Base.new
    @dude = User.new(:name => 'Dude', :email => 'dude@gmail.com')
    @rockwork, @londoncalling, @fuckrehab = 3.times.map do
      Party.new.tap{ |p| p.stubs(:save); p.stubs(:destroy) }
    end
  end

  test '#sync!' do
    Party.stubs(:all).returns [@rockwork, @londoncalling]
    @club.stubs(:import_parties).returns [@londoncalling, @fuckrehab]
    @rockwork.expects(:destroy)
    @fuckrehab.expects(:save)
    @club.sync!
  end

  test '#subscribe' do
    @club.stubs(:send_subscription).returns 200
    @club.subscribe(@dude, @londoncalling)
    assert @londoncalling.emails.include?('dude@gmail.com')
  end

  test '#subscribe failed' do
    @club.stubs(:send_subscription).returns 500
    @club.subscribe(@dude, @londoncalling)
    assert !@londoncalling.emails.include?('dude@gmail.com')
  end

  test '#bulk_subcribe' do
    Party.stubs(:available).returns [@londoncalling, @fuckrehab]
    @club.expects(:subscribe).with(@dude, @londoncalling)
    @club.expects(:subscribe).with(@dude, @fuckrehab)
    @club.bulk_subscribe(@dude) 
  end
end
