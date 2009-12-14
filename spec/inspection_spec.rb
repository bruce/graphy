require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Inspection" do # :nodoc:
  
  before do
    @dg = DirectedMultiGraph[ 
                             [0,0,1]   => 1,
                             [1,2,2]   => 2, 
                             [1,3,3]   => 4,
                             [1,4,4]   => nil, 
                             [4,1,5]   => 8, 
                             [1,2,6]   => 16, 
                             [3,3,7]   => 32, 
                             [3,3,8]   => 64     ]
    @dg[3] = 128
    @dg[0] = 256
  end
  
  describe "inspection_without_labels" do
    it do
      @dg = Digraph[1,2,3,4,5,6]
      reflect = eval @dg.inspect
      reflect.should == @dg
    end
  end
  
  describe "inspection_with_labels" do
    it do
      inspect = @dg.inspect
      @dg.vertices.inject(0) {|a,v| a += (@dg[v] || 0)}.should == 384
      @dg.edges.inject(0)    {|a,e| a += (@dg[e] || 0)}.should == 127
      reflect = eval inspect
      reflect.should == @dg
      reflect.edges.inject(0) { |a,e| a += (reflect[e] || 0)}.should == 127
      reflect.vertices.inject(0) {|a,v| a += (reflect[v] || 0)}.should == 384
    end
    
  end

end
