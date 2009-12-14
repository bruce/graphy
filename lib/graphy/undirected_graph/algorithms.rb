module Graphy

  class UndirectedGraph

    module Algorithms
      
      include Search
      include Biconnected
      include Comparability

      # UndirectedGraph is by definition undirected, always returns false
      def directed?()  false; end
      
      # Redefine degree (default was sum)
      def degree(v)    in_degree(v); end
      
      # A vertex of an undirected graph is balanced by definition
      def balanced?(v)  true;  end

      # UndirectedGraph uses Edge for the edge class.
      def edge_class() @parallel_edges ? Graphy::MultiEdge : Graphy::Edge; end

      def remove_edge!(u, v=nil)
        unless u.kind_of? Graphy::Arc
          raise ArgumentError if @parallel_edges 
          u = edge_class[u,v]
        end
        super(u.reverse) unless u.source == u.target
        super(u)
      end
      
      # A triangulated graph is an undirected perfect graph that every cycle of length greater than
      # three possesses a chord. They have also been called chordal, rigid circuit, monotone transitive,
      # and perfect elimination graphs.
      #
      # Implementation taken from Golumbic's, "Algorithmic Graph Theory and
      # Perfect Graphs" pg. 90
      def triangulated?
        a = Hash.new {|h,k| h[k]=Set.new}; sigma=lexicograph_bfs
        inv_sigma = sigma.inject({}) {|acc,val| acc[val] = sigma.index(val); acc}
        sigma[0..-2].each do |v|
          x = adjacent(v).select {|w| inv_sigma[v] < inv_sigma[w] }
          unless x.empty?
            u = sigma[x.map {|y| inv_sigma[y]}.min]
            a[u].merge(x - [u])
          end
          return false unless a[v].all? {|z| adjacent?(v,z)}
        end
        true
      end
      
      def chromatic_number
        return triangulated_chromatic_number if triangulated?
        raise NotImplementedError    
      end
      
      # An interval graph can have its vertices into one-to-one
      # correspondence with a set of intervals F of a linearly ordered
      # set (like the real line) such that two vertices are connected
      # by an edge of G if and only if their corresponding intervals
      # have nonempty intersection.
      def interval?() triangulated? and complement.comparability?; end
      
      # A permutation diagram consists of n points on each of two parallel
      # lines and n straight line segments matchin the points. The intersection
      # graph of the line segments is called a permutation graph.
      def permutation?() comparability? and complement.comparability?; end
      
      # An undirected graph is defined to be split if there is a partition
      # V = S + K of its vertex set into a stable set S and a complete set K.    
      def split?() triangulated? and complement.triangulated?; end
      
      private
      # Implementation taken from Golumbic's, "Algorithmic Graph Theory and
      # Perfect Graphs" pg. 99
      def triangulated_chromatic_number
        chi = 1; s= Hash.new {|h,k| h[k]=0}
        sigma=lexicograph_bfs
        inv_sigma = sigma.inject({}) {|acc,val| acc[val] = sigma.index(val); acc}
        sigma.each do |v|
          x = adjacent(v).select {|w| inv_sigma[v] < inv_sigma[w] }
          unless x.empty?
            u = sigma[x.map {|y| inv_sigma[y]}.min]
            s[u] = [s[u], x.size-1].max
            chi = [chi, x.size+1].max if s[v] < x.size
          end
        end; chi
      end
      
    end # UndirectedGraphAlgorithms

  end

end
