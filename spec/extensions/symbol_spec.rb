describe Symbol do
  
  it 'should not be blank' do
    :foo.blank?.should be_false
    :"_123".blank?.should be_false
  end
  
  it 'should convert to dashcase' do
    :my_symbol.to_dashcase.should == 'my-symbol'
  end
  
end