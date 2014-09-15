class Guest
  attr_reader :name, :email

  def initialize(params={})
    @name, @email = params[:name], params[:email]
  end

  def ==(other)
    other.email == self.email
  end

  def valid?
    name && email
  end
end
