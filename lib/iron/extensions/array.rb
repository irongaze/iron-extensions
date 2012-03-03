
class Array
  unless [].respond_to?(:shuffle)
    def shuffle
      sort_by { Kernel.rand }
    end

    def shuffle!
      self.replace shuffle
    end
  end

  def rand(count = 1)
    shuffle[0...count]
  end

  def rand!(count = 1)
    self.replace rand(count)
  end

  def list_join(sep = ', ')
    self.select{|e| !e.blank?}.join(sep)
  end
end
