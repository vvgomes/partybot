require_relative '../test_helper' 

class NightclubTest < ActiveSupport::TestCase
  setup do
    @club = Nightclub.new(@driver = stub)
    @dude = User.new(:name => 'Dude', :email => 'dude@gmail.com')
    @rockwork, @londoncalling, @fuckrehab = 3.times.map do |id|
      Party.new(public_id: id).tap do |p|
        p.stubs(:save)
        p.stubs(:destroy)
      end
    end
  end

  test '#sync!' do
    Party.stubs(:all).returns [@rockwork, @londoncalling]
    @driver.stubs(:import_parties).returns [@londoncalling, @fuckrehab]
    @rockwork.expects(:destroy)
    @fuckrehab.expects(:save)
    @club.sync!
  end

  test '#subscribe' do
    @driver.stubs(:subscribe).returns '200'
    @club.subscribe(@dude, [@londoncalling, @fuckrehab])
    assert @londoncalling.emails.include?('dude@gmail.com')
    assert @fuckrehab.emails.include?('dude@gmail.com')
  end

  test '#subscribe twice' do
    @londoncalling.emails << 'dude@gmail.com'
    @driver.expects(:subscribe).never
    @club.subscribe(@dude, [@londoncalling])
  end

  test '#subscribe failed' do
    @driver.stubs(:subscribe).with(@dude, @fuckrehab).returns '500'
    @driver.stubs(:subscribe).with(@dude, @londoncalling).returns '200'
    @club.subscribe(@dude, [@londoncalling, @fuckrehab])
    assert @londoncalling.emails.include?('dude@gmail.com')
    assert !@fuckrehab.emails.include?('dude@gmail.com')
  end

  test '.current defaults to NullDriver' do
    assert Nightclub.current.driver.class == NullDriver
  end
end
