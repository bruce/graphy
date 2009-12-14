
require File.join(File.dirname(__FILE__), 'test_helper')
require 'graphy/dot'

# This test runs the classes from Appendix F in 
# _Algorithmic_Graph_Theory_and_Perfect_Graphs,
# by Martin Charles Golumbic
class TestProperties < Test::Unit::TestCase # :nodoc:

  def test_g1
    g1 = UndirectedGraph[ :a,:b, :a,:d, :a,:e, :a,:i, :a,:g, :a,:h,
                          :b,:c, :b,:f,
                          :c,:d, :c,:h,
                          :d,:h, :d,:e,
                          :e,:f,
                          :f,:g, :f,:h, :f,:i,
                          :h,:i ]

    assert !g1.triangulated?
    assert !g1.complement.triangulated?  # Disagrees with Golumbic!
    assert !g1.comparability?
    assert !g1.complement.comparability?
    assert !g1.interval?
    assert !g1.complement.interval?
    assert !g1.permutation?
    assert !g1.split?
    
#    g1.write_to_graphic_file('jpg','g1')
#    g1.complement.write_to_graphic_file('jpg','g1_complement')
  end
  
  def test_g2
    g2 = UndirectedGraph[ :a,:b, :a,:e,
                          :b,:c, :b,:e, :b,:f,
                          :c,:d, :c,:f, :c,:g,
                          :d,:g,
                          :e,:f,
                          :f,:g]
    
    assert g2.triangulated?
    assert !g2.complement.triangulated?
    assert !g2.comparability?
    assert g2.complement.comparability?
    assert g2.interval?
    assert !g2.complement.interval?
    assert !g2.permutation?
    assert !g2.split?
  end
  
  def test_g3
    g3 = UndirectedGraph[ :a,:c,
                          :b,:e,
                          :c,:d, :c,:f,
                          :d,:f, :d,:g, :d,:e,
                          :e,:g,
                          :f,:g ]
    assert g3.triangulated?
    assert !g3.complement.triangulated?
    assert !g3.comparability?
    assert g3.complement.comparability?
    assert g3.interval?
    assert !g3.complement.interval?
    assert !g3.permutation?
    assert !g3.split?
  end

  def test_g4
    g4 = UndirectedGraph[ :a,:b,
                          :b,:c,
                          :c,:d, :c,:e,
                          :d,:f,
                          :e,:g]
    assert g4.triangulated?
    assert !g4.complement.triangulated?
    assert g4.comparability?
    assert !g4.complement.comparability?
    assert !g4.interval?
    assert !g4.complement.interval?
    assert !g4.permutation?
    assert !g4.split?
  end

  def test_g5
    g5 = UndirectedGraph[ :a,:b, :a,:c,
                          :b,:c, :b,:d, :b,:f, :b,:g,
                          :c,:e, :c,:f, :c,:g,
                          :d,:f,
                          :e,:g,
                          :f,:g]
    assert g5.triangulated?
    assert g5.complement.triangulated?
    assert g5.comparability?
    assert !g5.complement.comparability?
    assert !g5.interval?
    assert g5.complement.interval?
    assert !g5.permutation?
    assert g5.split?
  end
    
  def test_g6
    g6 = UndirectedGraph[ :a,:c, :a,:d,
                          :b,:c,
                          :c,:f,
                          :d,:e, :d,:f]
    assert !g6.triangulated?
    assert !g6.complement.triangulated?
    assert g6.comparability?
    assert g6.complement.comparability?
    assert !g6.interval?
    assert !g6.complement.interval?
    assert g6.permutation?
    assert !g6.split?
  end
  
  def test_g7
    g7 = UndirectedGraph[ :a,:b, :a,:c,
                          :b,:c, :b,:d, :b,:e,
                          :c,:e, :c,:f,
                          :d,:e,
                          :e,:f]
    assert g7.triangulated?
    assert g7.complement.triangulated?
    assert !g7.comparability?
    assert !g7.complement.comparability?
    assert !g7.interval?
    assert !g7.complement.interval?
    assert !g7.permutation?
    assert g7.split?
    
  end
  
end
