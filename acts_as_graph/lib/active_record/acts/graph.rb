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
require 'gratr'

module ActiveRecord
  module Acts #:nodoc:
    module Graph #:nodoc:
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end
        
      module ClassMethods
        
        def acts_as_graph_directed_associations(options)
          has_many options[:in_edges],  :class_name => options[:edges_class], :foreign_key => "#{options[:out]}_id"
          has_many options[:out_edges], :class_name => options[:edges_class], :foreign_key => "#{options[:in]}_id"
          has_many options[:parents],   :through => options[:in_edges],       :source      => options[:in]
          has_many options[:children],  :through => options[:out_edges],      :source      => options[:out]
        end

        def acts_as_graph_undirected_associations(options)
#          raise NotImplementedError  
        end
        
        def acts_as_graph(name, options = {})          
          raise ArgumentError, "options must be a Hash" unless options.is_a?(Hash)
          options.assert_valid_keys(:directed, :in, :out, :edges_class, :in_edges, :out_edges, :parents, :children)
  
          # Create defaults                                         
          configuration_pass_one = {
            :method_name     => name,
            :ar_object       => self,
            :edges_class     => "#{self}Edge",
            :directed        => true,
            :in              => :source,
            :out             => :destination,
            :in_edges        => "#{name}_in_edges".to_sym,
            :out_edges       => "#{name}_out_edges".to_sym
          }.update(options)            
          configuration = {
            :children        => options[:out].to_s.pluralize.to_sym,
            :parents         => options[:in].to_s.pluralize.to_sym
          }.update(configuration_pass_one)
                    
          graph = configuration[:directed] ? GRATR::Digraph.new(        :implementation => Implementation) : 
                                             GRATR::UndirectedGraph.new(:implementation => Implementation)

          graph.instance_variable_set(:@config,configuration)
          
          configuration[:directed] ? acts_as_graph_directed_associations(configuration) : acts_as_graph_undirected_associations(configuration)
                                    
          # Create graph accessor method          
          write_inheritable_attribute name, graph
          class_inheritable_reader    name
          
          # Store options
          options_hash = read_inheritable_attribute(:acts_as_graph_options) || write_inheritable_attribute(:acts_as_graph_options, {})
          options_hash[name] = options
          write_inheritable_attribute(:acts_as_graph_options, options_hash)              
        end     
      end
      
      
    end
  end
end                        

