require 'test/unit'
require 'graphy'
include Graphy

class TestInspection < Test::Unit::TestCase # :nodoc:
  
  def setup
    @dg = DirectedMultiGraph[ 
            [0,0,1]   => 1,
            [1,2,2]   => 2, 
            [1,3,3]   => 4,
            [1,4,4]   => nil, 
            [4,1,5]   => 8, 
            [1,2,6]   => 16, 
            [3,3,7]   => 32, 
            [3,3,8]   => 64     ]
    @dg[3] = 128
    @dg[0] = 256
  end
  
  def test_inspection_without_labels
    @dg = Digraph[1,2,3,4,5,6]
    reflect = eval @dg.inspect
    assert reflect == @dg
  end
  
  def test_inspection_with_labels
    inspect = @dg.inspect
    assert_equal 384, @dg.vertices.inject(0) {|a,v| a += (@dg[v] || 0)}
    assert_equal 127, @dg.edges.inject(0)    {|a,e| a += (@dg[e] || 0)}
    reflect = eval inspect
    assert reflect == @dg
    assert_equal 127, reflect.edges.inject(0)    {|a,e| a += (reflect[e] || 0)}
    assert_equal 384, reflect.vertices.inject(0) {|a,v| a += (reflect[v] || 0)}
  end

end
