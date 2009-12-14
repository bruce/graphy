Credits
=======

From GRATR
----------

Shawn Garbett provided the following credits in GRATR:

Many thanks to Robert Feldt which also worked on a graph library
(http://rockit.sf.net/subprojects/graphr) who pointed me to BGL and many other
graph resources. Manuel Simoni found a subtle bug in a preliminary version
announced at http://rubygarden.com/ruby?RubyAlgorithmPackage/Graph.

Robert kindly allowed to integrate his work on graphr, which I did not yet
succeed. Especially his work to output graphs for
GraphViz[http://www.research.att.com/sw/tools/graphviz/download.html] is much
more elaborated than the minimal support in dot.rb.

Jeremy Siek one of the authors of the nice book "The Boost Graph Library (BGL)"
(http://www.boost.org/libs/graph/doc) kindly allowed to use the
BGL documentation as a _cheap_ reference for GRATR. He and Robert also gave
feedback and many ideas for GRATR.

Dave Thomas for RDoc[http://rdoc.sourceforge.net] which generated what you read
and Matz for Ruby. Dave included in the latest version of RDoc (alpha9) the
module dot/dot.rb which I use instead of Roberts module to visualize graphs
(see gratr/dot.rb).

Horst Duchene for RGL which provided the basis for this library and his vision.

Rick Bradley who reworked the library and added many graph theoretic constructs.
