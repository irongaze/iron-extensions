describe Kernel do

  it 'should capture STDOUT text' do
    capture_stdout do
      puts "hello\nworld!"
    end.should == "hello\nworld!\n"
  end
  
  it 'should restore STDOUT correctly on exceptions' do
    old = $stdout
    old.should == STDOUT
    begin
      capture_stdout do
        raise 'foo'
      end
    rescue
    end
    $stdout.should == STDOUT
    $stdout.should == old
  end

end