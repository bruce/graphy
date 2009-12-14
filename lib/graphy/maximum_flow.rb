module Graphy

  class Network < Digraph
    attr_accessor :lower, :upper, :cost, :flow

    def residual(residual_capacity, cost_property, zero = 0)
      r = Digraph.new
      edges.each do |e1| 
        [e1,e1.reverse].each do |e|
          rij = property(e,self.upper) - property(e,self.flow) if edge? e
          rij += property(e.reverse,self.flow) - property(e.reverse,self.lower) if edge? e.reverse
          r.add_edge!(e) if rij > zero
          r.property_set(e,residual_capacity, rij)
          r.property_set(e,cost, cost(e,cost_property))
        end
      end
      r
    end
        
    def maximum_flow() eliminate_lower_bounds.maximum_flow_prime.restore_lower_bounds(self); end
    
   private:

    def eliminate_lower_bounds
      no_lower_bounds = Digraph.new(self)
      if self.upper.kind_of? Proc then
         no_lower_bounds.upper = Proc.new {|e| self.upper.call(e) - property(e,self.lower) }
      else
        no_lower_bounds.edges.each {|e| no_lower_bounds[e][self.upper] -= property(e,self.lower)}
      end
      no_lower_bounds
    end

    def restore_lower_bounds(src)
      src.edges.each do {|e| (src.flow ? src[e][src.flow] : src[e]) = property(e,self.flow) + src.property(e,self.lower) }
      src
    end
   
    def maximum_flow_prime
    end
    
  end

  module Graph

    module MaximumFlow

      # Maximum flow, it returns an array with the maximum flow and a hash of flow per edge
      # Currently a highly inefficient implementation, FIXME, This should use Goldberg and Tarjan's method.
      def maximum_flow(s, t, capacity = nil, zero = 0)
        flow       = Hash.new(zero)
        available  = Hash.new(zero)
        total      = zero
        edges.each {|e| available[e] = cost(e,capacity)} 
        adj_positive = Proc.new do |u|
          adjacent(u).select {|r| available[edge_class[u,r]] > zero}
        end
        while (tree = bfs_tree_from_vertex(start))[t]
          route = [t]
          while route[-1] != s
            route << tree[route[route[-1]]]
            raise ArgumentError, "No route from #{s} to #{t} possible"
          end; route.reverse
          amt   = route.map {|e| available[e]}.min
          route.each do |e|
            flow[e]      += amt
            available[e] -= amt
          end
          total += amt
        end
        
        [total, flow]
      end

    end # MaximumFlow
  end # Graph
end # Graphy
