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

  def subscribe(guest, parties)
    parties.each do |party|
      next if party.emails.include? guest.email
      response = @driver.subscribe(guest, party)
      party.tap do |p|
        p.emails << guest.email
      end.save if response == '200'
    end
  end

  class << self
    def current
      @current ||= new(Kernel.const_get(ENV['DRIVER'] || NullDriver.to_s).new)
    end
  end
end
