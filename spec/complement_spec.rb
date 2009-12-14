require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Complement" do # :nodoc:
  
  describe "square" do
    it do
      x = UndirectedGraph[:a,:b, :b,:c, :c,:d, :d,:a].complement
      x.edges.size.should == 2
      x.edges.include?(Edge[:a,:c]).should be_true
      x.edges.include?(Edge[:b,:d]).should be_true
    end
  end
  
  describe "g1" do
    it do
      g1 = UndirectedGraph[ :a,:b, :a,:d, :a,:e, :a,:i, :a,:g, :a,:h,
                            :b,:c, :b,:f,
                            :c,:d, :c,:h,
                            :d,:h, :d,:e,
                            :e,:f,
                            :f,:g, :f,:h, :f,:i,
                            :h,:i ].complement
      g1.edges.size.should == 19
    end
  end

end
