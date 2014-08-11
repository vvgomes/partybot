User = Struct.new(:name, :email) do
  def ==(other)
    other.email == self.email
  end

  def valid?
    name && email
  end
end
