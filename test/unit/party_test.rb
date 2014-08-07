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

  test '#emails is empty by default' do
    assert Party.new.emails.empty?
  end

  test '.sync!' do
    neon, rehab, rockwork = 3.times.map do
      stub(:save => nil, :destroy => nil)
    end
    Party.stubs(:all).returns [neon, rehab]
    Party.stubs(:import).returns [rehab, rockwork]
    neon.expects(:destroy)
    rockwork.expects(:save)
    Party.sync!
  end
end
