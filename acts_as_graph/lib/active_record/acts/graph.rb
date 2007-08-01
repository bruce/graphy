require 'gratr'

module ActiveRecord
  module Acts #:nodoc:
    module Graph #:nodoc:
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      #   # return a list of all descendants of this graph node
      #    def descendants                
      #      stack = [ self.send(acts_as_dag_configuration[:in]) ].flatten
      #      nodes = {}
      #      while stack.length > 0
      #        n = stack.pop
      #        if n and ! nodes[n.id]                   
      #          nodes[n.id] = n
      #            (stack << [n.send(acts_as_dag_configuration[:in])]).flatten!
      #        end
      #      end
      #      nodes.values
      #    end
      #   
      #    # return a list of all ancestors of this graph node
      #    def ancestors    
      #      stack = [ self.send(acts_as_dag_configuration[:out]) ].flatten
      #      nodes = {}
      #      while stack.length > 0
      #        n = stack.pop
      #        if n and ! nodes[n.id]                   
      #          nodes[n.id] = n
      #          (stack << [n.send(acts_as_dag_configuration[:out])]).flatten!
      #        end
      #      end
      #      nodes.values
      #    end     
      #  
      #   # This act provides the capabilities for a class to behave as a directed acyclic graph.
      #   # The class that has this specified needs to have a <model>_edges tables defined.
      #   module ClassMethods
      #     
      #   
      #     # which nodes in the DAG have no in edges?
      #     def sources
      #       find :all, :conditions => "id not in (select distinct #{acts_as_dag_configuration[:destination_key]} from #{acts_as_dag_configuration[:edges_class].table_name})"
      #     end
      #   
      #     # which nodes in the DAG have no out edges?
      #     def sinks
      #       find :all, :conditions => "id not in (select distinct #{acts_as_dag_configuration[:source_key]} from #{acts_as_dag_configuration[:edges_class].table_name})"
      #     end         
      #                              
      #   end            
      # end
        
      module ClassMethods
        
        def acts_as_graph_directed_associations(options)
          has_many options[:in_edges],  :class_name => options[:edges_class], :foreign_key => "#{options[:out]}_id"
          has_many options[:out_edges], :class_name => options[:edges_class], :foreign_key => "#{options[:in]}_id"
          has_many options[:parents],   :through => options[:in_edges]
          has_many options[:children],  :through => options[:out_edges]
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
            :edges_class     => "#{self}Edges",
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

