# Require our library
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'iron', 'extensions'))

# Config RSpec options
RSpec.configure do |config|
  config.color = true
  config.add_formatter 'documentation'
  config.backtrace_clean_patterns = [/rspec/]
end


