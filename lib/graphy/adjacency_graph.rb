module Graphy

  # This provides the basic routines needed to implement the Digraph,
  # UndirectedGraph, PseudoGraph, DirectedPseudoGraph, MultiGraph and
  # DirectedPseudoGraph class.
  module AdjacencyGraph

    class ArrayWithAdd < Array # :nodoc:
      alias add push
    end

    # Initialization parameters can include an Array of edges to add, Graphs to
    # copy (will merge if multiple)
    # :parallel_edges denotes that duplicate edges are allowed
    # :loops denotes that loops are allowed
    def implementation_initialize(*params)
      @vertex_dict     = Hash.new    
      clear_all_labels
      
      args = (params.pop if params.last.kind_of? Hash) || {}

      # Basic configuration of adjacency
      @allow_loops    = args[:loops]          || false
      @parallel_edges = args[:parallel_edges] || false
      @edgelist_class = @parallel_edges ? ArrayWithAdd : Set
      if @parallel_edges
        @edge_number      = Hash.new
        @next_edge_number = 0 
      end

      # Copy any given graph into this graph
      params.select {|p| p.kind_of? Graphy::Graph}.each do |g|
        g.edges.each do |e| 
          add_edge!(e)
          edge_label_set(e, edge_label(e)) if edge_label(e)
        end
        g.vertices.each do |v|
          vertex_label_set(v, vertex_label(v)) if vertex_label(v)
        end  
      end

      # Add all array edges specified
      params.select {|p| p.kind_of? Array}.each do |a|
        0.step(a.size-1, 2) {|i| add_edge!(a[i], a[i+1])}
      end

    end

    # Returns true if v is a vertex of this Graph
    # An O(1) implementation of vertex?
    def vertex?(v) @vertex_dict.has_key?(v); end

    # Returns true if [u,v] or u is an Arc
    # An O(1) implementation 
    def edge?(u, v=nil)
      u, v = u.source, u.target if u.kind_of? Graphy::Arc
      vertex?(u) and @vertex_dict[u].include?(v)
    end

    # Adds a vertex to the graph with an optional label
    def add_vertex!(vertex, label=nil)
      @vertex_dict[vertex] ||= @edgelist_class.new
      self[vertex] = label if label
      self
    end

    # Adds an edge to the graph
    # Can be called in two basic ways, label is optional
    #   * add_edge!(Arc[source,target], "Label")
    #   * add_edge!(source,target, "Label")
    def add_edge!(u, v=nil, l=nil, n=nil)
      n = u.number if u.class.include? ArcNumber and n.nil?
      u, v, l = u.source, u.target, u.label if u.kind_of? Graphy::Arc
      return self if not @allow_loops and u == v
      n = (@next_edge_number+=1) unless n if @parallel_edges
      add_vertex!(u); add_vertex!(v)        
      @vertex_dict[u].add(v)
      (@edge_number[u] ||= @edgelist_class.new).add(n) if @parallel_edges
      unless directed?
        @vertex_dict[v].add(u)
        (@edge_number[v] ||= @edgelist_class.new).add(n) if @parallel_edges
      end        
      self[n ? edge_class[u,v,n] : edge_class[u,v]] = l if l
      self
    end

    # Removes a given vertex from the graph
    def remove_vertex!(v)
# FIXME This is broken for multi graphs 
      @vertex_dict.delete(v)
      @vertex_dict.each_value { |adjList| adjList.delete(v) }
      @vertex_dict.keys.each  do |u| 
        delete_label(edge_class[u,v]) 
        delete_label(edge_class[v,u])
      end
      delete_label(v) 
      self
    end

    # Removes an edge from the graph, can be called with source and target or with
    # and object of Graphy::Arc derivation
    def remove_edge!(u, v=nil)
      unless u.kind_of? Graphy::Arc
        raise ArgumentError if @parallel_edges
        u = edge_class[u,v]
      end
      raise ArgumentError if @parallel_edges and (u.number || 0) == 0
      return self unless @vertex_dict[u.source] # It doesn't exist
      delete_label(u) # Get rid of label
      if @parallel_edges
        index = @edge_number[u.source].index(u.number)
        raise NoArcError unless index
        @vertex_dict[u.source].delete_at(index)
        @edge_number[u.source].delete_at(index) 
      else
        @vertex_dict[u.source].delete(u.target) 
      end
      self
    end

    # Returns an array of vertices that the graph has
    def vertices() @vertex_dict.keys; end

    # Returns an array of edges, most likely of class Arc or Edge depending 
    # upon the type of graph
    def edges
      @vertex_dict.keys.inject(Set.new) do |a,v|
        if @parallel_edges and @edge_number[v]
          @vertex_dict[v].zip(@edge_number[v]).each do |w|
            s,t,n = v,w[0],w[1]
            a.add( edge_class[ s,t,n, edge_label(s,t,n) ] )
          end
        else
          @vertex_dict[v].each do |w|
            a.add(edge_class[v,w,edge_label(v,w)])
          end
        end; a
      end.to_a
    end
 
# FIXME, EFFED UP
    def adjacent(x, options={})
      options[:direction] ||= :out
      if !x.kind_of?(Graphy::Arc) and (options[:direction] == :out || !directed?)
        if options[:type] == :edges
          i = -1
          @parallel_edges ?
            @vertex_dict[x].map {|v| e=edge_class[x,v,@edge_number[x][i+=1]]; e.label = self[e]; e} :
            @vertex_dict[x].map {|v| e=edge_class[x,v];  e.label = self[e]; e}
        else
          @vertex_dict[x].to_a
        end
      else
        graph_adjacent(x,options)
      end
    end

  end # Adjacency Graph
end # Graphy
