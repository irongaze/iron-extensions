describe Array do
  
  it 'should join lists ignoring blank entries' do
    ['word', nil, '', 'end'].list_join('-').should == 'word-end'
  end
  
  it 'should handle empty arrays while joining lists' do
    [].list_join.should == ''
  end
  
  it 'should handle list joins with only blank entries' do
    [nil, '', nil].list_join.should == ''
  end
  
end