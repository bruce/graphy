require File.join(File.dirname(__FILE__), 'test_helper')

class TestDot < Test::Unit::TestCase # :nodoc:
  
  DG_DOT = <<-DOT
digraph  {
    label = "Datacenters"
    Miranda [
        color = green,
        style = filled,
        label = "Miranda"
    ]

    Miranda -> Hillview [

    ]

    Miranda -> "San Francisco" [

    ]

    Miranda -> "San Jose" [

    ]

    Sunnyvale -> Miranda [

    ]

}
DOT
  
  def setup
    @dg = DOT::DOTDigraph.new('label' => 'Datacenters')
    @dg << DOT::DOTNode.new('name' => 'Miranda', 'color' => 'green', 'style' => 'filled')
    @dg << DOT::DOTDirectedArc.new('from' => 'Miranda', 'to' => 'Hillview')
    @dg << DOT::DOTDirectedArc.new('from' => 'Miranda', 'to' => '"San Francisco"')
    @dg << DOT::DOTDirectedArc.new('from' => 'Miranda', 'to' => '"San Jose"')
    @dg << DOT::DOTDirectedArc.new('from' => 'Sunnyvale', 'to' => 'Miranda')
  end
  
  def test_generation
    assert @dg.to_s
    assert_equal DG_DOT, @dg.to_s
  end
  
end
