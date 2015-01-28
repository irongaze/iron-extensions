class Array
  
  # Join an array's values ignoring blank entries
  def list_join(sep = ', ')
    self.select{|e| !e.blank?}.join(sep)
  end
  
end
