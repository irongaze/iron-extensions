# Requires all classes
search_path = File.join(File.expand_path(File.dirname(__FILE__)), '*', '*.rb')
Dir.glob(search_path) do |path|
  require path
end
