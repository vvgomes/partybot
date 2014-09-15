require_relative '../test_helper' 

class GuestTest < ActiveSupport::TestCase
  test '#valid?' do
    assert !Guest.new.valid?
    assert !Guest.new(:name => 'Dude').valid?
    assert !Guest.new(:email => 'dude@gmail.com').valid?
    assert Guest.new(:name => 'Dude', :email => 'dude@gmail.com').valid?
  end

  test '#==' do
    assert Guest.new(:email => 'dude@gmail.com') == Guest.new(:email => 'dude@gmail.com')
    assert Guest.new(:email => 'dude@gmail.com') != Guest.new(:email => 'anotherdude@gmail.com')
  end
end
