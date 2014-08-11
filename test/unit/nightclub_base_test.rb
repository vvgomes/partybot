require_relative '../test_helper' 

class NightclubBaseTest < ActiveSupport::TestCase
  setup { @club = Nightclub::Base.new }

  test '#sync!' do
    neon, rehab, rockwork = 3.times.map{ Party.new }
    Party.stubs(:all).returns [neon, rehab]
    @club.stubs(:import_parties).returns [rehab, rockwork]
    neon.expects(:destroy)
    rockwork.expects(:save)
    @club.sync!
  end

  test '#subscribe' do
    user, party = 2.times.map { stub }
    assert_raise(NotImplementedError) { @club.subscribe(user, party) }
  end
end
