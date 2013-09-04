module Math
  
  def self.min(a,b)
    a <= b ? a : b
  end

  def self.max(a,b)
    a >= b ? a : b
  end

  def self.scale_to_fit(w,h,max_w,max_h)
    ratio = max_w.to_f / max_h.to_f
    nw, nh = w, h
    cur_ratio = nw.to_f / nh.to_f

    if cur_ratio >= ratio
      nw = max_w
      nh = max_w / cur_ratio
    else
      nh = max_h
      nw = max_h * cur_ratio
    end

    return nw.to_i, nh.to_i
  end

end
