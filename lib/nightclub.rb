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
    {}.tap do |results|
      parties.each do |party|
        next if party.emails.include? user.email
        results[party.public_id] = @driver.subscribe(user, party)
        party.tap do |p|
          p.emails << user.email
        end.save if results[party.public_id] == '200'
      end
    end
  end

  class << self
    def current
      @current ||= new(Kernel.const_get(ENV['DRIVER'] || NullDriver.to_s).new)
    end
  end
end
