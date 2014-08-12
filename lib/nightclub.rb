module Nightclub
  class Base
    def sync!
      stored = Party.all
      imported = import_parties
      (stored - imported).map(&:destroy)
      (imported - stored).map(&:save)
    end

    def bulk_subscribe(user)
      raise ArgumentError unless user.valid?
      Party.available(user).each{ |party| subscribe(user, party) }
    end

    def subscribe(user, party)
      return unless send_subscription(user, party) == 200
      party.emails << user.email
      party.save
    end

    private

    def import_parties
      raise NotImplementedError
    end

    def send_subscription(user, party)
      raise NotImplementedError
    end
  end
end
