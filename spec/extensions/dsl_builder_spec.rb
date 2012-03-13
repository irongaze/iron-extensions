describe DslBuilder do

  it 'should allow creating DSL-style accessors' do
    class MyBuilder < DslBuilder
      dsl_accessor :name
    end
    builder = MyBuilder.new

    # Test standalone
    builder.name 'ProjectX'
    builder.name.should == 'ProjectX'
    
    # Test as part of DslProxy usage (common case)
    DslProxy.exec(builder) do
      name 'Project Omega'
    end
    builder.name.should == 'Project Omega'
  end
  
end