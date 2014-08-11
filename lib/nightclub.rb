module Nightclub
  class Base
    def sync!
      stored = Party.all
      imported = import_parties
      (stored - imported).map(&:destroy)
      (imported - stored).map(&:save)
    end

    def subscribe(user)
      raise ArgumentError unless user.valid?
      Party.available(user).each do |party|
        send_subscription(user, party) || next
        party.emails << user.email
        party.save
      end
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
