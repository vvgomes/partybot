class Nightclub
  def initialize(driver)
    @driver = driver
  end

  def sync!
    stored = Party.all
    imported = @driver.import_parties
    (stored - imported).map(&:destroy)
    (imported - stored).map(&:save)
  end

  def bulk_subscribe(user)
    Party.available(user).each{ |party| subscribe(user, party) }
  end

  def subscribe(user, party)
    return unless @driver.send_subscription(user, party) == 200
    party.emails << user.email
    party.save
  end

  def self.current
    @@current ||= Nightclub.new(Kernel.const_get(ENV['DRIVER']).new)
  end
end
