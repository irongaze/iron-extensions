class Object
  
  def in?(enum)
    return false unless enum.respond_to?(:include?)
    enum.include?(self)
  end
  
end