require File.join(File.dirname(__FILE__), 'spec_helper')

describe "ChinesePostman" do # :nodoc:

  before do  
    @simple=Digraph[ 0,1,  0,2,  1,2,  1,3,  2,3,  3,0 ]
    @weight = Proc.new {|e| 1}
  end
  
  describe "closed_simple_tour" do
    it do
      tour = @simple.closed_chinese_postman_tour(0, @weight)
      tour.size.should == 11
      tour[0].should == 0
      tour[10].should == 0
      edges = Set.new
      0.upto(9) do |n| 
        edges << Arc[tour[n],tour[n+1]]
        @simple.edge?(tour[n],tour[n+1]).should be_true
      end
      edges.size.should == @simple.edges.size
    end
    
  end
  
  
end
