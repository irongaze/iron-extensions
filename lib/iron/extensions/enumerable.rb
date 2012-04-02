module Enumerable
  
  # Converts an enumerable into a hash, by accepting an initial value
  # or a block to compute the value for a given key.
  def convert_to_hash(init_val = nil)
    hash = {}
    self.each do |key|
      hash[key] = block_given? ? yield(key) : init_val
    end
    hash
  end
  
end