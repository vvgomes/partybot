require_relative '../test_helper' 

class NightclubTest < ActiveSupport::TestCase
  setup do
    @driver = stub
    @club = Nightclub.new(@driver)
    @dude = User.new(:name => 'Dude', :email => 'dude@gmail.com')
    @rockwork, @londoncalling, @fuckrehab = 3.times.map do |id|
      Party.new(public_id: id).tap{ |p| p.stubs(:save); p.stubs(:destroy) }
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
    @driver.stubs(:send_subscription).returns '200'
    output = @club.subscribe(@dude, [@londoncalling, @fuckrehab])
    assert output == {'1' => '200', '2' => '200'}
    assert @londoncalling.emails.include?('dude@gmail.com')
    assert @fuckrehab.emails.include?('dude@gmail.com')
  end

  test '#subscribe failed' do
    @driver.stubs(:send_subscription).with(@dude, @fuckrehab).returns '500'
    @driver.stubs(:send_subscription).with(@dude, @londoncalling).returns '200'
    output = @club.subscribe(@dude, [@londoncalling, @fuckrehab])
    assert output == {'1' => '200', '2' => '500'}
    assert @londoncalling.emails.include?('dude@gmail.com')
    assert !@fuckrehab.emails.include?('dude@gmail.com')
  end
end
