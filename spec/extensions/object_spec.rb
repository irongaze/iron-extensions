describe Object do

  it 'should respond to in?' do
    1.in?([1,2,3]).should == true
    5.in?([1,2,3]).should == false
    "foo".in?(nil).should == false
    :b.in?([:a, :b, :c]).should == true
  end

  it 'should not be blank' do
    Object.new.should_not be_blank
  end

end