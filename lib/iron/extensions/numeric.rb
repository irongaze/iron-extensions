
class Numeric

  # Returns self, bounded to min/max values
  def bound(min, max)
    min, max = max, min if max < min
    return min if min > self
    return max if max < self
    self
  end

  def to_display(decimal_count = nil, include_thousands = true)
    res = ''
    decimal = self.to_s.extract(/\.([0-9]+)/)
    unless decimal.nil? || decimal_count.nil?
      decimal = decimal[0...decimal_count].ljust(decimal_count,'0')
    end
    val = self.to_i.abs
    if include_thousands
      while val > 999
        res.prepend(',' + (val % 1000).to_s.rjust(3,'0'))
        val /= 1000
      end
    end
    res.prepend(val.to_s) if val > 0 || res.empty?
    res = '-' + res if self < 0
    res = res + '.' + decimal unless decimal.blank?
    res
  end
  
end