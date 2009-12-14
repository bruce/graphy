module Graphy
  
  # This defines the minimum set of functions required to make a graph class that can
  # use the algorithms defined by this library
  module GraphAPI
    
    # Each implementation module must implement the following routines
    #   * directed?()   # Is the graph directed?
    #   * add_vertex!(v,l=nil) # Add a vertex to the graph and return the graph, l is an optional label
    #   * add_edge!(u,v=nil,l=nil) # Add an edge to the graph and return the graph. u can be an Arc or Edge or u,v is an edge pair. last parameter is an optional label
    #   * remove_vertex!(v) # Remove a vertex to the graph and return the graph
    #   * remove_edge!(u,v=nil) # Remove an edge from the graph and return the graph
    #   * vertices()  # Returns an array of of all vertices
    #   * edges() # Returns an array of all edges
    #   * edge_class() # Returns the class used to store edges
    def self.included(klass)
       [:directed?,:add_vertex!,:add_edge!,:remove_vertex!,:remove_edge!,:vertices,:edges,:edge_class].each do |meth| 
         raise "Must implement #{meth}" unless klass.instance_methods.include?(meth.to_s)
       end
       
       klass.class_eval do
         # Is this right?
         alias remove_arc! remove_edge!
         alias add_arc!    add_edge!
         alias arcs        edges
         alias arc_class   edge_class
       end
    end
  end
end
