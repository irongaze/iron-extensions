module Enumerable
  
  # Converts an enumerable into a hash, by accepting an initial value
  # or a block to compute the value for a given key.
  def convert_to_hash(init_val = nil)
    hash = {}
    self.each do |key|
      hash[key] = block_given? ? yield(key) : (init_val.dup rescue init_val)
    end
    hash
  end
  
  # Inverse of delete_if, to be more Ruby-ish in cases where you want negated
  # tests.
  def delete_unless(&block)
    delete_if {|*args| !block.call(*args)}
  end
  
  def blank?
    empty?
  end
  
end