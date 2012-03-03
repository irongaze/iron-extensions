
Gem::Specification.new do |s|
  # Project attributes
  s.name        = "iron-extensions"
  s.summary     = "Extensions to core classes"
  s.description = "Adds common extensions to core Ruby classes"
  s.homepage    = "https://github.com/irongaze/iron-extensions"

  # Post-install message
  # s.post_install_message = "Thanks for installing!"

  # Additional dependencies
  # s.add_dependency "another", "~> 1.2"

  # Include all gem files that should be packaged
  s.files = Dir[
    "lib/**/*", 
    "bin/*", 
    "spec/**/*", 
    "LICENSE", 
    "*.txt",
    "*.rdoc",
    ".rspec"
  ]
  # Prune out files we don't want to include
  s.files.reject! do |p| 
    ['.tmproj'].detect {|test| p.include?(test)}
  end
  
  # Meta-info
  s.version     = File.read('Version.txt').strip
  s.authors     = ["Rob Morris"]
  s.email       = ["rob@irongaze.com"]
  
  # Boilerplate
  s.platform    = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.executables = Dir["bin/*"].collect {|p| File.basename(p)}
  s.add_development_dependency "rspec", "~> 2.6"
  s.required_ruby_version = '>= 1.9.2'
  s.license     = 'MIT'
end