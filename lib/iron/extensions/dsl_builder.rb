# Provides a base class for building DSL (domain specific language) builder
# classes, ie classes that define a minimal subset of methods and act as aggregators
# of settings or functionality.  Similar to BasicObject in the standard library, but
# has methods such as respond_to? and send that are required for any real DSL building
# effort.
class DslBuilder < Object
  
  # Remove all methods not explicitly desired
  instance_methods.each do |m|
    keepers = [:inspect, :send]
    undef_method m if m =~ /^[a-z]+[0-9]?$/ && !keepers.include?(m)
  end
  
end