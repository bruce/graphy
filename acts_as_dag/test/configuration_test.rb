require File.join(File.dirname(__FILE__), 'test_helper')


class UndirectedJoeEdges; end
class DirectedJoeEdges; end
class ReallyDirectedJoeEdges; end

class UndirectedJoe < ActiveRecord::Base
  set_table_name 'nodes'
  acts_as_graph :joe, :directed => false
end

class DirectedJoe < ActiveRecord::Base
  set_table_name 'nodes'
  acts_as_graph :joe
end

class ReallyDirectedJoe < ActiveRecord::Base
  set_table_name 'nodes'
  acts_as_graph :joe, :directed => true
end

class ConfigurationTest < Test::Unit::TestCase
  fixtures :nodes, :nodes_edges
  
  def test_requires_arguments_as_hash
    assert_raise(ArgumentError) do
      Class.new(ActiveRecord::Base) { acts_as_graph :jimmy, :john }
    end
  end
  
  def test_requires_relationship_name
    assert_raise(ArgumentError) do
      Class.new(ActiveRecord::Base) { acts_as_graph }  
    end
  end
  
  def test_arguments_not_required
    Class.new(ActiveRecord::Base) { acts_as_graph :joe }
  end
  
  def test_method_returns_same_graph_twice
    ar = Class.new(ActiveRecord::Base) { set_table_name 'nodes'; acts_as_graph :joe }
    assert_equal ar.joe.object_id, ar.joe.object_id
  end
  
  def test_method_returns_directed_graph_by_default
    assert DirectedJoe.joe.is_a?(GRATR::Digraph)
  end

  def test_method_returns_undirected_graph_by_request
    assert UndirectedJoe.joe.is_a?(GRATR::UndirectedGraph)
  end
  
  def test_method_returns_directed_graph_by_request
    assert ReallyDirectedJoe.joe.is_a?(GRATR::Digraph)
  end

end