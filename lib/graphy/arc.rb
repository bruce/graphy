module Graphy

  # Arc includes classes for representing egdes of directed and
  # undirected graphs. There is no need for a Vertex class, because any ruby
  # object can be a vertex of a graph.
  #
  # Arc's base is a Struct with a :source, a :target and a :label
  Struct.new("ArcBase",:source, :target, :label)

  class Arc < Struct::ArcBase

    def initialize(p_source,p_target,p_label=nil)
      super(p_source, p_target, p_label)
    end

    # Ignore labels for equality
    def eql?(other) self.class == other.class and target==other.target and source==other.source; end

    # Alias for eql?
    alias == eql?

    # Returns (v,u) if self == (u,v).
    def reverse() self.class.new(target, source, label); end

    # Sort support
    def <=>(rhs) [source,target] <=> [rhs.source,rhs.target]; end

    # Arc.new[1,2].to_s => "(1-2 'label')"
    def to_s
      l = label ? " '#{label.to_s}'" : ''
      "(#{source}-#{target}#{l})"
    end
    
    # Hash is defined in such a way that label is not
    # part of the hash value
    def hash() source.hash ^ (target.hash+1); end

    # Shortcut constructor. Instead of Arc.new(1,2) one can use Arc[1,2]
    def self.[](p_source, p_target, p_label=nil)
      new(p_source, p_target, p_label)
    end
    
    def inspect() "#{self.class.to_s}[#{source.inspect},#{target.inspect},#{label.inspect}]"; end
    
  end
  
  class MultiArc < Arc
    include ArcNumber
  end
  
end
