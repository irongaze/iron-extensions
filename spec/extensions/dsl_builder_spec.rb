describe DslBuilder do

  # TODO: break this out a bit...
  it 'should allow using DSL-style accessors' do
    class MyBuilder < DslBuilder
      dsl_accessor :name
      dsl_flag :flagged
    end
    builder = MyBuilder.new

    # Test standalone
    builder.name 'ProjectX'
    builder.name.should == 'ProjectX'
    
    builder.flagged?.should be_false
    builder.flagged = true
    builder.flagged?.should be_true
    builder.flagged = false
    
    # Test as part of DslProxy usage (common case)
    DslProxy.exec(builder) do
      name 'Project Omega'
      flagged!
    end
    builder.name.should == 'Project Omega'
    builder.flagged?.should be_true
  end
  
end