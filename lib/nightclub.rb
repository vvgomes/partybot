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
    parties.reduce({}) do |out, party|
      status = @driver.send_subscription(user, party)
      party.tap{ |p| p.emails << user.email }.save if status == '200'
      out[party.public_id] = status; out
    end
  end

  def self.current
    @@current ||= Nightclub.new(Kernel.const_get(ENV['DRIVER']).new)
  end
end
