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
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE AREf
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#++

module Graphy
  
  # This defines the minimum set of functions required to make a graph class that can
  # use the algorithms defined by this library
  module GraphAPI
    
    # Each implementation module must implement the following routines
    #   * directed?()   # Is the graph directed?
    #   * add_vertex!(v,l=nil) # Add a vertex to the graph and return the graph, l is an optional label
    #   * add_edge!(u,v=nil,l=nil) # Add an edge to the graph and return the graph. u can be an Arc or Edge or u,v is an edge pair. last parameter is an optional label
    #   * remove_vertex!(v) # Remove a vertex to the graph and return the graph
    #   * remove_edge!(u,v=nil) # Remove an edge from the graph and return the graph
    #   * vertices()  # Returns an array of of all vertices
    #   * edges() # Returns an array of all edges
    #   * edge_class() # Returns the class used to store edges
    def self.included(klass)
       [:directed?,:add_vertex!,:add_edge!,:remove_vertex!,:remove_edge!,:vertices,:edges,:edge_class].each do |meth| 
         raise "Must implement #{meth}" unless klass.instance_methods.include?(meth.to_s)
       end
       
       klass.class_eval do
         # Is this right?
         alias remove_arc! remove_edge!
         alias add_arc!    add_edge!
         alias arcs        edges
         alias arc_class   edge_class
       end
    end
  end
end
