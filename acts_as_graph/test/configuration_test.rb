#--
# Copyright (c) 2007 Shawn Garbett
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice(s),
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of the Shawn Garbett nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#++
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