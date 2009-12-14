require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Search" do # :nodoc:

  before do
    @directed   = Digraph[1,2, 2,3, 2,4, 4,5, 1,6, 6,4]
    @undirected = UndirectedGraph[1,2, 2,3, 2,4, 4,5, 1,6]
    @tree       = Digraph[ 1,2, 1,3, 1,4, 2,5, 2,4, 2,6, 6,7, 23,24 ]
  end

  # "Algorithmic Graph Theory and Perfect Graphs", Martin Charles
  # Golumbic, 1980, Academic Press, page 39, Propery (D1) and (D2) of 
  # depth first search
  describe "dfs_properties" do
    it do
      dfs = {}
      father = {}
      @directed.each do |vertex|
        assign_dfsnumber_ancestry(@directed, dfs, father, vertex)  
        # Property (D1)
        father.keys.each {|v| dfs[father[v]].should be < dfs[v] }
        # Property (D2)
        # FIXME: Huh? Doesn't work
        #@directed.edges.each {|e| related?(father, e.source, e.target).should be_true }
        #@directed.edges.each {|e| dfs[e.source].should be < dfs[e.target] }
      end
      @directed.dfs.size.should == 6
      @directed.dfs.sort.should == @directed.vertices.sort
    end
  end

  # "Algorithmic Graph Theory and Perfect Graphs", Martin Charles
  # Golumbic, 1980, Academic Press, page 40, Propery (B1), (B2) and (B3) of 
  # breadth first search
  describe "bfs_properties" do
    it do
      level  = {}  
      father = {}
      bfs    = {}
      @directed.each do |vertex|
        assign_bfsnumber_ancestry(@directed, bfs, level, father, vertex)  
        # Property (B1)
        father.keys.each do |v|
          bfs[father[v]].should be < bfs[v]
        end
        # Property (B2)
        @directed.edges.each do |e|
          (level[e.source]-level[e.target]).abs.should be < 2
        end
        # Property (B3)
        # FIXME: How can one test this?
        # @directed.vertex.each { |e| (level[e.source]-level[e.target]).abs.should be < 2 }
      end
      @directed.dfs.size.should == 6
      @directed.dfs.sort.should == @directed.vertices.sort
    end
  end

  describe "cyclic" do
    it do
      @directed.should be_acyclic
      @undirected.should be_acyclic
      @directed.should_not be_cyclic
      @undirected.should_not be_cyclic
      @undirected.add_edge!(4,6)
      @directed.add_edge!(3,1)
      @directed.should_not be_acyclic
      @undirected.should_not be_acyclic
      @directed.should be_cyclic
      @undirected.should be_cyclic

      # Test empty graph
      x = Digraph.new
      x.should_not be_cyclic
      x.should be_acyclic
    end
  end

  describe "astar" do
    it do
      # Graph from "Artificial Intelligence: A Modern Approach" by Stuart
      # Russell ande Peter Norvig, Prentice-Hall 2nd Edition, pg 63
      romania = UndirectedGraph.new.
        add_edge!('Oradea',         'Zerind',          71).
        add_edge!('Oradea',         'Sibiu',          151).
        add_edge!('Zerind',         'Arad',            75).
        add_edge!('Arad',           'Sibiu',           99).
        add_edge!('Arad',           'Timisoara',      138).
        add_edge!('Timisoara',      'Lugoj',          111).
        add_edge!('Lugoj',          'Mehadia',         70).
        add_edge!('Mehadia',        'Dobreta',         75).
        add_edge!('Dobreta',        'Craiova',        120).
        add_edge!('Sibiu',          'Fagaras',         99).
        add_edge!('Fagaras',        'Bucharest',      211).
        add_edge!('Sibiu',          'Rimnicu Vilcea',  80).
        add_edge!('Rimnicu Vilcea', 'Craiova',        146).
        add_edge!('Rimnicu Vilcea', 'Pitesti',         97).
        add_edge!('Craiova',        'Pitesti',        138).
        add_edge!('Pitesti',        'Bucharest',      101).
        add_edge!('Bucharest',      'Giurgin',         90).
        add_edge!('Bucharest',      'Urzieni',         85).
        add_edge!('Urzieni',        'Hirsova',         98).
        add_edge!('Urzieni',        'Vaslui',         142).
        add_edge!('Hirsova',        'Eforie',          86).
        add_edge!('Vaslui',         'Iasi',            92).
        add_edge!('Iasi',           'Neamt',           87)

      # Heuristic from "Artificial Intelligence: A Modern Approach" by Stuart
      # Russell ande Peter Norvig, Prentice-Hall 2nd Edition, pg 95
      straight_line_to_Bucharest = 
        {
        'Arad'           => 366,
        'Bucharest'      =>   0,
        'Craiova'        => 160,
        'Dobreta'        => 242,
        'Eforie'         => 161,
        'Fagaras'        => 176,
        'Giurgiu'        =>  77,
        'Hirsova'        => 151,
        'Iasi'           => 226,
        'Lugoj'          => 244,
        'Mehadia'        => 241,
        'Neamt'          => 234,
        'Oradea'         => 380,
        'Pitesti'        => 100,
        'Rimnicu Vilcea' => 193,
        'Sibiu'          => 253,
        'Timisoara'      => 329,
        'Urziceni'       =>  80,
        'Vaslui'         => 199,
        'Zerind'         => 374
      }

      # Heuristic is distance as crow flies, always under estimates costs.
      h   = Proc.new {|v| straight_line_to_Bucharest[v]}

      list = []

      dv  = Proc.new {|v| list << "dv #{v}" }
      ev  = Proc.new {|v| list << "ev #{v}" }
      bt  = Proc.new {|v| list << "bt #{v}" }
      fv  = Proc.new {|v| list << "fv #{v}" }
      er  = Proc.new {|e| list << "er #{e}" }
      enr = Proc.new {|e| list << "enr #{e}" }
      
      options = { :discover_vertex  => dv,
        :examine_vertex   => ev,
        :black_target     => bt,
        :finish_vertex    => fv,
        :edge_relaxed     => er,
        :edge_not_relaxed => enr }
      
      result = romania.astar('Arad', 'Bucharest', h, options)

      result.should == ["Arad", "Sibiu", "Rimnicu Vilcea", "Pitesti", "Bucharest"]
      # This isn't the greatest test since the exact ordering is not
      # not specified by the algorithm. If someone has a better idea, please fix
      list.should ==  ["ev Arad",
                    "er (Arad=Sibiu '99')",
                    "dv Sibiu",
                    "er (Arad=Timisoara '138')",
                    "dv Timisoara",
                    "er (Arad=Zerind '75')",
                    "dv Zerind",
                    "fv Arad",
                    "ev Sibiu",
                    "er (Rimnicu Vilcea=Sibiu '80')",
                    "dv Rimnicu Vilcea",
                    "er (Fagaras=Sibiu '99')",
                    "dv Fagaras",
                    "er (Oradea=Sibiu '151')",
                    "dv Oradea",
                    "enr (Arad=Sibiu '99')",
                    "fv Sibiu",
                    "ev Rimnicu Vilcea",
                    "enr (Rimnicu Vilcea=Sibiu '80')",
                    "er (Craiova=Rimnicu Vilcea '146')",
                    "dv Craiova",
                    "er (Pitesti=Rimnicu Vilcea '97')",
                    "dv Pitesti",
                    "fv Rimnicu Vilcea",
                    "ev Fagaras",
                    "enr (Fagaras=Sibiu '99')",
                    "er (Bucharest=Fagaras '211')",
                    "dv Bucharest",
                    "fv Fagaras",
                    "ev Pitesti",
                    "enr (Pitesti=Rimnicu Vilcea '97')",
                    "er (Bucharest=Pitesti '101')",
                    "enr (Craiova=Pitesti '138')",
                    "fv Pitesti",
                    "ev Bucharest"]
    end
  end
  
  describe "bfs_spanning_forest" do
    it do
      predecessor, roots = @tree.bfs_spanning_forest(1)
      predecessor.should == {2=>1, 3=>1, 4=>1, 5=>2, 6=>2, 7=>6, 24=>23}
      roots.sort.should == [1,23]
      predecessor, roots = @tree.bfs_spanning_forest(3)
      predecessor.should == {7=>6, 24=>23, 2=>1, 4=>1}
      roots.sort.should == [1,3,5,6,23]
    end
  end
  
  describe "dfs_spanning_forest" do
    it do
      predecessor, roots = @tree.dfs_spanning_forest(1)
      predecessor.should == {5=>2, 6=>2, 7=>6, 24=>23, 2=>1, 3=>1, 4=>2}
      roots.sort.should == [1,23]
      predecessor, roots = @tree.dfs_spanning_forest(3)
      predecessor.should == {7=>6, 24=>23, 2=>1, 4=>2}
      roots.sort.should == [1,3,5,6,23]
    end
  end
  
  describe "tree_from_vertex" do
    it do
      @tree.bfs_tree_from_vertex(1).should == {5=>2, 6=>2, 7=>6, 2=>1, 3=>1, 4=>1}
      @tree.bfs_tree_from_vertex(3).should == {}
      @tree.dfs_tree_from_vertex(1).should == {5=>2, 6=>2, 7=>6, 2=>1, 3=>1, 4=>2}
      @tree.dfs_tree_from_vertex(3).should == {}
    end
  end

end
