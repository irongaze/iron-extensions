require 'stringio'
 
module Kernel
 
  # Captures STDOUT content and returns it as a string
  #
  #   >> capture_stdout do
  #   >>   puts 'Heya'
  #   >> end
  #   => "Heya\n"
  def capture_stdout # :yields:
    out = StringIO.new
    $stdout = out
    yield
    return out.string
  ensure
    $stdout = STDOUT
  end
 
end
