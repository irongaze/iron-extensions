# Specialty helper class for building elegant DSLs (domain-specific languages)
# The purpose of the class is to allow seamless DSL's by allowing execution
# of blocks with the instance variables of the calling context preserved, but
# all method calls proxied to a given receiver.  This sounds pretty abstract,
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
# Those calls are automatically proxied to the receiver we passed to the DslProxy.
#
# In quick and dirty DSLs, like Rails' migrations, you end up with a lot of
# pointless receiver declarations for each method call, like so:
#
#   def change
#     create_table do |t|
#       t.integer :counter
#       t.text :title
#       t.text :desc
#       # ... tired of typing "t." yet? ...
#     end
#   end
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
  # be returned.  
  #
  # If the receiver doesn't respond_to? a method, any missing methods
  # will be proxied to the enclosing context.
  def self.exec(receiver, *to_yield, &block) # :yields: receiver
    # Find the context within which the block was defined
    context = ::Kernel.eval('self', block.binding)

    # Create or re-use our proxy object
    if context.respond_to?(:_to_dsl_proxy)
      # If we're nested, we don't want/need a new dsl proxy, just re-use the existing one
      proxy = context._to_dsl_proxy
    else
      # Not nested, create a new proxy for our use
      proxy = DslProxy.new(context)
    end

    # Exec the block and return the result
    proxy._proxy(receiver, *to_yield, &block)
  end
  
  # Simple state setup
  def initialize(context)
    @_receivers = []
    @_instance_original_values = {}
    @_context = context
  end
  
  def _proxy(receiver, *to_yield, &block) # :yields: receiver
    # Sanity!
    raise 'Cannot proxy with a DslProxy as receiver!' if receiver.respond_to?(:_to_dsl_proxy)
    
    if @_receivers.empty?
      # On first proxy call, run each context instance variable, 
      # and set it to ourselves so we can proxy it
      @_context.instance_variables.each do |var|
        unless var.starts_with?('@_')
          value = @_context.instance_variable_get(var.to_s)
          @_instance_original_values[var] = value
          instance_eval "#{var} = value"
        end
      end
    end

    # Save the dsl target as our receiver for proxying
    _push_receiver(receiver)

    # Run the block with ourselves as the new "self", passing the given yieldable(s) or
    # the receiver in case the code wants to disambiguate for some reason
    to_yield = [receiver] if to_yield.empty?
    to_yield = to_yield.first(block.arity)
    result = instance_exec(*to_yield, &block)
    
    # Pop the last receiver off the stack
    _pop_receiver
    
    if @_receivers.empty?
      # Run each local instance variable and re-set it back to the context if it has changed during execution
      #instance_variables.each do |var|
      @_context.instance_variables.each do |var|
        unless var.starts_with?('@_')
          value = instance_eval("#{var}")
          if @_instance_original_values[var] != value
            @_context.instance_variable_set(var.to_s, value)
          end
        end
      end
    end
    
    return result
  end
  
  # For nesting multiple proxies
  def _to_dsl_proxy
    self
  end
  
  # Set the currently active receiver
  def _push_receiver(receiver)
    @_receivers.push receiver
  end
  
  # Remove the currently active receiver, restore old receiver if nested
  def _pop_receiver
    @_receivers.pop
  end

  # Proxies all calls to our receiver, or to the block's context
  # if the receiver doesn't respond_to? it.
  def method_missing(method, *args, &block)
    #$stderr.puts "Method missing: #{method}"
    if @_receivers.last.respond_to?(method)
      #$stderr.puts "Proxy [#{method}] to receiver"
      @_receivers.last.__send__(method, *args, &block)
    else
      #$stderr.puts "Proxy [#{method}] to context"
      @_context.__send__(method, *args, &block)
    end
  end
  
  # Let anyone who's interested know what our proxied objects will accept
  def respond_to?(method, include_private = false)
    return true if method == :_to_dsl_proxy
    @_receivers.last.respond_to?(method, include_private) || @_context.respond_to?(method, include_private)
  end
  
  # Proxies searching for constants to the context, so that eg Kernel::foo can actually
  # find Kernel - BasicObject does not partake in the global scope!
  def self.const_missing(name)
    #$stderr.puts "Constant missing: #{name} - proxy to context"
    @_context.class.const_get(name)
  end
  
end