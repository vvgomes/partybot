require_relative '../test_helper' 

class BecoTest < ActiveSupport::TestCase
  test 'beco driver can import more than one party' do
    assert Beco.new.import_parties.size > 1
  end
end
