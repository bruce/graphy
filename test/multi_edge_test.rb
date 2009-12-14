require File.join(File.dirname(__FILE__), 'test_helper')

class TestMultiArc < Test::Unit::TestCase # :nodoc:

  def test_directed_pseudo_graph
    dpg=DirectedPseudoGraph[ :a,:b,
                             :a,:b,
                             :a,:b ]
    assert_equal 3, dpg.edges.size
    x=0
    dpg.edges.each {|e| dpg[e] = (x+=1)}
    assert_equal 6, dpg.edges.inject(0) {|a,v| a+=dpg[v]}
  end
  
  def test_directed_multi_graph
    dmg=DirectedMultiGraph[ :a,:a,
                            :a,:a,
                            :a,:b,
                            :a,:b,
                            :b,:b,
                            :b,:b ]
    assert_equal 6,  dmg.edges.size
    x = 0
    dmg.edges.each {|e| dmg[e] = (x+=1)}
    assert_equal 21, dmg.edges.inject(0) {|a,v| a+=dmg[v]}
  end
  
end
