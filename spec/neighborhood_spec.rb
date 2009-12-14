require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Neighborhood" do # :nodoc:
  
  before do
    @d = Digraph[:a,:b, :a,:f,
                 :b,:g,
                 :c,:b, :c,:g,
                 :d,:c, :d,:g,
                 :e,:d,
                 :f,:e, :f,:g,
                 :g,:a, :g,:e]
    @w = [:a,:b]
  end
  
  describe "open_out_neighborhood" do
    it do
      @d.set_neighborhood([:a],    :in).should == [:g]
      ([:f,:g]  - @d.set_neighborhood(@w, :out)).should == []
      (@w       - @d.open_pth_neighborhood(@w, 0, :out)).should == []
      ([:f, :g] - @d.open_pth_neighborhood(@w, 1, :out)).should == []
      ([:e]     - @d.open_pth_neighborhood(@w, 2, :out)).should == []
      ([:d]     - @d.open_pth_neighborhood(@w, 3, :out)).should == []
      ([:c]     - @d.open_pth_neighborhood(@w, 4, :out)).should == []
    end
  end
  
  describe "closed_out_neighborhood" do
    it do
      (@w                     - @d.closed_pth_neighborhood(@w, 0, :out)).should == []
      ([:a,:b,:f,:g]          - @d.closed_pth_neighborhood(@w, 1, :out)).should == []
      ([:a,:b,:e,:f,:g]       - @d.closed_pth_neighborhood(@w, 2, :out)).should == []
      ([:a,:b,:d,:e,:f,:g]    - @d.closed_pth_neighborhood(@w, 3, :out)).should == []
      ([:a,:b,:c,:d,:e,:f,:g] - @d.closed_pth_neighborhood(@w, 4, :out)).should == []
    end
  end
  
end
