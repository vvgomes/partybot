require_relative '../test_helper' 

class UserTest < ActiveSupport::TestCase
  test '#valid?' do
    assert !User.new.valid?
    assert !User.new('Dude').valid?
    assert !User.new(nil, 'dude@gmail.com').valid?
    assert User.new('Dude', 'dude@gmail.com').valid?
  end

  test '#==' do
    assert User.new(nil, 'dude@gmail.com') == User.new(nil, 'dude@gmail.com')
    assert User.new(nil, 'dude@gmail.com') != User.new(nil, 'anotherdude@gmail.com')
  end
end
