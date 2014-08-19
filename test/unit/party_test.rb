require_relative '../test_helper' 

class PartyTest < ActiveSupport::TestCase
  test '#valid?' do
    assert !Party.new.valid?
    assert Party.new(:public_id => '99').valid?
  end

  test '#==' do
    assert Party.new(:public_id => '99') == Party.new(:public_id => '99')
    assert Party.new(:public_id => '99') != Party.new(:public_id => '98')
  end

  test '#emails' do
    assert Party.new.emails.empty?
  end

  test '#to_h' do
    emails = ['dude@gmail.com', 'bro@gmail.com']
    party = Party.new(:public_id => '99', :emails => emails)
    assert party.to_h == {'99' => ['dude@gmail.com','bro@gmail.com']}
  end
end
