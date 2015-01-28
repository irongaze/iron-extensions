class Object
  
  def in?(enum)
    return false unless enum.respond_to?(:include?)
    enum.include?(self)
  end
  
  def blank?
    false
  end
  
end