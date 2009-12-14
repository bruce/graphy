require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Digraph" do # :nodoc:

  before do
    @single = Digraph[1,2, 2,3, 3,4, 1,2, 2,3, 4,4]
    @dups   = DirectedPseudoGraph[1,2, 2,3, 3,4, 1,2, 2,3, 4,4]
    @loops  = DirectedMultiGraph[1,2, 2,3, 3,4, 4,4, 1,2, 2,3]
  end

  describe "new" do
    it do
      @single.should == Digraph[1,2, 2,3, 3,4]
      @dups.should == DirectedPseudoGraph.new([1,2, 2,3, 3,4, 1,2, 2,3])
      @loops.should == DirectedMultiGraph.new([1,2, 2,3, 3,4, 4,4, 1,2, 2,3])
      proc { Digraph.new(:loops) }.should raise_error(ArgumentError)
      proc { Digraph.new(:parallel_edges) }.should raise_error(ArgumentError)
      proc { DirectedMultiGraph.new(:loops) }.should raise_error(ArgumentError)
      proc { DirectedMultiGraph.new(:parallel_edges) }.should raise_error(ArgumentError)
      proc { DirectedPseudoGraph.new(:loops) }.should raise_error(ArgumentError)
      proc { DirectedPseudoGraph.new(:parallel_edges) }.should raise_error(ArgumentError)
      proc { Digraph.new(1) }.should raise_error(ArgumentError)
      Digraph.new(@single).should == @single
      DirectedPseudoGraph.new(@dups).should == @dups
      DirectedMultiGraph.new(@loops).should == @loops
      Digraph.new(@loops).should == Digraph[1,2, 2,3, 3,4]
    end
  end

  describe "edges" do
    it do
      @single.edges.size.should == 3
      @single.edges.include?(Arc[1,2]).should be_true
      @single.edges.include?(Arc[2,3]).should be_true
      @single.edges.include?(Arc[3,4]).should be_true
      @single.edges.include?(Arc[4,4]).should be_false
      @single.edges.include?(Arc[1,2]).should be_true
      @single.edges.include?(Arc[2,3]).should be_true
      @single.edges.include?(Arc[1,3]).should be_false
      @single.edge?(2,3).should be_true
      @single.edge?(1,4).should be_false
      @single.edge?(Arc[1,2]).should be_true
      @single.add_edge!(5,5).edge?(5,5).should be_false
      @single.remove_edge!(5,5).edge?(5,5).should be_false

      @dups.edges.size.should == 5
      @dups.edges.include?(MultiArc[1,2]).should be_true
      @dups.edges.include?(MultiArc[2,3]).should be_true
      @dups.edges.include?(MultiArc[3,4]).should be_true
      @dups.edges.include?(MultiArc[4,4]).should be_false
      @dups.edges.include?(MultiArc[1,2]).should be_true
      @dups.edges.include?(MultiArc[2,3]).should be_true
      @dups.edges.include?(MultiArc[1,3]).should be_false
      @dups.edge?(2,3).should be_true
      @dups.edge?(1,4).should be_false
      @dups.edge?(MultiArc[1,2]).should be_true
      @dups.add_edge!(5,5).edge?(5,5).should be_false
      proc {  @dups.remove_edge!(5,5)  }.should raise_error(ArgumentError)

      @dups.edges.size.should == 5 
      @loops.edges.include?(MultiArc[1,2]).should be_true
      @loops.edges.include?(MultiArc[2,3]).should be_true
      @loops.edges.include?(MultiArc[3,4]).should be_true
      @loops.edges.include?(MultiArc[4,4]).should be_true
      @loops.edges.include?(MultiArc[1,2]).should be_true
      @loops.edges.include?(MultiArc[2,3]).should be_true
      @loops.edges.include?(MultiArc[1,3]).should be_false
      @loops.edge?(2,3).should be_true
      @loops.edge?(1,4).should be_false
      @loops.edge?(MultiArc[1,2]).should be_true
      @loops.add_edge!(5,5).edge?(5,5).should be_true
      proc {  @loops.remove_edge!(5,5)  }.should raise_error(ArgumentError)
    end

  end

  describe "vertices" do
    it do
        @single.vertices.sort.should == [1,2,3,4]
      @single.add_vertex!(5).to_a.sort.should == [1,2,3,4,5]
        @single.remove_vertex!(3).to_a.sort.should == [1,2,4,5]
      @single.vertex?(3).should be_false
      @single.edge?(2,3).should be_false
      @single.edge?(3,4).should be_false
      @single.add_vertex(:bogus).vertex?(:bogus).should be_true
      @single.add_vertex(:bogus).vertex?(nil).should be_false
      @single.vertex?(:bogus).should be_false
      @single.add_vertex!(:real)
      @single.vertex?(:real).should be_true
      @single.add_edge(:here, :there).edge?(Arc[:here, :there]).should be_true
      @single.edge?(Arc[:here, :there]).should be_false
      @single.vertex?(:here).should be_false
      @single.vertex?(:there).should be_false
      @single.add_edge!(:here, :there)
      @single.edge?(Arc[:here, :there]).should be_true
      @single.vertex?(:here).should be_true
      @single.vertex?(:there).should be_true
    end
  end

  describe "properties" do
    it do
      @single.should be_directed
      @single.should_not be_empty
      Digraph.new.should be_empty
      @single.size.should == 4
      @dups.size.should == 4
      @loops.size.should == 4
      @single.num_vertices.should == 4
      @dups.num_vertices.should == 4
      @single.num_edges.should == 3
      @dups.num_edges.should == 5
      @loops.num_edges.should == 6
      @single.should be_oriented
      @single.remove_vertex!(4)
      @single.should be_oriented
      @loops.oriented?.should be_false
      @loops.remove_vertex!(4)
      @loops.should be_oriented
    end
  end

  describe "merge" do
    it do
      @dups.merge(@single)
      @dups.num_edges.should == 8
      @dups.vertices.sort.should == [1,2,3,4]
    end
  end

  describe "operators" do
    it do
      result = @single + Arc[3,2] 
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 4
      result.num_edges.should == 4

      result = @single + 5
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 5
      result.num_edges.should == 3

      result = @single - Arc[4,4]
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 4
      result.num_edges.should == 3

      e = @loops.edges.detect { |e| e.source == 4 && e.target == 4 }
      result = @loops - e
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 4
      result.num_edges.should == 5

      result = @single - 4
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 3
      result.num_edges.should == 2
      
      @single << Arc[6,1]
      @single.size.should == 5
      @single.num_edges.should == 4
      @single.edge?(6,1).should be_true
    end
  end

  describe "reversal" do
    it do
      reverse = @single.add_vertex!(42).reversal
      reverse.vertices.sort.should == [1,2,3,4,42]
      reverse.edge?(2,1).should be_true
      reverse.edge?(3,2).should be_true
      reverse.edge?(4,3).should be_true
      reverse.edge?(4,4).should be_false
      reverse.num_edges.should == 3
      reverse = @loops.reversal
      reverse.edge?(4,4).should be_true
    end
  end

  describe "complement" do
    it do
      complement = @single.complement 
      complement.vertices.sort.should == [1,2,3,4]
      complement.edge?(1,1).should be_false
      complement.edge?(1,3).should be_true
      complement.edge?(1,4).should be_true
      complement.edge?(2,1).should be_true
      complement.edge?(2,4).should be_true
      complement.edge?(3,1).should be_true
      complement.edge?(3,2).should be_true
      complement.edge?(4,1).should be_true
      complement.edge?(4,2).should be_true
      complement.edge?(4,3).should be_true
      complement.num_edges.should == 9

      complement = @loops.complement 
      complement.vertices.sort.should == [1,2,3,4]
      complement.edge?(1,1).should be_true
      complement.edge?(1,3).should be_true
      complement.edge?(1,4).should be_true
      complement.edge?(2,1).should be_true
      complement.edge?(2,2).should be_true
      complement.edge?(2,4).should be_true
      complement.edge?(3,1).should be_true
      complement.edge?(3,2).should be_true
      complement.edge?(3,3).should be_true
      complement.edge?(4,1).should be_true
      complement.edge?(4,2).should be_true
      complement.edge?(4,3).should be_true
      complement.num_edges.should == 12
    end
  end

  describe "induced_subgraph" do
    it do
      induced = @single.induced_subgraph([1,2])
      induced.vertices.sort.should == [1,2]
      induced.edge?(1,2).should be_true
      induced.num_edges.should == 1
    end
  end

  describe "include" do
    it do
      @single.include?(4).should be_true
      @dups.include?(4).should be_true
      @dups.include?(5).should be_false
      @single.include?(5).should be_false
      @single.include?(Arc[1,2]).should be_true
      @dups.include?(Arc[1,2]).should be_true
    end
  end

  describe "adjacent" do
    it do

      @single.adjacent?(2, Arc[1,2]).should be_true
      @single.adjacent(1).should == [2]

      @single.adjacent(1, :type=>:edges).should == [Arc[1,2]]
      @single.adjacent(1, :type=>:edges, :direction=> :out).should == [Arc[1,2]]
      @single.adjacent(2, :type=>:edges, :direction=> :in).should == [Arc[1,2]]
      @single.adjacent(2, :type=>:edges, :direction=> :all).sort.should == [Arc[1,2],Arc[2,3]]

      [[{},1], [{:direction => :out},1], [{:direction => :in},2]].each do |h,v|
        adj = @dups.adjacent(v, h.merge(:type=>:edges))
        adj.size.should == 2
        adj.each do |e|
          e.source == 1; e.target.should  == 2
        end
      end 
      
      adj = @dups.adjacent(2, {:type=>:edges,:direction=>:all})
      adj.size.should == 4
      adj.each do |e| 
        ((e.source==1 and e.target==2) ||
         (e.source==2 and e.target==3)).should be_true
      end
      
        @single.adjacent(1, :type=>:vertices).should == [2]
        @single.adjacent(1, :type=>:vertices, :direction=> :out).should == [2]
        @single.adjacent(2, :type=>:vertices, :direction=> :in).should == [1]
      @single.adjacent(2, :type=>:vertices, :direction=> :all).should == [1,3]

      @single.adjacent(Arc[2,3], :type=>:vertices).should == [3]
      @single.adjacent(Arc[2,3], :type=>:vertices, :direction=> :out).should == [3]
      @single.adjacent(Arc[2,3], :type=>:vertices, :direction=> :in).should == [2]
      @single.adjacent(Arc[2,3], :type=>:vertices, :direction=> :all).should == [2,3]

      @single.adjacent(Arc[2,3], :type=>:edges).should == [Arc[3,4]]
      @single.adjacent(Arc[2,3], :type=>:edges, :direction=> :out).should == [Arc[3,4]]
      @single.adjacent(Arc[2,3], :type=>:edges, :direction=> :in).should == [Arc[1,2]]
      @single.adjacent(Arc[2,3], :type=>:edges, :direction=> :all).sort.should == [Arc[1,2],Arc[3,4]]
      
      @dups.adjacent(MultiArc[2,3], :type=>:edges).should == [MultiArc[3,4]]
      @dups.adjacent(MultiArc[2,3], :type=>:edges, :direction=> :out).should == [MultiArc[3,4]]
      @dups.adjacent(MultiArc[2,3], :type=>:edges, :direction=> :in).should == [MultiArc[1,2]]*2
      @dups.adjacent(MultiArc[2,3], :type=>:edges, :direction=> :all).sort.should == ([MultiArc[1,2]]*2+[MultiArc[3,4]])
    end
    
  end

  describe "neighborhood" do
    it do
      @single.neighborhood(1).sort.should == [2]
      @single.neighborhood(2).sort.should == [1,3]
      @single.neighborhood(Arc[2,3]).sort.should == [Arc[1,2], Arc[3,4]]
    end
  end

  describe "degree" do
    it do
      @single.in_degree(1).should == 0
      @single.in_degree(2).should == 1
      @single.in_degree(4).should == 1
      @loops.degree(4).should == 3
      @loops.in_degree(4).should == 2
      @single.out_degree(1).should == 1
      @single.out_degree(2).should == 1
      @single.out_degree(4).should == 0
      @loops.out_degree(4).should == 1
      @single.add_vertex!(6).out_degree(6).should == 0
      @single.add_vertex!(7).in_degree(7).should == 0
      @single.add_edge!(4,2).out_degree(4).should == 1
      @loops.add_edge!(4,2).out_degree(4).should == 2
      @single.in_degree(2).should == 2

      @single.min_in_degree.should == 0
      @single.max_in_degree.should == 2
      @single.min_out_degree.should == 0
      @single.max_out_degree.should == 1

      @loops.min_in_degree.should == 0
      @loops.max_in_degree.should == 2
      @loops.min_out_degree.should == 1
      @loops.max_out_degree.should == 2
      @loops.degree(2).should == 4
      @single.degree(1).should == 1
      @loops.should_not be_regular
      @single.should_not be_regular
      @dups.should_not be_regular
    end
  end

  describe "include" do
    it do
      @single.include?(2).should be_true
      @single.include?(23).should be_false
      @single.include?(Arc[1,2]).should be_true
      @single.include?(Arc[1,4]).should be_false
    end
  end

end
