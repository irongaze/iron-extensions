class Class
  
  def dsl_accessor(*keys)
    keys.each do |key|
      class_eval "def #{key}(val = :__UNDEFINED); @#{key} = val unless val == :__UNDEFINED; @#{key}; end"
      class_eval "def #{key}=(val); @#{key} = val; end"
    end
  end
  
end