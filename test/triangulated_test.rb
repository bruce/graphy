require File.join(File.dirname(__FILE__), 'test_helper')

class TestTriagulated < Test::Unit::TestCase #:nodoc:

  def test_berge_mystery
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
                      
    assert !berge_mystery.triangulated?
    berge_mystery.remove_vertex!(:desmond)
    assert berge_mystery.triangulated?
    
    assert 3, berge_mystery.chromatic_number
  end
  
  def test_house
    house = UndirectedGraph[
              :roof,            :left_gutter,
              :roof,            :right_gutter,
              :left_gutter,     :left_foundation,
              :right_gutter,    :right_foundation,
              :left_foundation, :right_foundation
            ]
    assert !house.triangulated?
    house.remove_vertex!(:left_foundation) # Becomes a bulls head graph
    assert house.triangulated?
    assert 3, house.chromatic_number
  end
  
  # A triangulated, but not interval graph test
  def test_non_interval
    non_interval = UndirectedGraph[
                     :ao, :ai,
                     :ai, :bi,
                     :ai, :ci,
                     :bo, :bi,
                     :bi, :ci,
                     :co, :ci
                   ]
    assert non_interval.triangulated?
    assert 3, non_interval.chromatic_number
  end
  
  def test_simple
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
    assert !simple.triangulated?
    simple.add_edge!(:c, :e)
    assert simple.triangulated?
    assert 3, simple.chromatic_number
    assert 2, UndirectedGraph[:a, :b].chromatic_number
  end
  
  def test_simple2
    simple2 = UndirectedGraph[
                :x, :p,
                :p, :z,
                :z, :r,
                :r, :x,
                :p, :y,
                :y, :r,
                :y, :q,
                :q, :z]
    assert !simple2.triangulated?
  end
  
  def test_lexicographic_queue
    q = Graphy::Search::LexicographicQueue.new([1,2,3,4,5,6,7,8,9])
    assert_equal 9, q.pop
    q.add_lexeme([3,4,5,6,7,8])
    assert_equal 8, q.pop
    q.add_lexeme([2,6,7,9])
    assert_equal 7, q.pop
    q.add_lexeme([8,9])
    assert_equal 6, q.pop
    q.add_lexeme([1,5,8,9])
    assert_equal 5, q.pop
    q.add_lexeme([6,9])
    assert_equal 4, q.pop
    q.add_lexeme([3,9])
    assert_equal 3, q.pop
    q.add_lexeme([4,9])
    assert_equal 2, q.pop
    q.add_lexeme([8])
    assert_equal 1, q.pop
    assert_equal nil, q.pop
  end
  
end
