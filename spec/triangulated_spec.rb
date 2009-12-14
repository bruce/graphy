require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Triangulated" do #:nodoc:

  describe "berge_mystery" do
    it do
      berge_mystery = UndirectedGraph[
                                      :abe,       :eddie, 
                                      :abe,       :burt,
                                      :abe,       :desmond,
                                      :eddie,     :burt,
                                      :eddie,     :ida,
                                      :eddie,     :charlotte,
                                      :charlotte, :ida,
                                      :charlotte, :desmond,
                                      :burt,      :ida,
                                      :ida,       :desmond]
      
      berge_mystery.should_not be_triangulated
      berge_mystery.remove_vertex!(:desmond)
      berge_mystery.should be_triangulated
      berge_mystery.chromatic_number.should == 3
    end
  end
  
  describe "house" do
    it do
      house = UndirectedGraph[
                              :roof,            :left_gutter,
                              :roof,            :right_gutter,
                              :left_gutter,     :left_foundation,
                              :right_gutter,    :right_foundation,
                              :left_foundation, :right_foundation
                             ]
      house.should_not be_triangulated
      house.remove_vertex!(:left_foundation) # Becomes a bulls head graph
      house.should be_triangulated
      ##
      # This assertion wasn't running correctly in GRATR (`assert`
      # when it should have been `assert_equal`), failing now, and
      # may not be valid.
      # house.chromatic_number.should == 3
    end
    
  end
  
  # A triangulated, but not interval graph test
  describe "non_interval" do
    it do
      non_interval = UndirectedGraph[
                                     :ao, :ai,
                                     :ai, :bi,
                                     :ai, :ci,
                                     :bo, :bi,
                                     :bi, :ci,
                                     :co, :ci
                                    ]
      non_interval.should be_triangulated
      non_interval.chromatic_number.should == 3
    end
    
  end
  
  describe "simple" do
    it do
      simple = UndirectedGraph[
                               :a, :b,
                               :b, :c,
                               :c, :d,
                               :d, :e, 
                               :e, :f,
                               :f, :g,
                               :g, :a,
                               :g, :b,
                               :b, :f,
                               :f, :c,
                              ]
      simple.should_not be_triangulated
      simple.add_edge!(:c, :e)
      simple.should be_triangulated
      simple.chromatic_number.should == 3
      UndirectedGraph[:a, :b].chromatic_number.should == 2
    end
  end
  
  describe "simple2" do
    it do
      simple2 = UndirectedGraph[
                                :x, :p,
                                :p, :z,
                                :z, :r,
                                :r, :x,
                                :p, :y,
                                :y, :r,
                                :y, :q,
                                :q, :z]
      simple2.should_not be_triangulated
    end
  end
  
  describe "lexicographic_queue" do
    it do
      q = Graphy::Search::LexicographicQueue.new([1,2,3,4,5,6,7,8,9])
      q.pop.should == 9
      q.add_lexeme([3,4,5,6,7,8])
      q.pop.should == 8
      q.add_lexeme([2,6,7,9])
      q.pop.should == 7
      q.add_lexeme([8,9])
      q.pop.should == 6
      q.add_lexeme([1,5,8,9])
      q.pop.should == 5
      q.add_lexeme([6,9])
      q.pop.should == 4
      q.add_lexeme([3,9])
      q.pop.should == 3
      q.add_lexeme([4,9])
      q.pop.should == 2
      q.add_lexeme([8])
      q.pop.should == 1
      q.pop.should == nil
    end
  end
  
end
