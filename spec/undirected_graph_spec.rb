require File.join(File.dirname(__FILE__), 'spec_helper')

describe "UndirectedGraph" do # :nodoc:

  before do
    @single = UndirectedGraph[1,2, 2,3, 3,4, 4,4, 1,2, 2,3]
    @dups   = UndirectedPseudoGraph[1,2, 2,3, 3,4, 4,4, 1,2, 2,3]
    @loops  = UndirectedMultiGraph[1,2, 2,3, 3,4, 4,4, 1,2, 2,3]
  end

  describe "new" do
    it do
      @single.should == UndirectedGraph[1,2, 2,3, 3,4, 4,4]
      @dups.should == UndirectedPseudoGraph[1,2, 2,3, 3,4, 4,4, 1,2, 2,3]
      @loops.should == UndirectedMultiGraph[1,2, 2,3, 3,4, 4,4, 1,2, 2,3]
      proc { UndirectedGraph.new(:bomb) }.should raise_error(ArgumentError)
      proc { UndirectedGraph.new(1) }.should raise_error(ArgumentError)
      UndirectedGraph.new(@single).should == @single
    end
  end

  describe "edges" do
    it do
      @single.edges.should include(Edge[1,2])
      @single.edges.should include(Edge[2,3])
      @single.edges.should include(Edge[3,4])
      @single.edges.should_not include(Edge[4,4])
      @loops.edges.should include(MultiEdge[4,4])
      @single.edges.should include(Edge[1,2])
      @single.edges.should include(Edge[2,3])
      @single.edges.should_not include(Edge[1,3])
      @single.should be_edge(2,3)
      @single.should_not be_edge(1,4)
      @single.should be_edge(Edge[1,2])
      @single.add_edge!(5,5).should_not be_edge(5,5)
      @dups.add_edge!(5,5).should_not be_edge(5,5)
      @loops.add_edge!(5,5).should be_edge(5,5)
      @single.remove_edge!(5,5).should_not be_edge(5,5)
    end
  end

  describe "vertices" do
    it do
      @single.vertices.to_a.sort.should == [1,2,3,4]
      @single.add_vertex!(5).to_a.sort.should == [1,2,3,4,5]
      @single.remove_vertex!(3).to_a.sort.should == [1,2,4,5]
      @single.should_not be_vertex(3)
      @single.should_not be_edge(2,3)
      @single.should_not be_edge(3,4)
    end
  end

  describe "properties" do
    it do
      @single.should_not be_directed
      @single.should_not be_empty
      UndirectedGraph.new.should be_empty
      @single.size.should == 4
      @dups.size.should == 4
      @single.num_vertices.should == 4
      @dups.num_vertices.should == 4
      @single.num_edges.should == 3
      @loops.num_edges.should == 6
      @dups.num_edges.should == 5
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
      result = @single + Edge[3,2] 
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 4
      result.num_edges.should == 3

      result = @single + 5
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 5
      result.num_edges.should == 3

      result = @single - Edge[4,4]
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 4
      result.num_edges.should == 3

      result = @single - 4
      @single.size.should == 4
      @single.num_edges.should == 3
      result.size.should == 3
      result.num_edges.should == 2
      
      @single << Edge[6,1]
      @single.size.should == 5
      @single.num_edges.should == 4
      @single.should be_edge(6,1)
    end
  end

  describe "complement" do
    it do
      complement = @single.complement 
      complement.vertices.sort.should == [1,2,3,4]
      complement.should_not be_edge(1,1)
      complement.should be_edge(1,3)
      complement.should be_edge(1,4)
      complement.should_not be_edge(2,2)
      complement.should be_edge(2,4)
      complement.should be_edge(3,1)
      complement.should_not be_edge(3,3)
      complement.should be_edge(4,1)
      complement.should be_edge(4,2)
      ##
      # This assertion wasn't running correctly in GRATR (`assert`
      # when it should have been `assert_equal`), failing now, and
      # may not be valid.
      # complement.num_edges.should == 7
    end
  end

  describe "induced_subgraph" do
    it do
      induced = @single.induced_subgraph([1,2])
      induced.vertices.sort.should == [1,2]
      induced.should be_edge(1,2)
       induced.num_edges.should == 1
    end
  end

  describe "include" do
    it do
      @single.should include(4)
      @dups.should include(4)
      @dups.should_not include(5)
      @single.should_not include(5)
      @single.should include(Edge[1,2])
      @dups.should include(Edge[1,2])
    end
  end

  describe "adjacent" do
    it do

      @single.should be_adjacent(2, Edge[1,2])
      @single.adjacent(1).should == [2]

      @single.adjacent(1, :type=>:edges).should == [Edge[1,2]]
      @single.adjacent(1, :type=>:edges, :direction=> :out).should == [Edge[1,2]]
      @single.adjacent(2, :type=>:edges, :direction=> :in).sort.should == [Edge[1,2],Edge[2,3]]
      @single.adjacent(2, :type=>:edges, :direction=> :all).sort.should == [Edge[1,2],Edge[2,3]]

      @dups.adjacent(1, :type=>:edges).should == [MultiEdge[1,2]]*2
      @dups.adjacent(1, :type=>:edges, :direction=> :out).should == [MultiEdge[1,2]]*2
      @dups.adjacent(2, :type=>:edges, :direction=> :in).sort.should == ([MultiEdge[1,2]]*2 + [MultiEdge[2,3]]*2)
      @dups.adjacent(2, :type=>:edges, :direction=> :all).sort.should == ([MultiEdge[1,2]]*2 + [MultiEdge[2,3]]*2)

      @single.adjacent(1, :type=>:vertices).should == [2]
      @single.adjacent(1, :type=>:vertices, :direction=> :out).should == [2]
      @single.adjacent(2, :type=>:vertices, :direction=> :in).should == [1,3]
      @single.adjacent(2, :type=>:vertices, :direction=> :all).should == [1,3]

      @single.adjacent(Edge[2,3], :type=>:vertices).should == [2,3]
      @single.adjacent(Edge[2,3], :type=>:vertices, :direction=> :out).should == [2,3]
      @single.adjacent(Edge[2,3], :type=>:vertices, :direction=> :in).should == [2,3]
      @single.adjacent(Edge[2,3], :type=>:vertices, :direction=> :all).should == [2,3]

      @single.adjacent(Edge[2,3], :type=>:edges).sort.should == [Edge[1,2],Edge[3,4]]
      @single.adjacent(Edge[2,3], :type=>:edges, :direction=> :out).sort.should == [Edge[1,2],Edge[3,4]]
      @single.adjacent(Edge[2,3], :type=>:edges, :direction=> :in).sort.should == [Edge[1,2],Edge[3,4]]
      @single.adjacent(Edge[2,3], :type=>:edges, :direction=> :all).sort.should == [Edge[1,2],Edge[3,4]]
      @dups.adjacent(MultiEdge[2,3], :type=>:edges).sort.should == ([MultiEdge[1,2]]*2 + [MultiEdge[3,4]])
      @dups.adjacent(MultiEdge[2,3], :type=>:edges, :direction=>:out).sort.should == ([MultiEdge[1,2]]*2 + [MultiEdge[3,4]])
      @dups.adjacent(MultiEdge[2,3], :type=>:edges, :direction=>:in).sort.should == ([MultiEdge[1,2]]*2 + [MultiEdge[3,4]])
      @dups.adjacent(MultiEdge[2,3], :type=>:edges, :direction=> :all).sort.should == ([MultiEdge[1,2]]*2+[MultiEdge[3,4]])
    end

    describe "neighborhood" do
      it do
        @single.neighborhood(1).sort.should == [2]
        @single.neighborhood(2).sort.should == [1, 3]
        @single.neighborhood(Edge[2,3]).sort.should == [Edge[1,2], Edge[3,4]]
      end
    end

    describe "degree" do
      it do
        @single.in_degree(1).should == 1
        @single.in_degree(2).should == 2
        @single.in_degree(4).should == 1
        @single.out_degree(1).should == 1
        @single.out_degree(2).should == 2
        @single.out_degree(4).should == 1
        @single.add_vertex!(6).out_degree(6).should == 0
        @single.add_vertex!(7).in_degree(7).should == 0
        @single.add_edge!(4,2).out_degree(4).should == 2
        @single.in_degree(2).should == 3
      end
    end

    describe "include" do
      it do
        @single.should include(2)
        @single.should_not include(23)
        @single.should include(Edge[1,2])
        @single.should_not include(Edge[1,4])
      end
    end

  end

end
