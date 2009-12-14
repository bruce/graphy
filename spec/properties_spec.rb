
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'graphy/dot'

# This test runs the classes from Appendix F in 
# _Algorithmic_Graph_Theory_and_Perfect_Graphs,
# by Martin Charles Golumbic
describe "Properties" do # :nodoc:

  describe "g1" do
    it do
      g1 = UndirectedGraph[ :a,:b, :a,:d, :a,:e, :a,:i, :a,:g, :a,:h,
                            :b,:c, :b,:f,
                            :c,:d, :c,:h,
                            :d,:h, :d,:e,
                            :e,:f,
                            :f,:g, :f,:h, :f,:i,
                            :h,:i ]

      g1.should_not be_triangulated
      g1.complement.should_not be_triangulated  # Disagrees with Golumbic!
      g1.should_not be_comparability
      g1.complement.should_not be_comparability
      g1.should_not be_interval
      g1.complement.should_not be_interval
      g1.should_not be_permutation
      g1.should_not be_split
      
      #    g1.write_to_graphic_file('jpg','g1')
      #    g1.complement.write_to_graphic_file('jpg','g1_complement')
    end
  end
  
  describe "g2" do
    it do
      g2 = UndirectedGraph[ :a,:b, :a,:e,
                            :b,:c, :b,:e, :b,:f,
                            :c,:d, :c,:f, :c,:g,
                            :d,:g,
                            :e,:f,
                            :f,:g]
      
      g2.should be_triangulated
      g2.complement.should_not be_triangulated
      g2.should_not be_comparability
      g2.complement.should be_comparability
      g2.should be_interval
      g2.complement.should_not be_interval
      g2.should_not be_permutation
      g2.should_not be_split
    end
  end
  
  describe "g3" do
    it do
      g3 = UndirectedGraph[ :a,:c,
                            :b,:e,
                            :c,:d, :c,:f,
                            :d,:f, :d,:g, :d,:e,
                            :e,:g,
                            :f,:g ]
      g3.should be_triangulated
      g3.complement.should_not be_triangulated
      g3.should_not be_comparability
      g3.complement.should be_comparability
      g3.should be_interval
      g3.complement.should_not be_interval
      g3.should_not be_permutation
      g3.should_not be_split
    end
  end

  describe "g4" do
    it do
      g4 = UndirectedGraph[ :a,:b,
                            :b,:c,
                            :c,:d, :c,:e,
                            :d,:f,
                            :e,:g]
      g4.should be_triangulated
      g4.complement.should_not be_triangulated
      g4.should be_comparability
      g4.complement.should_not be_comparability
      g4.should_not be_interval
      g4.complement.should_not be_interval
      g4.should_not be_permutation
      g4.should_not be_split
    end
  end

  describe "g5" do
    it do
      g5 = UndirectedGraph[ :a,:b, :a,:c,
                            :b,:c, :b,:d, :b,:f, :b,:g,
                            :c,:e, :c,:f, :c,:g,
                            :d,:f,
                            :e,:g,
                            :f,:g]
      g5.should be_triangulated
      g5.complement.should be_triangulated
      g5.should be_comparability
      g5.complement.should_not be_comparability
      g5.should_not be_interval
      g5.complement.should be_interval
      g5.should_not be_permutation
      g5.should be_split
    end
  end
  
  describe "g6" do
    it do
      g6 = UndirectedGraph[ :a,:c, :a,:d,
                            :b,:c,
                            :c,:f,
                            :d,:e, :d,:f]
      g6.should_not be_triangulated
      g6.complement.should_not be_triangulated
      g6.should be_comparability
      g6.complement.should be_comparability
      g6.should_not be_interval
      g6.complement.should_not be_interval
      g6.should be_permutation
      g6.should_not be_split
    end
  end
  
  describe "g7" do
    it do
      g7 = UndirectedGraph[ :a,:b, :a,:c,
                            :b,:c, :b,:d, :b,:e,
                            :c,:e, :c,:f,
                            :d,:e,
                            :e,:f]
      g7.should be_triangulated
      g7.complement.should be_triangulated
      g7.should_not be_comparability
      g7.complement.should_not be_comparability
      g7.should_not be_interval
      g7.complement.should_not be_interval
      g7.should_not be_permutation
      g7.should be_split
    end
    
  end
  
end
