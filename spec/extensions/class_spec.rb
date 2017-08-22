describe Class do

  it 'should inspect normally' do
    class Tmp1
      def initialize
        @foo = 'bar'
      end
    end
    Tmp1.new.inspect.match(/#<Tmp1:0x[a-z0-9]+ @foo="bar">/).should be_true
  end

  it 'should inspect only what is requested' do
    class Tmp2
      inspect_only :bar
      def initialize
        @foo = 'bar'
        @bar = 'wingo'
      end
    end
    Tmp2.new.inspect.match(/#<Tmp2:[a-z0-9]+ @bar="wingo">/).should be_true
  end

  it 'should inspect methods if requested' do
    class Tmp3
      inspect_only :baz
      def initialize
        @foo = 'bar'
        @bar = 'wingo'
      end
      def baz
        @bar + 'zzz'
      end
    end
    Tmp3.new.inspect.match(/#<Tmp3:[a-z0-9]+ :baz="wingozzz">/).should be_true
  end

end