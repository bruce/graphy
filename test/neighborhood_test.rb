require 'test/unit'
require 'graphy'
include Graphy

class TestNeighborhood < Test::Unit::TestCase # :nodoc:
  
  def setup
    @d = Digraph[:a,:b, :a,:f,
                 :b,:g,
                 :c,:b, :c,:g,
                 :d,:c, :d,:g,
                 :e,:d,
                 :f,:e, :f,:g,
                 :g,:a, :g,:e]
    @w = [:a,:b]
  end
  
  def test_open_out_neighborhood
    assert_equal [:g], @d.set_neighborhood([:a],    :in)
    assert_equal [],   [:f,:g]  - @d.set_neighborhood(@w, :out)
    assert_equal [],   @w       - @d.open_pth_neighborhood(@w, 0, :out)
    assert_equal [],   [:f, :g] - @d.open_pth_neighborhood(@w, 1, :out)
    assert_equal [],   [:e]     - @d.open_pth_neighborhood(@w, 2, :out)
    assert_equal [],   [:d]     - @d.open_pth_neighborhood(@w, 3, :out)
    assert_equal [],   [:c]     - @d.open_pth_neighborhood(@w, 4, :out)    
  end
  
  def test_closed_out_neighborhood
    assert_equal [],   @w                     - @d.closed_pth_neighborhood(@w, 0, :out)
    assert_equal [],   [:a,:b,:f,:g]          - @d.closed_pth_neighborhood(@w, 1, :out)
    assert_equal [],   [:a,:b,:e,:f,:g]       - @d.closed_pth_neighborhood(@w, 2, :out)
    assert_equal [],   [:a,:b,:d,:e,:f,:g]    - @d.closed_pth_neighborhood(@w, 3, :out)
    assert_equal [],   [:a,:b,:c,:d,:e,:f,:g] - @d.closed_pth_neighborhood(@w, 4, :out)    
  end
  
  
end
