# Load up rspec-specific tasks
require 'rspec/core/rake_task'

# Run specs by default
task :default => 'install'

# Do our rspec thang
desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

# Find and return the name of our latest gem
def latest
  latest = Dir['*.gem'].first
  raise "Can't find gem file!" if latest.nil?
  File.basename(latest)  
end

desc 'Build gem'
task :build => [:test] do
  Dir['*.gem'].each {|p| File.unlink(p) }
  spec = File.basename(Dir['*.gemspec'].first)
  puts ""
  puts "Building #{spec}"
  puts "--------------------"
  puts `gem build #{spec}`
end

desc 'Install (and rebuild) gem'
task :install => [:build] do
  puts ""
  puts "Installing #{latest}"
  puts "--------------------"
  puts `gem install #{latest} --no-rdoc --no-ri`
end

desc 'Test the gem'
task :test do
  puts ""
  puts "Testing gem"
  puts "--------------------"
  Rake::Task['spec'].invoke
  puts "Specs passed!"
end

desc 'Deploy to rubygems.org'
task :deploy => [:build] do
  puts ""
  puts "Deploying #{latest}"
  puts "--------------------"
  puts `gem push #{latest}`
end
