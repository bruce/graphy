module ActiveRecord
  module Acts #:nodoc:
    module DAG #:nodoc:
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module InstanceMethods
        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end
           
        # return a list of all descendants of this graph node
        def descendants                
          stack = [ self.send(acts_as_dag_configuration[:in]) ].flatten
          nodes = {}
          while stack.length > 0
            n = stack.pop
            if n and ! nodes[n.id]                   
              nodes[n.id] = n
                (stack << [n.send(acts_as_dag_configuration[:in])]).flatten!
            end
          end
          nodes.values
        end

        # return a list of all ancestors of this graph node
        def ancestors    
          stack = [ self.send(acts_as_dag_configuration[:out]) ].flatten
          nodes = {}
          while stack.length > 0
            n = stack.pop
            if n and ! nodes[n.id]                   
              nodes[n.id] = n
              (stack << [n.send(acts_as_dag_configuration[:out])]).flatten!
            end
          end
          nodes.values
        end     

        # This act provides the capabilities for a class to behave as a directed acyclic graph.
        # The class that has this specified needs to have a <model>_edges tables defined.
        module ClassMethods
          def edges_table
            acts_as_dag_configuration[:edges_table]
          end

          # which nodes in the DAG have no in edges?
          def sources
            self.find_by_sql("select #{self.table_name}.* from #{self.table_name} where id not in " +
              "(select distinct destination_id from #{acts_as_dag_configuration[:edges_table]})")
          end

          # which nodes in the DAG have no out edges?
          def sinks
            self.find_by_sql("select #{self.table_name}.* from #{self.table_name} where id not in " +
              "(select distinct source_id from #{acts_as_dag_configuration[:edges_table]})")
          end         

          # RGL2 support methods
          def vertex?(v)
            v.kind_of?(self) and self.find(v.id)
          rescue
            false
          end

          def edge?(u, v = nil)
            vertex?(u) and vertex?(v) and u.out_nodes.include?(v)
          end
                                   
          # NOTE: RGL2 provides for labelling of nodes and edges.  We do not yet.
          def add_vertex!(v)
            vertex?(v) ? true : v.save
          end

          # NOTE: RGL2 provides for labelling of nodes and edges.  We do not yet.
          def add_edge!(u, v)
            u.out_nodes(true) << v
          end

          def remove_vertex!(v)
            self.destroy(v.id)
          end

          def remove_edge!(u, v=nil)
            u.out_nodes.each {|e| u.out_nodes.delete(e) if v.nil? or e.id == v.id }
            u.in_nodes.each {|e| u.in_nodes.delete(e) } unless v
          end

          def vertices
            self.find(:all)
          end

          def edges
            self.find(:all, :include => [ acts_as_dag_configuration[:in], acts_as_dag_configuration[:out]]).inject(Set.new) do |a, v|
              v.send(acts_as_dag_configuration[:in]).each  {|i| a << [i, v] }
              v.send(acts_as_dag_configuration[:out]).each {|o| a << [v, o] }
              a
            end.to_a
          end
        end                  
      end
        
      module ClassMethods
        def acts_as_dag(options = {})
          class_inheritable_reader :acts_as_dag_configuration
          raise "options must be a Hash" unless options.is_a?(Hash)
                                         
          configuration = { 
            :edges_table => "#{self.table_name}_edges", 
            :in => :in_nodes,
            :out => :out_nodes,
          }.update(options)            

          write_inheritable_attribute(:acts_as_dag_configuration, configuration)
         
          has_and_belongs_to_many acts_as_dag_configuration[:in].to_sym,
            :join_table => acts_as_dag_configuration[:edges_table],
            :foreign_key => 'destination_id',
            :association_foreign_key => 'source_id',
            :class_name => "#{self.name}"

          has_and_belongs_to_many acts_as_dag_configuration[:out].to_sym,
            :join_table => acts_as_dag_configuration[:edges_table],
            :foreign_key => 'source_id',
            :association_foreign_key => 'destination_id',
            :class_name => "#{self.name}"
          
          include ActiveRecord::Acts::DAG::InstanceMethods
        end     
      end
    end
  end
end                        

