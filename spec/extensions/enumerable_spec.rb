
describe Enumerable do

  it 'should convert to a hash' do
    [1,2,3].convert_to_hash.should == {1 => nil, 2 => nil, 3 => nil}
  end
  
  it 'should accept a default value' do
    [:a, :b].convert_to_hash(false).should == {:a => false, :b => false}
  end
  
  it 'should accept a block to set hash values' do
    [:a, :b, :c].convert_to_hash {|k| k.to_s.upcase}.should == {:a => 'A', :b => 'B', :c => 'C'}
  end

end