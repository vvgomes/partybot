require_relative '../test_helper' 

class DriversTest < ActiveSupport::TestCase
  test 'beco driver can import parties' do
    assert !(Beco.new.import_parties.empty?)
  end

  test 'cucko driver can import parties' do
    assert !(Cucko.new.import_parties.empty?)
  end

  test 'lab driver can import parties' do
    assert !(Lab.new.import_parties.empty?)
  end
end
