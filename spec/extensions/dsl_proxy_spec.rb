describe DslProxy do

  # Sample DSL builder class for use in testing
  class ControlBuilder
    def initialize; @controls = []; end
    def controls; @controls; end
    def knob; @controls << :knob; end
    def button; @controls << :button; end
    def switch; @controls << :switch; end

    def self.define(&block)
      @builder = self.new
      DslProxy.exec(@builder, &block)
      @builder.controls
    end
  end
  
  it 'should proxy calls to the receiver' do
    receiver = Object.new
    DslProxy.exec(receiver) do
      self.class.name.should == 'Object'
    end
  end
  
  it 'should proxy respond_to? to the receiver' do
    receiver = Object.new
    DslProxy.exec(receiver) do
      respond_to?(:garbaz).should == false
      respond_to?(:dup).should == true
    end
  end
  
  it 'should proxy local variables from the binding context' do
    @foo = 'bar'
    DslProxy.exec(Object.new) do
      @foo.should == 'bar'
    end
  end

  it 'should propagate local variable changes back to the binding context' do
    @foo = 'bar'
    DslProxy.exec(Object.new) do
      @foo = 'no bar!'
    end
    @foo.should == 'no bar!'
  end
  
  it 'should proxy missing methods on the receiver to the context' do
    class TestContext
      def bar
        'something'
      end
      
      def test
        DslProxy.exec(Object.new) do
          bar
        end
      end
    end
    
    TestContext.new.test.should == 'something'
  end

  it 'should return the result of the block' do
    res = DslProxy.exec(Object.new) do
      'foo'
    end
    res.should == 'foo'
  end

  it 'should allow access to global constants' do
    DslProxy.exec(self) do # Use self here, so #be_a is defined.  :-)
      Object.new.should be_a(Object)
    end
  end
  
  it 'should put it all together' do
    @knob_count = 5
    controls = ControlBuilder.define do
      switch
      @knob_count.times { knob }
    end
    controls.count.should == 6
  end
  
end