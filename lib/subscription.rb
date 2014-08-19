class Subscription < Hash
  def failed?(key=nil)
    (key ? [self[key]] : values).find{ |s| s != '200' }
  end
end
