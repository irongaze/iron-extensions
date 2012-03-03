class Symbol

  # Provide helper for nil/"" blankness checker
  def blank?
    false
  end

  def to_dashcase
    self.to_s.to_dashcase
  end

end