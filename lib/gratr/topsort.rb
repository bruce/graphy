#--
# Copyright (c) 2006 Shawn Patrick Garbett
# Copyright (c) 2002,2004,2005 by Horst Duchene
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


module GRATR
  module Graph

    # Topological Sort Iterator
    #
    # The topological sort algorithm creates a linear ordering of the vertices
    # such that if edge (u,v) appears in the graph, then u comes before v in
    # the ordering. The graph must be a directed acyclic graph (DAG).
    #
    # The iterator can also be applied to undirected graph or to a DG graph
    # which contains a cycle.  In this case, the Iterator does not reach all
    # vertices.  The implementation of acyclic? and cyclic? uses this fact.
    #
    # Can be called with a block as a standard Ruby iterator, or it can
    # be used directly as it will return the result as an Array
    def topsort(start = nil, &block)
      result  = []
      go      = true 
      back    = Proc.new {|e| go = false } 
      push    = Proc.new {|v| result.unshift(v) if go}
      start   ||= vertices[0]
      dfs({:exit_vertex => push, :back_edge => back, :start => start})
      result.each {|v| block.call(v)} if block; result
    end

    # Returns true if a graph contains no cycles, false otherwise
    def acyclic?() topsort.size == size; end

    # Returns false if a graph contains no cycles, true otherwise
    def cyclic?()  not acyclic?; end

  end
end
