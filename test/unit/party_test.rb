require_relative '../test_helper' 
require 'party'

class PartyTest < ActiveSupport::TestCase
  setup do
    @neon, @rehab, @rockwork = 3.times.map do
      stub(:save => nil, :destroy => nil)
    end
    Party.stubs(:all).returns [@neon, @rehab]
    Party.stubs(:import).returns [@rehab, @rockwork]
  end

  test '.sync removes expired parties' do
    @neon.expects(:destroy)
    Party.sync
  end

  test '.sync adds new parties' do
    @rockwork.expects(:save)
    Party.sync
  end
end
