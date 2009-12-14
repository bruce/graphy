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
require 'graphy/arc'

module Graphy
    
  # An undirected edge is simply an undirected pair (source, target) used in
  # undirected graphs. Edge[u,v] == Edge[v,u]
  class Edge < Arc

    # Equality allows for the swapping of source and target
    def eql?(other) super or (self.class == other.class and target==other.source and source==other.target); end
      
    # Alias for eql?
    alias == eql?

    # Hash is defined such that source and target can be reversed and the
    # hash value will be the same
    def hash() source.hash ^ target.hash; end

    # Sort support
    def <=>(rhs)
      [[source,target].max,[source,target].min] <=> 
      [[rhs.source,rhs.target].max,[rhs.source,rhs.target].min]
    end
    
    # Edge[1,2].to_s == "(1=2 'label)"
    def to_s
      l = label ? " '#{label.to_s}'" : ''
      s = source.to_s
      t = target.to_s
      "(#{[s,t].min}=#{[s,t].max}#{l})"
    end
    
  end
    
  class MultiEdge < Edge
    include ArcNumber
  end
  
end
