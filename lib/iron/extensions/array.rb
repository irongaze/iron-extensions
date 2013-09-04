class Array
  
  # DEPRECATED: as of Ruby 1.9, you should use Array#sample instead
  def rand(count = 1)
    warn("[DEPRECATION] Array#rand is deprecated - use Array#sample instead")
    shuffle[0...count]
  end

  # DEPRECATED: as of Ruby 1.9, you should use Array#sample instead
  def rand!(count = 1)
    warn("[DEPRECATION] Array#rand is deprecated - use Array#sample instead")
    self.replace rand(count)
  end

  # Join an array's values ignoring blank entries
  def list_join(sep = ', ')
    self.select{|e| !e.blank?}.join(sep)
  end
  
end
