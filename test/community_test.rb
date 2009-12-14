require File.join(File.dirname(__FILE__), 'test_helper')
  
class TestCommunity < Test::Unit::TestCase # :nodoc:
  def setup
    @graph = Digraph[2,1, 3,1, 5,4, 6,5, 7,6, 7,2].add_vertex!(8)
  end
  
  def test_ancestors_must_return_ancestors
    assert_equal [2,3,7],     @graph.ancestors(1).sort
    assert_equal [7],         @graph.ancestors(2).sort
    assert_equal [],          @graph.ancestors(3).sort
    assert_equal [5,6,7],     @graph.ancestors(4).sort
    assert_equal [6,7],       @graph.ancestors(5).sort
    assert_equal [7],         @graph.ancestors(6).sort
    assert_equal [],          @graph.ancestors(7).sort
  end
  
  def test_descendants_must_return_descendants
    assert_equal [],          @graph.descendants(1).sort
    assert_equal [1],         @graph.descendants(2).sort
    assert_equal [1],         @graph.descendants(3).sort
    assert_equal [],          @graph.descendants(4).sort
    assert_equal [4],         @graph.descendants(5).sort
    assert_equal [4,5],       @graph.descendants(6).sort
    assert_equal [1,2,4,5,6], @graph.descendants(7).sort
  end
  
  def test_family_must_return_family
    assert_equal [2,3,4,5,6,7], @graph.family(1).sort
    assert_equal [1,3,4,5,6,7], @graph.family(2).sort
    assert_equal [1,2,4,5,6,7], @graph.family(3).sort
    assert_equal [1,2,3,5,6,7], @graph.family(4).sort
    assert_equal [1,2,3,4,6,7], @graph.family(5).sort
    assert_equal [1,2,3,4,5,7], @graph.family(6).sort
    assert_equal [1,2,3,4,5,6], @graph.family(7).sort
  end
  
end
