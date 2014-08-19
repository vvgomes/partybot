require_relative '../test_helper' 

class DriversTest < ActiveSupport::TestCase
  test 'beco driver can import more than one party' do
    assert Beco.new.import_parties.size > 1
  end

  test 'cucko driver can import more than one party' do
    assert Cucko.new.import_parties.size > 1
  end

  test 'lab driver can import more than one party' do
    assert Lab.new.import_parties.size > 1
  end
end
