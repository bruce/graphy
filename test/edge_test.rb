require File.join(File.dirname(__FILE__), 'test_helper')

class TestArc < Test::Unit::TestCase # :nodoc:

  def setup
    @e = Arc.new(1,2,'boo')
    @u = Edge.new(1,2,'hoo')
  end

  def test_edge_new
    assert_raises(ArgumentError) {Arc.new}
    assert_raises(ArgumentError) {Arc.new(1)}
    assert Arc.new(1,2)
    assert Arc.new(1,2,'label')
  end

  def test_edge_getters

    assert_equal(1,     @e.source)
    assert_equal(2,     @e.target)
    assert_equal('boo', @e.label)

    assert_equal(1,     @e[0])
    assert_equal(2,     @e[1])
    assert_equal('boo', @e[2])

    assert_equal(1,     @e[-3])
    assert_equal(2,     @e[-2])
    assert_equal('boo', @e[-1])

    assert_raise(IndexError) {@e[-4]} 
    assert_raise(IndexError) {@e[3]}  

    assert_equal(1,     @e['source'])
    assert_equal(2,     @e['target'])
    assert_equal('boo', @e['label'])

    assert_equal(1,     @e[:source])
    assert_equal(2,     @e[:target])
    assert_equal('boo', @e[:label])
  end

  def test_edge_setters
    @e.source = 23
    @e.target = 42
    @e.label  = 'Yabba'
    assert_equal(23,     @e.source)
    assert_equal(42,     @e.target)
    assert_equal('Yabba',@e.label)

    @e['source'] = 2
    @e['target'] = 1
    @e['label']  = 'Dabba'
    assert_equal(2,      @e.source)
    assert_equal(1,      @e.target)
    assert_equal('Dabba',@e.label)

    @e[:source] = 9
    @e[:target] = 8
    @e['label'] = 'Doooo!'
    assert_equal(9,       @e.source)
    assert_equal(8,       @e.target)
    assert_equal('Doooo!',@e.label)

    @e[0] = 'Fred'
    @e[1] = 'Flintstone'
    @e[2] = 'and'
    assert_equal('Fred',      @e.source)
    assert_equal('Flintstone',@e.target)
    assert_equal('and',       @e.label)

    @e[-3] = 'Barney'
    @e[-2] = 'Rubble'
    @e[-1] = nil
    assert_equal('Barney',    @e.source)
    assert_equal('Rubble',    @e.target)
    assert_equal(nil,         @e.label)
  end

  def test_edge_simple_methods
    assert_equal([1,2,'boo'], @e.to_a)
    assert_equal("(1-2 'boo')", @e.to_s)
    @e.label = nil
    assert_equal("(1-2)", @e.to_s)
    assert(@e.eql?(Arc.new(1,2)))
    assert(!@e.eql?(Arc.new(1,3)))
    assert(!Arc.new(2,1).eql?(@e))

    assert(@e             == (Arc.new(1,2)))
    assert(@e.reverse     == (Arc.new(2,1)))
    assert(Arc.new(1,2)  != (Arc.new(1,3)))
    assert(Arc.new(2,1)  != @e)
  end

  def test_edge_sort
    x = [ Arc.new(2,3), Arc.new(1,3), Arc.new(1,2), Arc.new(2,1) ].sort
    assert_equal [Arc.new(1,2), Arc.new(1,3), Arc.new(2,1), Arc.new(2,3)], x
  end

  def test_undirected_edge_new
    assert_raises(ArgumentError) {Edge.new}
    assert_raises(ArgumentError) {Edge.new(1)}
    assert Edge.new(1,2)
    assert Edge.new(1,2,'label')
  end

  def test_undirected_edge_getters
    assert_equal(1,@u.source)
    assert_equal(2,@u.target)
    assert_equal([1,2,'hoo'],@u.to_a)
    assert_equal("(1=2 'hoo')",@u.to_s)
  end

  def test_undirected_edge_methods
    @u.label = nil
    assert_equal("(1=2)",@u.to_s)
    assert_equal("(1=2)",Edge.new(2,1).to_s)

    assert @u.eql?(Edge.new(2,1))
    assert @u == Edge.new(2,1,'boo')
    assert @u != Edge.new(2,3)

    assert_equal(@u.hash,Edge.new(2,1).hash)
  end

  def test_undirected_edge_sort
    x=[Edge.new(12, 1), Edge.new(2,11)].sort
    assert_equal [Edge.new(2,11), Edge.new(1,12)], x
  end
  
  def test_hash
    assert_equal Arc[1,2,:b], Arc[1,2,:c]
    assert_equal Arc[1,2,:b].hash, Arc[1,2,:c].hash
    assert Arc[1,2] != Arc[2,1]
    assert Arc[1,2] != Edge[1,2]
    assert_equal Edge[1,2], Edge[2,1]
    assert_equal Edge[1,2,:a], Edge[2,1,:b]
  end

end

