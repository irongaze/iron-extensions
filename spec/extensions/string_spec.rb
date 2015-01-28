
describe String do

  describe 'when extracting' do 
    it 'should respond to extract' do
      "test".should respond_to(:extract)
    end

    it 'should return nil if extract fails to match' do
      'test'.extract(/nossir/).should be_nil
    end

    it 'should extract a single value if the whole regex matches' do
      res = 'test'.extract(/est/)
      res.should be_a(String)
      res.should == 'est'
    end

    it 'should extract a single value correctly if a capture is specified' do
      res = 'test'.extract(/e(s)t/)
      res.should be_a(String)
      res.should == 's'
    end

    it 'should extract multiple values if more than one capture is specified' do
      res = 'a great big number 10!'.extract(/(great).*(number).*([0-9]{2})/)
      res.should be_an(Array)
      res.should == ['great', 'number', '10']
    end

    it 'should extract nil for missing captures' do 
      a, b, c = 'a great big numero 10!'.extract(/(great).*(number)?.*([0-9]{2})/)
      a.should == 'great'
      b.should be_nil
      c.should == '10'
    end
  end
  
  it 'should convert to a date correctly' do
    {
      '' => nil,
      '13/1/2010' => nil,
      '12/4/73' => Date.new(1973,12,4),
      '12/4/1973' => Date.new(1973,12,4),
      '12-31-10' => Date.new(2010,12,31),
      '2025-01-04' => Date.new(2025,1,4)
    }.each_pair do |str, date|
      str.to_date.should == date
    end
  end

  it 'should respond to ends_with?' do 
    'bob'.should respond_to(:ends_with?)
  end

  it 'should correctly determine if it ends with a passed string' do
    'bob'.ends_with?('ob').should be_true
    'bob'.ends_with?('o').should_not be_true
  end

  it 'should be convertable to dashcase' do
    "Rob's greatest hits!".to_dashcase.should == 'robs-greatest-hits'
  end

  it 'should truncate intelligently' do
    "A great big string o' doom!".smart_truncate(15).should == 'A great big...'
    "Agreatbigstringodoom!".smart_truncate(15).should == 'Agreatbigstri...'
  end

  it 'should constantize correctly' do
    'Object'.constantize.should equal(Object)
  end

  it 'should constantize modules' do
    'Enumerable'.constantize.should equal(Enumerable)
  end

  it 'should support natural ordering' do
    ['a0', 'a90', 'a10', 'a9'].sort_by {|a| a.natural_order}.should == ['a0', 'a9', 'a10', 'a90']
  end
  
  it 'should be appropriately blank' do
    [nil, '', '  ', "\t", "\n"].each do |test|
      test.should be_blank
    end
  end

end
