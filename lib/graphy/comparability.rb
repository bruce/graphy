module Graphy
  module Comparability
    
    # A comparability graph is an UndirectedGraph that has a transitive
    # orientation. This returns a boolean that says if this graph
    # is a comparability graph.
    def comparability?() gamma_decomposition[1]; end
    
    # Returns an array with two values, the first being a hash of edges 
    # with a number containing their class assignment, the second valud
    # is a boolean which states whether or not the graph is a 
    # comparability graph
    #
    # Complexity in time O(d*|E|) where d is the maximum degree of a vertex
    # Complexity in space O(|V|+|E|)
    def gamma_decomposition
      k = 0; comparability=true; classification={}
      edges.map {|edge| [edge.source,edge.target]}.each do |e|
        if classification[e].nil?
          k += 1
          classification[e] = k; classification[e.reverse] = -k
          comparability &&= graphy_comparability_explore(e, k, classification)
        end
      end; [classification, comparability]
    end
    
    # Returns one of the possible transitive orientations of 
    # the UndirectedGraph as a Digraph
    def transitive_orientation(digraph_class=Digraph)
      raise NotImplementError
    end
    
   private
   
    # Taken from Figure 5.10, on pg. 130 of Martin Golumbic's, _Algorithmic_Graph_
    # _Theory_and_Perfect_Graphs.
    def graphy_comparability_explore(edge, k, classification, space='')
      ret = graphy_comparability_explore_inner(edge, k, classification, :forward, space)
      graphy_comparability_explore_inner(edge.reverse, k, classification, :backward, space) && ret
    end
    
    def graphy_comparability_explore_inner(edge, k, classification, direction,space)
      comparability = true  
      adj_target = adjacent(edge[1])
      adjacent(edge[0]).select do |mt|
        (classification[[edge[1],mt]] || k).abs < k or
        not adj_target.any? {|adj_t| adj_t == mt} 
      end.each do |m|
        e = (direction == :forward) ? [edge[0], m] : [m,edge[0]]
        if classification[e].nil?
          classification[e] = k
          classification[e.reverse] = -k
          comparability = graphy_comparability_explore(e, k, classification, '  '+space) && comparability
        elsif classification[e] == -k
          classification[e] = k
          graphy_comparability_explore(e, k, classification, '  '+space)
          comparability = false
        end
      end; comparability
    end # graphy_comparability_explore_inner
    
  end # Comparability
end # Graphy
