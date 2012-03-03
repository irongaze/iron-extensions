describe Numeric do

  it 'should display correctly no matter the base type' do
    100.to_display(2).should == '100'
    100.0.to_display(2).should == '100.00'
    12345.to_display.should == '12,345'
    123450000066666234234.should be_an_instance_of(Bignum)
    123450000066666234234.to_display.should == '123,450,000,066,666,234,234'
    0.0004.to_display
  end
  
  it 'should display correctly when negative' do
    -5.to_display.should == '-5'
    -42333.194.to_display(1).should == '-42,333.1'
  end
  
  it 'should bound itself' do
    1.bound(2,5).should == 2
    5.bound(2,5).should == 5
    2.bound(2,5).should == 2
    -1000.bound(-5,5).should == -5
    555.bound(-1,0).should == 0
  end

end