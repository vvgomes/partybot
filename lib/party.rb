class Party 
  include Mongoid::Document
  include Mongoid::Timestamps

  field :public_id, :type => String
  field :emails, :type => Array, :default => []
  validates :public_id, :presence => true, :uniqueness => true

  def ==(other)
    other.public_id == self.public_id
  end

  def self.sync!
    stored = Party.all
    imported = Party.import
    (stored - imported).map(&:destroy)
    (imported - stored).map(&:save)
  end
end

