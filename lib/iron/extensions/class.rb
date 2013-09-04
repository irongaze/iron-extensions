class Class
  
  # Provides a DSL-friendly way to set values.  Similar to attr_accessor, but
  # supports setting values like so:
  #
  #   class Widget
  #     dsl_accessor :size
  #   end
  #   @w = Widget.new
  #   @w.size = 5  # normal setter, same as...
  #   @w.size 5    # note the lack of explicit = sign
  #   puts @w.size # still get reader access
  #
  # Useful in DslProxy blocks:
  #
  #   DslProxy.exec(Widget.new) do
  #     size 10    # sets size to 10, as expected
  #     size = 10  # fails, creates local variable 'size' instead of invoking Widget#size
  #   end
  #
  def dsl_accessor(*keys)
    keys.each do |key|
      class_eval "def #{key}(val = :__UNDEFINED); @#{key} = val unless val == :__UNDEFINED; @#{key}; end"
      class_eval "def #{key}=(val); @#{key} = val; end"
    end
  end
  
  # Like #dsl_accessor, but adds imperative and query versions of the keys as well to set the
  # flag to true and to query the true-ness of the flag.
  #
  #   class Widget
  #     dsl_flag :heavy
  #   end
  #   @w = Widget.new
  #   @w.heavy?  # => false
  #   @w.heavy!  # now is true
  #
  def dsl_flag(*keys)
    dsl_accessor(*keys)
    keys.each do |key|
      class_eval "def #{key}!; @#{key} = true; end"
      class_eval "def #{key}?; @#{key} === true; end"
    end
  end
  
end