# Specialty helper class for building elegant DSLs (domain-specific languages)
# The purpose of the class is to allow seamless DSL's by allowing execution
# of blocks with the instance variables of the calling context preserved, but
# all method calls be proxied to a given receiver.  This sounds pretty abstract,
# so here's an example:
# 
#   class ControlBuilder
#     def initialize; @controls = []; end
#     def control_list; @controls; end
#     def knob; @controls << :knob; end
#     def button; @controls << :button; end
#     def switch; @controls << :switch; end
#     def self.define(&block)
#       @builder = self.new
#       DslProxy.exec(@builder, &block)
#       # Do something here with the builder's list of controls
#       @builder.control_list
#     end
#   end
#
#   @knob_count = 5
#   new_list = ControlBuilder.define do
#     switch
#     @knob_count.times { knob }
#     button
#   end
#
# Notice the lack of explicit builder receiver to the calls to #switch, #knob and #button.
# Those calls are automatically proxied to the @builder we passed to the DslProxy.
#
# In quick and dirty DSLs, like Rails' migrations, you end up with a lot of
# pointless receiver declarations for each method call, like so:
#
# def change
#   create_table do |t|
#     t.integer :counter
#     t.text :title
#     t.text :desc
#     # ... tired of typing "t." yet? ...
#   end
# end
#
# This is not a big deal if you're using a simple DSL, but when you have multiple nested
# builders going on at once, it is ugly, pointless, and can cause bugs when
# the throwaway arg names you choose (eg 't' above) overlap in scope.
# 
# In addition, simply using a yield statment loses the instance variables set in the calling
# context.  This is a major pain in eg Rails views, where most of the interesting
# data resides in instance variables.  You can get around this when #yield-ing by
# explicitly creating a local variable to be picked up by the closure created in the
# block, but it kind of sucks.
# 
# In summary, DslProxy allows you to keep all the local and instance variable context
# from your block declarations, while proxying all method calls to a given
# receiver.  If you're not building DSLs, this class is not for you, but if you are,
# I hope it helps!
class DslProxy < BasicObject
  
  # Pass in a builder-style class, or other receiver you want set as "self" within the
  # block, and off you go.  The passed block will be executed with all
  # block-context local and instance variables available, but with all
  # method calls sent to the receiver you pass in.  The block's result will
  # be returned.  If the receiver doesn't
  def self.exec(receiver, &block) # :yields: receiver
    proxy = DslProxy.new(receiver, &block)
    return proxy._result
  end
  
  # Create a new proxy and execute the passed block
  def initialize(builder, &block) # :yields: receiver
    # Save the dsl target as our receiver for proxying
    @_receiver = builder

    # Find the context within which the block was defined
    @_context = ::Kernel.eval('self', block.binding)
    # Run each instance variable, and set it to ourselves so we can proxy it
    @_context.instance_variables.each do |var|
      value = @_context.instance_variable_get(var.to_s)
      instance_eval "#{var} = value"
    end
    
    # Run the block with ourselves as the new "self", passing the receiver in case
    # the code wants to disambiguate for some reason
    @_result = instance_exec(@_receiver, &block)
    
    # Run each instance variable, and set it to ourselves so we can proxy it
    @_context.instance_variables.each do |var|
      @_context.instance_variable_set(var.to_s, instance_eval("#{var}"))
    end
  end
  
  # Returns value of the exec'd block
  def _result
    @_result
  end

  # Proxies all calls to our receiver, or to the block's context
  # if the receiver doesn't respond_to? it.
  def method_missing(method, *args, &block)
    if @_receiver.respond_to?(method)
      @_receiver.send(method, *args, &block)
    else
      @_context.send(method, *args, &block)
    end
  end
  
  # Proxies searching for constants to the context
  def self.const_missing(name)
    @_context.class.const_get(name)
  end
  
end