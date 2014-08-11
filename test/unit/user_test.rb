require_relative '../test_helper' 

class UserTest < ActiveSupport::TestCase
  test '#valid?' do
    assert !User.new({}).valid?
    assert !User.new(:name => 'Dude').valid?
    assert !User.new(:email => 'dude@gmail.com').valid?
    assert User.new(:name => 'Dude', :email => 'dude@gmail.com').valid?
  end

  test '#==' do
    assert User.new(:email => 'dude@gmail.com') == User.new(:email => 'dude@gmail.com')
    assert User.new(:email => 'dude@gmail.com') != User.new(:email => 'anotherdude@gmail.com')
  end
end
