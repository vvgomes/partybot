require 'mongoid'

class Party 
  include Mongoid::Document
  include Mongoid::Timestamps
  field :external_id, :type => String

  def self.sync
    stored = Party.all
    imported = Party.import
    (stored - imported).map(&:destroy)
    (imported - stored).map(&:save)
  end
end

