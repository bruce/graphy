module Graphy

  class UndirectedGraph < Graph

    autoload :Algorithms, "graphy/undirected_graph/algorithms"
    
     def initialize(*params)
       args = (params.pop if params.last.kind_of? Hash) || {}
       args[:algorithmic_category] = UndirectedGraph::Algorithms    
       super *(params << args)
     end
   end

   # This is a Digraph that allows for parallel edges, but does not
   # allow loops
   class UndirectedPseudoGraph < UndirectedGraph
     def initialize(*params)
       args = (params.pop if params.last.kind_of? Hash) || {}
       args[:parallel_edges] = true
       super *(params << args)
     end 
   end

   # This is a Digraph that allows for parallel edges and loops
   class UndirectedMultiGraph < UndirectedPseudoGraph
     def initialize(*params)
       args = (params.pop if params.last.kind_of? Hash) || {}
       args[:loops] = true
       super *(params << args)
     end 
   end
   
end # Graphy
