class Party 
  include Mongoid::Document
  include Mongoid::Timestamps

  field :public_id, :type => String
  field :emails, :type => Array, :default => []
  validates :public_id, :presence => true, :uniqueness => true

  def ==(other)
    other.public_id == self.public_id
  end

  def to_h
    { :public_id => public_id }
  end

  def self.for(guest)
    not_in(:emails => guest.email)
  end
end

