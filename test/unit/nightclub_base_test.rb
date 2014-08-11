require_relative '../test_helper' 

class NightclubBaseTest < ActiveSupport::TestCase
  setup do
    @club = Nightclub::Base.new
    @dude = User.new(:name => 'Dude', :email => 'dude@gmail.com')
    @rockwork, @londoncalling, @fuckrehab = 3.times.map do
      Party.new.tap { |p| p.stubs(:save); p.stubs(:destroy) }
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
    Party.stubs(:available).returns [@londoncalling]
    @club.stubs(:send_subscription).returns true
    @club.subscribe(@dude)
    assert @londoncalling.emails.include? 'dude@gmail.com'
  end

  test '#subscribe when user is invalid' do
    @dude.stubs(:valid?).returns false
    assert_raise(ArgumentError) { @club.subscribe(@dude) }
  end

  test '#subscribe when failed to send the subscription through' do
    Party.stubs(:available).returns [@londoncalling]
    @club.stubs(:send_subscription).returns false
    @club.subscribe(@dude)
    assert @londoncalling.emails.empty?
  end
end
