class Symbol

  # Provide helper for nil/"" blankness checker
  def blank?
    false
  end

  def to_dashcase
    self.to_s.to_dashcase
  end

  unless :test.respond_to?(:starts_with?)
    def starts_with?(str)
      self.to_s.starts_with?(str)
    end

    def ends_with?(str)
      self.to_s.ends_with?(str)
    end
  end

end