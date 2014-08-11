module Nightclub
  class Base
    def sync!
      stored = Party.all
      imported = import_parties
      (stored - imported).map(&:destroy)
      (imported - stored).map(&:save)
    end
  end
end
