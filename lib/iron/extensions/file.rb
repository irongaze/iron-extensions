require 'fileutils'

class File

  # Atomic replace code - write to temp file, rename to source file path only after
  # successful completion of block.  Prevents partial writes from overwriting files.
  #
  # Usage:
  #
  # File.safe_replace('/etc/foo.conf') do |file|
  #   file.write('bob=1234')
  # end
  def self.safe_replace(path, perm = nil) # :yields: file
    begin
      tmp_path = path + '.tmp' + Kernel.rand(999999).to_s
    end while File.exist?(tmp_path)

    file = File.open(tmp_path, 'w', perm)
    yield file
    file.close

    FileUtils.mv(tmp_path, path)
  ensure
    # Close file if needed
    file.close unless file.closed?
    
    # Clean up temp file
    File.unlink(tmp_path) if File.exists?(tmp_path)
  end

end

