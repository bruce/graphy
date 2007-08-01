#--
# Copyright (c) 2006,2007 Shawn Patrick Garbett
# Copyright (c) 2002,2004,2005 by Horst Duchene
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'test/unit'
require 'gratr'
include GRATR
  
class TestCommunity < Test::Unit::TestCase # :nodoc:
  def setup
    @graph = Digraph[2,1, 3,1, 5,4, 6,5, 7,6, 7,2].add_vertex!(8)
  end
  
  def test_ancestors_must_return_ancestors
    assert_equal [2,3,7],     @graph.ancestors(1).sort
    assert_equal [7],         @graph.ancestors(2).sort
    assert_equal [],          @graph.ancestors(3).sort
    assert_equal [5,6,7],     @graph.ancestors(4).sort
    assert_equal [6,7],       @graph.ancestors(5).sort
    assert_equal [7],         @graph.ancestors(6).sort
    assert_equal [],          @graph.ancestors(7).sort
  end
  
  def test_descendants_must_return_descendants
    assert_equal [],          @graph.descendants(1).sort
    assert_equal [1],         @graph.descendants(2).sort
    assert_equal [1],         @graph.descendants(3).sort
    assert_equal [],          @graph.descendants(4).sort
    assert_equal [4],         @graph.descendants(5).sort
    assert_equal [4,5],       @graph.descendants(6).sort
    assert_equal [1,2,4,5,6], @graph.descendants(7).sort
  end
  
  def test_family_must_return_family
    assert_equal [2,3,4,5,6,7], @graph.family(1).sort
    assert_equal [1,3,4,5,6,7], @graph.family(2).sort
    assert_equal [1,2,4,5,6,7], @graph.family(3).sort
    assert_equal [1,2,3,5,6,7], @graph.family(4).sort
    assert_equal [1,2,3,4,6,7], @graph.family(5).sort
    assert_equal [1,2,3,4,5,7], @graph.family(6).sort
    assert_equal [1,2,3,4,5,6], @graph.family(7).sort
  end
  
end