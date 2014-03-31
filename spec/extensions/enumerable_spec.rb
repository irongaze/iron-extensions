
describe Enumerable do

  it 'should convert to a hash' do
    [1,2,3].convert_to_hash.should == {1 => nil, 2 => nil, 3 => nil}
  end
  
  it 'should accept a default hash value' do
    [:a, :b].convert_to_hash(false).should == {:a => false, :b => false}
  end
  
  it 'should duplicate default hash values' do
    h = [1,2,3].convert_to_hash({})
    h[1][:foo] = 5
    h[2][:foo].should be_nil
  end
  
  it 'should accept a block to set hash values' do
    [:a, :b, :c].convert_to_hash {|k| k.to_s.upcase}.should == {:a => 'A', :b => 'B', :c => 'C'}
  end
  
  it 'should delete_unless' do
    a = [1,2,3,9,22]
    a.delete_unless(&:odd?)
    a.should == [1,3,9]
  end
  
  it 'should delete_unless when a hash' do
    h = {:a => 2, :b => 5, :c => 12}
    h.delete_unless {|k, v| v == 12}
    h.should == {:c => 12}
  end

end