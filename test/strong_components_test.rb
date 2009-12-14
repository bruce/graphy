require File.join(File.dirname(__FILE__), 'test_helper')

class TestStrongComponents < Test::Unit::TestCase # :nodoc:
  # Test from boost strong_components.cpp
  # Original Copyright 1997-2001, University of Notre Dame.
  # Original Authors: Andrew Lumsdaine, Lie-Quan Lee, Jermey G. Siek
  def test_boost
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
    assert_equal 10, g.vertices.size
    assert_equal 4, c.size
    assert c.include?(['d','e'])
    assert c.include?(['f','g'])
    assert c.include?(['j'])
    assert c.include?(['a','b','c','h','i'])
  
    cg = g.condensation
    cg_vertices = cg.map {|v| v.sort}
    assert_equal 4, cg_vertices.size
    assert cg_vertices.include?(['j'])
    assert cg_vertices.include?(['d','e'])
    assert cg_vertices.include?(['f', 'g'])
    assert cg_vertices.include?(['a', 'b', 'c', 'h', 'i'])
    assert cg.edges.map {|e| [e.source.sort.join, e.target.sort.join] }.to_a.sort ==
           [["abchi", "abchi"], ["abchi", "de"], ["abchi", "fg"], ["abchi", "j"], ["de", "de"], ["fg", "de"], ["fg", "fg"]]
  end
    

  # Figure #3, from 'Depth-First Search and Linear Graph Algorithms'
  # by Robert Tarjan, SIAM J. Comput. Vol 1, No.2, June 1972
  def test_tarjan_fig_3
    g = Digraph[ 1,2,
                 2,3, 2,8,
                 3,4, 3,7,
                 4,5,
                 5,3, 5,6,
                 7,4, 7,6,
                 8,1, 8,7 ]
                 
    c = g.strong_components.map {|x| x.sort}
    assert_equal 8, g.vertices.size
    assert_equal 3, c.size
    assert c.include?([6])
    assert c.include?([1,2,8]) 
    assert c.include?([3,4,5,7]) 
  end
end
