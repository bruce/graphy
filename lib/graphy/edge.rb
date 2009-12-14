module Graphy
    
  # An undirected edge is simply an undirected pair (source, target) used in
  # undirected graphs. Edge[u,v] == Edge[v,u]
  class Edge < Arc

    # Equality allows for the swapping of source and target
    def eql?(other) super or (self.class == other.class and target==other.source and source==other.target); end
      
    # Alias for eql?
    alias == eql?

    # Hash is defined such that source and target can be reversed and the
    # hash value will be the same
    def hash() source.hash ^ target.hash; end

    # Sort support
    def <=>(rhs)
      [[source,target].max,[source,target].min] <=> 
      [[rhs.source,rhs.target].max,[rhs.source,rhs.target].min]
    end
    
    # Edge[1,2].to_s == "(1=2 'label)"
    def to_s
      l = label ? " '#{label.to_s}'" : ''
      s = source.to_s
      t = target.to_s
      "(#{[s,t].min}=#{[s,t].max}#{l})"
    end
    
  end
    
  class MultiEdge < Edge
    include ArcNumber
  end
  
end
