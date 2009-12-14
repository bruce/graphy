Graph Theory Library for Ruby
=============================

A framework for graph data structures and algorithms.

This library is based on [GRATR][1] (itself a fork of [RGL][2]).

Graph algorithms currently provided are:

* Topological Sort
* Strongly Connected Components 
* Transitive Closure
* Rural Chinese Postman
* Biconnected

These are based on more general algorithm patterns:

* Breadth First Search 
* Depth First Search 
* A* Search
* Floyd-Warshall
* Best First Search
* Djikstra's Algorithm
* Lexicographic Search

The Tour
--------

### Arcs

There are two Arc classes, `Graph::Arc` and `Graph::Edge`.

## Graph Types

There are a number of different graph types, each of which provide
different features and constraints:

`Graph::Digraph` and it's pseudonym `Graph::DirectedGraph`:

* Single directed edges between vertices
* Loops are forbidden

`Graph::DirectedPseudoGraph`:

* Multiple directed edges between vertices
* Loops are forbidden

`Graph::DirectedMultiGraph`:

* Multiple directed edges between vertices
* Loops on vertices

`Graph::UndirectedGraph`, `Graph::UndirectedPseudoGraph`, and
`Graph::UndirectedMultiGraph` are similar but all edges are undirected.

## Data Structures

Use the `Graph::AdjacencyGraph` module provides a generalized adjacency
list and an edge list adaptor.

The `Graph::Digraph` class is the general purpose "swiss army knife" of graph
classes, most of the other classes are just modifications to this class.
It is optimized for efficient access to just the out-edges, fast vertex
insertion and removal at the cost of extra space overhead, etc.

Example Usage
-------------

Require the library:

    require 'graph'

If you'd like to include all the classes in the current scope (so you
don't have to prefix with `Graph::`), just:

    include Graph

Let's play with the library a bit in IRB:

    >> dg = Digraph[1,2, 2,3, 2,4, 4,5, 6,4, 1,6]
    => Graph::Digraph[[2, 3], [1, 6], [2, 4], [4, 5], [1, 2], [6, 4]] 

A few properties of the graph 

    >> dg.directed?
    => true
    >> dg.vertex?(4)
    => true
    >> dg.edge?(2,4)
    => true
    >> dg.edge?(4,2)
    => false
    >> dg.vertices
    => [5, 6, 1, 2, 3, 4]

Every object could be a vertex, even the class object `Object`:

    >> dg.vertex?(Object)
    => false
    >> UndirectedGraph.new(dg).edges.sort.to_s
    => "(1=2)(2=3)(2=4)(4=5)(1=6)(4=6)"

Add inverse edge `(4-2)` to directed graph:

    >> dg.add_edge!(4,2)
    => GRATR::Digraph[[2, 3], [1, 6], [4, 2], [2, 4], [4, 5], [1, 2], [6, 4]]
  
`(4-2) == (2-4)` in the undirected graph:

    >> UndirectedGraph.new(dg).edges.sort.to_s
    => "(1=2)(2=3)(2=4)(4=5)(1=6)(4=6)"

`(4-2) != (2-4)` in directed graphs:

    >> dg.edges.sort.to_s
    => "(1-2)(1-6)(2-3)(2-4)(4-2)(4-5)(6-4)"
    >> dg.remove_edge! 4,2
    => GRATR::Digraph[[2, 3], [1, 6], [2, 4], [4, 5], [1, 2], [6, 4]] 

Topological sorting is realized with an iterator:

    >> dg.topsort         
    => [1, 2, 3, 6, 4, 5]
    >> y = 0; dg.topsort { |v| y += v }; y
    => 21

You can use DOT to visualize the graph:

    >> require 'graph/dot'
    >> dg.write_to_graphic_file('jpg','visualize')

Here's an example showing the module inheritance hierarchy:

    >> module_graph = Digraph.new
    >> ObjectSpace.each_object(Module) do |m|
    >>   m.ancestors.each {|a| module_graph.add_edge!(m,a) if m != a} 
    >> end
    >> gv = module_graph.vertices.select {|v| v.to_s.match(/Graph/) }
    >> module_graph.induced_subgraph(gv).write_to_graphic_file('jpg','module_graph')

Look for more in the examples directory.
 
History
-------

This library is based on [GRATR][1] by Shawn Garbett (itself a fork of
Horst Duchene's RGL library) which is heavily influenced by the Boost
Graph Library (BGL).

This fork attempts to modernize and extend the API and tests.

References
----------

For more information on Graph Theory, you may want to read:

* The [documentation][3] for the Boost Graph Library
* [The Dictionary of Algorithms and Data Structures][4]

== Credits

See CREDITS.markdown

== TODO

See TODO.markdown

== CHANGELOG

See CHANGELOG.markdown

== License

See LICENSE

[1]: http://gratr.rubyforge.org
[2]: http://rgl.rubyforge.org
[3]: http://www.boost.org/libs/graph/doc
[4]: http://www.nist.gov/dads/HTML/graph.html
