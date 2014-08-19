class Nightclub
  attr_reader :driver

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
    Subscription.new.tap do |subs|
      parties.each do |party|
        subs[party.public_id] = @driver.send_subscription(user, party)
        party.tap do |p|
          p.emails << user.email
        end.save unless subs.failed?(party.public_id)
      end
    end
  end

  class << self
    def current
      @current ||= new(Kernel.const_get(ENV['DRIVER']).new)
    end
  end
end
