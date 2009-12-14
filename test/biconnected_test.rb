require File.join(File.dirname(__FILE__), 'test_helper')

class TestBiconnected < Test::Unit::TestCase # :nodoc:
  def test_tarjan
    tarjan = UndirectedGraph[ 1, 2,
                              1, 5,
                              1, 6, 
                              1, 7,
                              2, 3, 
                              2, 4,
                              3, 4,
                              2, 5,
                              5, 6,
                              7, 8,
                              7, 9,
                              8, 9 ]
    graphs, articulations = tarjan.biconnected
    assert_equal [1,2,7], articulations.sort
    assert_equal 4, graphs.size
    assert_equal [1,7],     graphs.find {|g| g.size == 2}.vertices.sort
    assert_equal [1,2,5,6], graphs.find {|g| g.size == 4}.vertices.sort
    assert_equal [2,3,4],   graphs.find {|g| g.size == 3 && g.vertex?(2)}.vertices.sort
    assert_equal [7,8,9],   graphs.find {|g| g.size == 3 && g.vertex?(7)}.vertices.sort
  end
end
