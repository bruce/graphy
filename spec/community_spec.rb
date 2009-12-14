require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Community" do # :nodoc:
  before do
    @graph = Digraph[2,1, 3,1, 5,4, 6,5, 7,6, 7,2].add_vertex!(8)
  end
  
  describe "ancestors_must_return_ancestors" do
    it do
      @graph.ancestors(1).sort.should == [2,3,7]
      @graph.ancestors(2).sort.should == [7]
      @graph.ancestors(3).sort.should == []
      @graph.ancestors(4).sort.should == [5,6,7]
      @graph.ancestors(5).sort.should == [6,7]
      @graph.ancestors(6).sort.should == [7]
      @graph.ancestors(7).sort.should == []
    end
  end
  
  describe "descendants_must_return_descendants" do
    it do
      @graph.descendants(1).sort.should == []
      @graph.descendants(2).sort.should == [1]
      @graph.descendants(3).sort.should == [1]
      @graph.descendants(4).sort.should == []
      @graph.descendants(5).sort.should == [4]
      @graph.descendants(6).sort.should == [4,5]
      @graph.descendants(7).sort.should == [1,2,4,5,6]
    end
  end
  
  describe "family_must_return_family" do
    it do
      @graph.family(1).sort.should == [2,3,4,5,6,7]
      @graph.family(2).sort.should == [1,3,4,5,6,7]
      @graph.family(3).sort.should == [1,2,4,5,6,7]
      @graph.family(4).sort.should == [1,2,3,5,6,7]
      @graph.family(5).sort.should == [1,2,3,4,6,7]
      @graph.family(6).sort.should == [1,2,3,4,5,7]
      @graph.family(7).sort.should == [1,2,3,4,5,6]
    end
  end
  
end
