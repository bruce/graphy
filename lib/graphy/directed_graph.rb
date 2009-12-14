#--
# Copyright (c) 2006,2007 Shawn Patrick Garbett
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
module Graphy
  
  class DirectedGraph < Graph
    
    autoload :Algorithms, "graphy/directed_graph/algorithms"
    autoload :Distance, "graphy/directed_graph/distance"    
    
    def initialize(*params)
      args = (params.pop if params.last.kind_of? Hash) || {}
      args[:algorithmic_category] = DirectedGraph::Algorithms    
      super *(params << args)
    end
  end
  
  # DirectedGraph is just an alias for Digraph should one desire
  Digraph = DirectedGraph

  # This is a Digraph that allows for parallel edges, but does not
  # allow loops
  class DirectedPseudoGraph < DirectedGraph
    def initialize(*params)
      args = (params.pop if params.last.kind_of? Hash) || {}
      args[:parallel_edges] = true
      super *(params << args)
    end 
  end

  # This is a Digraph that allows for parallel edges and loops
  class DirectedMultiGraph < DirectedPseudoGraph
    def initialize(*params)
      args = (params.pop if params.last.kind_of? Hash) || {}
      args[:loops] = true
      super *(params << args)
    end 
  end

end
