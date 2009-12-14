module Graphy

  # Biconnected is a module for adding the biconnected algorithm to 
  # UndirectedGraphs
  module Biconnected

    # biconnected computes the biconnected subgraphs
    # of a graph using Tarjan's algorithm based on DFS. See: Robert E. Tarjan
    # _Depth_First_Search_and_Linear_Graph_Algorithms_. SIAM Journal on 
    # Computing, 1(2):146-160, 1972
    #
    # The output of the algorithm is a pair, the first value is an 
    # array of biconnected subgraphs. The second is the set of
    # articulation vertices.
    #
    # A connected graph is biconnected if the removal of any single vertex 
    # (and all edges incident on that vertex) cannot disconnect the graph.
    # More generally, the biconnected components of a graph are the maximal
    # subsets of vertices such that the removal of a vertex from a particular
    # component will not disconnect the component. Unlike connected components,
    # vertices may belong to multiple biconnected components: those vertices
    # that belong to more than one biconnected component are called articulation
    # points or, equivalently, cut vertices. Articulation points are vertices
    # whose removal would increase the number of connected components in the graph.
    # Thus, a graph without articulation points is biconnected.
    def biconnected
      dfs_num     = 0
      number      = {}; predecessor = {}; low_point   = {}
      stack       = []; result      = []; articulation= []

      root_vertex  = Proc.new {|v| predecessor[v]=v }
      enter_vertex = Proc.new {|u| number[u]=low_point[u]=(dfs_num+=1) }
      tree_edge  = Proc.new do |e|
        stack.push(e)
        predecessor[e.target] = e.source
      end
      back_edge  = Proc.new do |e|
        if e.target != predecessor[e.source]
          stack.push(e)
          low_point[e.source] = [low_point[e.source], number[e.target]].min
        end
      end
      exit_vertex = Proc.new do |u|
        parent = predecessor[u]
        is_articulation_point = false
        if number[parent] > number[u]
          parent = predecessor[parent]
          is_articulation_point = true
        end
        if parent == u
          is_articulation_point = false if (number[u] + 1) == number[predecessor[u]]
        else
          low_point[parent] = [low_point[parent], low_point[u]].min
          if low_point[u] >= number[parent]
            if number[parent] > number[predecessor[parent]]
              predecessor[u] = predecessor[parent]
              predecessor[parent] = u
            end
            result << (component = self.class.new)
            while number[stack[-1].source] >= number[u]
              component.add_edge!(stack.pop)
            end
            component.add_edge!(stack.pop)
            if stack.empty?
              predecessor[u] = parent
              predecessor[parent] = u
            end
          end
        end
        articulation << u if is_articulation_point
      end

      # Execute depth first search
      dfs({:root_vertex  => root_vertex,
           :enter_vertex => enter_vertex, 
           :tree_edge    => tree_edge,
           :back_edge    => back_edge,
           :exit_vertex  => exit_vertex})
         
      [result, articulation]
    end # biconnected

  end # Biconnected
end # Graphy
