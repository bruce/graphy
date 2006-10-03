require File.join(File.dirname(__FILE__), 'test_helper')

class Node < ActiveRecord::Base
  acts_as_dag
end

class ActsAsDagTest < Test::Unit::TestCase
  fixtures :nodes, :nodes_edges

  def test_in_edges
    # build a map of what the fixtures say are all edge relations
    edge_map = {}
    @loaded_fixtures['nodes_edges'].each do |f|
      (edge_map[f[1]['destination_id'].to_i] ||= []) << f[1]['source_id'].to_i
    end   

    edge_map.keys.each do |destination|
      # assert that what we have, we should have
      Node.find(destination).in_nodes.each do |source|
        assert edge_map[destination].include?(source.id), 
          "node [#{destination}] has an in_node [#{source.id}] which isn't in our fixtures."
      end                                   
      
      # and assert that what we should have, we have
      edge_map[destination].each do |source|
        assert Node.find(destination).in_nodes.detect {|n| n.id == source },
          "fixture says node [#{destination}] should have in_node [#{source}], but it isn't present.  in_nodes [#{Node.find(destination).in_nodes.inspect}]"
      end
    end
  end

  def test_out_edges  
    # build a map of what the fixtures say are all edge relations
    edge_map = {}
    @loaded_fixtures['nodes_edges'].each do |f|
      (edge_map[f[1]['source_id'].to_i] ||= []) << f[1]['destination_id'].to_i
    end   

    edge_map.keys.each do |source|
      # assert that what we have, we should have
      Node.find(source).out_nodes.each do |destination|
        assert edge_map[source].include?(destination.id), 
          "node [#{source}] has an out_node [#{destination.id}] which isn't in our fixtures."
      end                                   
      
      # and assert that what we should have, we have
      edge_map[source].each do |destination|
        assert Node.find(source).in_nodes.detect {|n| n.id == destination },
          "fixture says node [#{source}] should have out_node [#{destination}], but it isn't present.  out_nodes [#{Node.find(source).out_nodes.inspect}]"
      end
    end
  end

  def test_sinks
    assert Node.sinks.include?(nodes(:root_1))
    assert Node.sinks.include?(nodes(:root_2))
    assert_equal 2, Node.sinks.length
  end           
  
  def test_sources
    assert_equal 2, Node.sources.length
    assert Node.sources.include?(nodes(:doubly_linked_kid))
    assert Node.sources.include?(nodes(:root_1_right_child))
  end          

  def test_edges                                              
    edges = Node.edges
    assert_equal @loaded_fixtures['nodes_edges'].length, edges.length
    edge_ids = edges.inject({}) {|h,e| h["#{e[0].id}:#{e[1].id}"] = true; h}
    @loaded_fixtures['nodes_edges'].each do |f|
      assert edge_ids["#{f[1]['source_id']}:#{f[1]['destination_id']}"]
    end
  end
  
  def test_vertices   
    vertices = Node.vertices
    assert_equal @loaded_fixtures['nodes'].length, vertices.length
    @loaded_fixtures['nodes'].each do |f|
      assert vertices.include?(nodes(f[0].to_sym))
    end
  end

  def test_remove_vertex
    assert_edge(nodes(:root_2_grandchild).id, nodes(:root_2_child).id)
    assert_edge(nodes(:root_2_child).id, nodes(:root_2).id)

    assert_difference Node, :count, -1 do
      Node.remove_vertex!(nodes(:root_2_child))
    end
    
    assert_not_edge(nodes(:root_2_grandchild).id, nodes(:root_2_child).id)
    assert_not_edge(nodes(:root_2_child).id, nodes(:root_2).id)
  end
   
  def test_remove_edge_specific
    assert_edge(nodes(:root_2_grandchild).id, nodes(:root_2_child).id)

    assert_no_difference Node, :count do
      Node.remove_edge!(nodes(:root_2_grandchild), nodes(:root_2_child))
    end

    assert_not_edge(nodes(:root_2_grandchild).id, nodes(:root_2_child).id)
  end

  def test_remove_edge_general
    assert_edge(nodes(:root_2_grandchild).id, nodes(:root_2_child).id)
    assert_edge(nodes(:root_2_child).id, nodes(:root_2).id)

    assert_no_difference Node, :count do
      Node.remove_edge!(nodes(:root_2_child))
    end

    assert_not_edge(nodes(:root_2_grandchild).id, nodes(:root_2_child).id)
    assert_not_edge(nodes(:root_2_child).id, nodes(:root_2).id)
  end
     
  def test_vertex? 
    assert ! Node.vertex?(Node.new(:name => 'foo'))

    save_node = nodes(:root_1)
    assert Node.vertex?(save_node)
    save_node.destroy
    assert ! Node.vertex?(save_node)    
  end
    
  def test_edge?  
    assert Node.edge?(nodes(:root_2_child), nodes(:root_2))   # existing edge

    # at least one non-existing node    
    assert ! Node.edge?(Node.new(:name => 'foo'), nodes(:root_1))
    assert ! Node.edge?(nodes(:root_1), Node.new(:name => 'foo'))
    assert ! Node.edge?(Node.new(:name => 'foo'), Node.new(:name => 'bar'))
    assert ! Node.edge?(Node.create(:name => 'foo'), Node.create(:name => 'bar'))
    
    assert ! Node.edge?(nodes(:root_2), nodes(:root_1))  # existing nodes, no edge
    
    # make an edge
    nodes(:root_2).out_nodes(true) << nodes(:root_1)
    assert Node.edge?(nodes(:root_2), nodes(:root_1))
  end

  def test_add_edge!       
    assert_not_edge(nodes(:root_1).id, nodes(:root_2).id)
    Node.add_edge!(nodes(:root_1), nodes(:root_2))
    assert_edge(nodes(:root_1).id, nodes(:root_2).id)
  end
  
  def test_add_vertex!  
    # start with non-vertex
    assert_difference Node, :count do
      Node.add_vertex!(Node.new(:name => 'foo'))  # calls 'save' on Node
    end                                      

    # try with existing vertex
    assert_no_difference Node, :count do
      Node.add_vertex!(nodes(:root_1))
    end    
  end

  def test_descendants    
    # TODO:
  end
  
  def test_ancestors
    # TODO:
  end
end