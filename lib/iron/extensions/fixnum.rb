class Fixnum
  
  # Adapted from Rails' NumberHelper view helper
  def to_human_size(precision=1)
    size = Kernel.Float(self)
    case
    when size.to_i == 1 then
      "1 Byte"
    when size < 1024 then
      "#{size.to_i} Bytes"
    when size < 1024*1024 then
      "#{(size / 1024).to_display(precision)} KB"
    when size < 1024*1024*1024 then
      "#{(size / (1024*1024)).to_display(precision)} MB"
    when size < 1024*1024*1024*1024 then
      "#{(size / (1024*1024*1024)).to_display(precision)} GB"
    else
      "#{(size / (1024*1024*1024*1024)).to_display(precision)} TB"
    end
  rescue
    nil
  end
  
  def blank?
    false
  end
  
end
