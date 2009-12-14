module Graphy
  
  class DirectedGraph < Graph
    
    autoload :Algorithms, "graphy/directed_graph/algorithms"
    autoload :Distance, "graphy/directed_graph/distance"    
    
    def initialize(*params)
      args = (params.pop if params.last.kind_of? Hash) || {}
      args[:algorithmic_category] = DirectedGraph::Algorithms    
      super *(params << args)
    end
  end
  
  # DirectedGraph is just an alias for Digraph should one desire
  Digraph = DirectedGraph

  # This is a Digraph that allows for parallel edges, but does not
  # allow loops
  class DirectedPseudoGraph < DirectedGraph
    def initialize(*params)
      args = (params.pop if params.last.kind_of? Hash) || {}
      args[:parallel_edges] = true
      super *(params << args)
    end 
  end

  # This is a Digraph that allows for parallel edges and loops
  class DirectedMultiGraph < DirectedPseudoGraph
    def initialize(*params)
      args = (params.pop if params.last.kind_of? Hash) || {}
      args[:loops] = true
      super *(params << args)
    end 
  end

end
