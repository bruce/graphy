require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Strong Components" do # :nodoc:
  
  # Test from boost strong_components.cpp
  # Original Copyright 1997-2001, University of Notre Dame.
  # Original Authors: Andrew Lumsdaine, Lie-Quan Lee, Jermey G. Siek
  describe "boost" do
    it do
      g = Digraph[ 'a', 'b',  'a', 'f',  'a', 'h',
                   'b', 'c',  'b', 'a',
                   'c', 'd',  'c', 'b',
                   'd', 'e',
                   'e', 'd',
                   'f', 'g',
                   'g', 'f',  'g', 'd',
                   'h', 'i',
                   'i', 'h',  'i', 'j',  'i', 'e',  'i', 'c']

      c = g.strong_components.map {|x| x.sort}
      g.vertices.size.should == 10
      c.size.should == 4
      c.should include(['d','e'])
      c.should include(['f','g'])
      c.should include(['j'])
      c.should include(['a','b','c','h','i'])
      
      cg = g.condensation
      cg_vertices = cg.map {|v| v.sort}
      cg_vertices.size.should == 4
      cg_vertices.should include(['j'])
      cg_vertices.should include(['d','e'])
      cg_vertices.should include(['f', 'g'])
      cg_vertices.should include(['a', 'b', 'c', 'h', 'i'])
      cg.edges.map {|e| [e.source.sort.join, e.target.sort.join] }.to_a.sort.should ==
        [["abchi", "abchi"], ["abchi", "de"], ["abchi", "fg"], ["abchi", "j"], ["de", "de"], ["fg", "de"], ["fg", "fg"]]
    end
  end
  

  # Figure #3, from 'Depth-First Search and Linear Graph Algorithms'
  # by Robert Tarjan, SIAM J. Comput. Vol 1, No.2, June 1972
  describe "tarjan_fig_3" do
    it do
      g = Digraph[ 1,2,
                   2,3, 2,8,
                   3,4, 3,7,
                   4,5,
                   5,3, 5,6,
                   7,4, 7,6,
                   8,1, 8,7 ]
      
      c = g.strong_components.map {|x| x.sort}
      g.vertices.size.should == 8
      c.size.should == 3
      c.should include([6])
      c.should include([1,2,8]) 
      c.should include([3,4,5,7])
    end
  end
end
