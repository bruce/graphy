module Graphy
  #
  # Digraph is a directed graph which is a finite set of vertices
  # and a finite set of edges connecting vertices. It cannot contain parallel
  # edges going from the same source vertex to the same target. It also
  # cannot contain loops, i.e. edges that go have the same vertex for source 
  # and target.
  #
  # DirectedPseudoGraph is a class that allows for parallel edges, and a
  # DirectedMultiGraph is a class that allows for parallel edges and loops
  # as well.
  class DirectedGraph

    module Algorithms
      
      include Search
      include StrongComponents
      include Distance
      include ChinesePostman

      # A directed graph is directed by definition
      def directed?() true; end

      # A digraph uses the Arc class for edges
      def edge_class() @parallel_edges ? Graphy::MultiArc : Graphy::Arc; end
      
      # Reverse all edges in a graph
      def reversal
        result = self.class.new
        edges.inject(result) {|a,e| a << e.reverse}
        vertices.each { |v| result.add_vertex!(v) unless result.vertex?(v) }
        result
      end

      # Return true if the Graph is oriented.
      def oriented?
        e = edges
        re = e.map {|x| x.reverse}
        not e.any? {|x| re.include?(x)}
      end
      
      # Balanced is when the out edge count is equal to the in edge count
      def balanced?(v) out_degree(v) == in_degree(v); end
      
      # Returns out_degree(v) - in_degree(v)
      def delta(v) out_degree(v) - in_degree(v); end
      
      def community(node, direction)
        nodes, stack = {}, adjacent(node, :direction => direction)
        while n = stack.pop
          unless nodes[n.object_id] || node == n
            nodes[n.object_id] = n
            stack += adjacent(n, :direction => direction)
          end
        end
        nodes.values
      end
      
      def descendants(node) community(node, :out); end
      def ancestors(node)   community(node, :in ); end
      def family(node)      community(node, :all); end    
      
    end

  end

end
