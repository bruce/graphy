#--
# Copyright (c) 2006 Rick Bradley
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
module ActiveRecord
  module Acts #:nodoc:
    module Graph #:nodoc:
      module Implementation #:nodoc:
 
        # Initialization parameters can include an Array of edges to add, Graphs to
        # copy (will merge if multiple)
        # :parallel_edges denotes that duplicate edges are allowed
        # :loops denotes that loops are allowed
        def implementation_initialize(*params)
          args = (params.pop if params.last.kind_of? Hash) || {}
          
          raise NotImplementedError if params.any? {|p| p.kind_of?(GRATR::Graph) || p.kind_of?(Array)}
         end

        # Returns true if v is a vertex of this Graph
        # An O(1) implementation of vertex?
        def vertex?(v)
          @config[:ar_object].find(v.id)
          true
        rescue Exception => e
          false
        end

        # Returns true if [u,v] or u is an Arc
        # An O(1) implementation 
        def edge?(u, v=nil)
          u, v = u.source, u.target if u.kind_of? GRATR::Arc
          !ar_edges_class.find(:first, :conditions => ["#{@config[:in]}_id = ? and #{@config[:out]}_id = ?", u.id, v.id]).nil?
        end

        def add_vertex!(vertex, label=nil)
          raise NotImplementedError, "Use ActiveRecord::Base methods on main object"        
        end

        def add_edge!(u, v=nil, l=nil, n=nil)
          raise NotImplementedError, "Use ActiveRecord::Base methods on main object"        
        end

        # Probably better to use active record for this
        def remove_vertex!(v)
          raise NotImplementedError, "Use ActiveRecord::Base methods on main object"        
        end

        # Probably better to use active record for this
        def remove_edge!(u, v=nil)
          raise NotImplementedError, "Use ActiveRecord::Base methods on main object"        
        end

        # Returns an array of vertices that the graph has
        def vertices() ar_object.find(:all); end

        # Returns an array of edges, most likely of class Arc or Edge depending 
        # upon the type of graph
        def edges
          ar_edges_class.find(:all).map {|e| edge_class[e.send(@config[:in]), e.send(@config[:out])]}
        end

        def adjacent(x, options={})
          return graph_adjacent(x,options) if x.kind_of?(GRATR::Arc)
          options[:direction] ||= :out
          result = []
          if options[:type] == :edges
            if [:in,  :all].include?(options[:direction])
              es=x.send(@config[:in_edges])
              result += es.map {|e| GRATR::Arc[e.send(@config[:in]),e.send(@config[:out])]}
            end
            if [:out, :all].include?(options[:direction])
              es=x.send(@config[:out_edges])
              result += es.map {|e| GRATR::Arc[e.send(@config[:in]),e.send(@config[:out])]}
            end
          else
            result += x.send(@config[:parents])   if [:in,  :all].include?(options[:direction])
            result += x.send(@config[:children])  if [:out, :all].include?(options[:direction])
          end
          result
        end        
        
        def sources() not_in_edges(:out); end
        def sinks()   not_in_edges(:in);  end
       
       protected
       
        def ar_edges_class() eval(@config[:edges_class]); end
        def ar_object() @config[:ar_object]; end
        
        def not_in_edges(side)
          ar_object.find(:all, :conditions => "id not in (select distinct #{@config[side]}_id from #{ar_edges_class.table_name})")
        end
      end
    end
  end
end