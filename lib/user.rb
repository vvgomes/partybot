class User
  attr_reader :name, :email

  def initialize(params)
    @name = params[:name]
    @email = params[:email]
  end

  def ==(other)
    other.email == self.email
  end

  def valid?
    name && email
  end
end
