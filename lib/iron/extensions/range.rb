
class Range
  def bound(arg)
    if arg < min
      return min
    elsif arg > max
      return max
    else
      return arg
    end
  end
end

