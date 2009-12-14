require 'test/unit'
require 'graphy'
include Graphy

class TestComplement < Test::Unit::TestCase # :nodoc:
  
  def test_square
    x = UndirectedGraph[:a,:b, :b,:c, :c,:d, :d,:a].complement
    assert_equal 2, x.edges.size
    assert x.edges.include?(Edge[:a,:c])
    assert x.edges.include?(Edge[:b,:d])
  end
  
  def test_g1
    g1 = UndirectedGraph[ :a,:b, :a,:d, :a,:e, :a,:i, :a,:g, :a,:h,
                          :b,:c, :b,:f,
                          :c,:d, :c,:h,
                          :d,:h, :d,:e,
                          :e,:f,
                          :f,:g, :f,:h, :f,:i,
                          :h,:i ].complement
    assert_equal 19, g1.edges.size
    
  end

end
