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

  def subscribe(user, parties)
    parties.each do |party|
      next unless @driver.send_subscription(user, party) == '200'
      party.tap{ |p| p.emails << user.email }.save
    end
  end

  def self.current
    @@current ||= Nightclub.new(Kernel.const_get(ENV['DRIVER']).new)
  end
end
