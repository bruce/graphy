require File.join(File.dirname(__FILE__), 'spec_helper')

describe "DigraphDistance" do # :nodoc:

  before do  
    @d = Digraph[ :a,:b, :a,:e,
                  :b,:c, :b,:e,
                  :c,:d,
                  :d,:c,
                  :e,:b, :e,:f,
                  :f,:c, :f,:d, :f,:e ]
    
    @w = {  Arc[:a,:b] => 9,
      Arc[:a,:e] => 3,
      Arc[:b,:c] => 2,
      Arc[:b,:e] => 6,
      Arc[:c,:d] => 1,
      Arc[:d,:c] => 2,
      Arc[:e,:b] => 2,
      Arc[:e,:f] => 1,
      Arc[:f,:c] => 2,
      Arc[:f,:d] => 7,
      Arc[:f,:e] => 2  }
    @a = {  :a => 0,
      :b => 5,
      :c => 6,
      :d => 7,
      :e => 3,
      :f => 4   }
    @simple_weight = Proc.new {|e| 1}            
  end
  
  describe "shortest_path" do
    it do
      x = Digraph[ :s,:u, :s,:w,
                   :j,:v,
                   :u,:j,
                   :v,:y,
                   :w,:u, :w,:v, :w,:y, :w,:x,
                   :x,:z ]
      x.should be_acyclic
      cost, path = x.shortest_path(:s,@simple_weight)
      cost.should == {:x=>2, :v=>2, :y=>2, :w=>1, :s=>0, :z=>3, :u=>1, :j=> 2}
      path.should == {:x=>:w, :v=>:w, :y=>:w, :w=>:s, :z=>:x, :u=>:s, :j=>:u}
    end
  end
  
  describe "dijkstra_with_proc" do
    it do
      p = Proc.new {|e| @w[e]}
      distance, path = @d.dijkstras_algorithm(:a,p)
      distance.should == @a
      path.should == { :d => :c,  :c => :f,  :f => :e,  :b => :e,  :e => :a}
    end
  end
  
  describe "dijkstra_with_label" do
    it do
      @w.keys.each {|e| @d[e] = @w[e]}
      @d.dijkstras_algorithm(:a)[0].should == @a
    end
  end

  describe "dijkstra_with_bracket_label" do
    it do
      @w.keys.each do |e|
        @d[e] = {:xyz => (@w[e])} 
      end
      @d.dijkstras_algorithm(:a, :xyz)[0].should == @a
      @w.keys.each do |e|
        @d[e] = [@w[e]] 
      end
      @d.dijkstras_algorithm(:a, 0)[0].should == @a
    end
  end
  
  describe "floyd_warshall" do
    it do
      simple = Digraph[ 0,1,  0,2,  1,2,  1,3,  2,3,  3,0 ]
      
      cost, path, delta = simple.floyd_warshall(@simple_weight)
      # Costs
      cost[0].should == {0=>3, 1=>1, 2=>1, 3=>2}
      cost[1].should == {0=>2, 1=>3, 2=>1, 3=>1}
      cost[2].should == {0=>2, 1=>3, 2=>3, 3=>1}
      cost[3].should == {0=>1, 1=>2, 2=>2, 3=>3}
      
      # Paths
      path[0].should == {0=>1, 1=>1, 2=>2, 3=>1}
      path[1].should == {0=>3, 1=>3, 2=>2, 3=>3}
      path[2].should == {0=>3, 1=>3, 2=>3, 3=>3}
      path[3].should == {0=>0, 1=>0, 2=>0, 3=>0}
      
      # Deltas
      delta[0].should == 1
      delta[1].should == 1
      delta[2].should == -1
      delta[3].should == -1
    end
  end
  
  describe "bellman_ford_moore" do
    it do
      fig24 = Digraph[ [:s,:e] =>  8,
                       [:s,:d] =>  4,
                       [:e,:c] =>  2,
                       [:e,:d] => -5,
                       [:c,:b] => -2,
                       [:d,:c] => -2,
                       [:d,:a] =>  4,
                       [:a,:c] => 10,
                       [:a,:b] =>  9,
                       [:b,:c] =>  5,
                       [:b,:a] => -3]
      cost, path = fig24.bellman_ford_moore(:s)
      cost.should == {:e=>8, :d=>3, :c=>1, :b=>-1, :a=>-4, :s=>0}
      path.should == {:e=>:s, :d=>:e, :c=>:d, :b=>:c, :a=>:b}
    end
  end
  
end
