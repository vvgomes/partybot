class DummyDriver
  def import_parties
    ['foo', 'bar'].map{ |id| Party.new(:public_id => id) }
  end

  def send_subscription(user, party)
    200
  end
end
