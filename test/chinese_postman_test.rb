require 'test/unit'
require 'graphy'
include Graphy

class TestChinesePostman < Test::Unit::TestCase # :nodoc:

  def setup  
    @simple=Digraph[ 0,1,  0,2,  1,2,  1,3,  2,3,  3,0 ]
    @weight = Proc.new {|e| 1}
  end
  
  def test_closed_simple_tour
    tour = @simple.closed_chinese_postman_tour(0, @weight)
    assert_equal 11, tour.size
    assert_equal 0, tour[0]
    assert_equal 0, tour[10]
    edges = Set.new
    0.upto(9) do |n| 
      edges << Arc[tour[n],tour[n+1]]
      assert(@simple.edge?(tour[n],tour[n+1]), "Arc(#{tour[n]},#{tour[n+1]}) from tour not in graph")
    end
    assert_equal @simple.edges.size, edges.size, "Not all arcs traversed!"
  end
  
  
end
