ActiveRecord::Schema.define(:version => 1) do
  create_table :nodes, :force => true do |t|
    t.column "name", :string
  end             
  
  create_table :nodes_edges, :force => true do |t|
      t.column :source_id, :integer
      t.column :destination_id, :integer
  end
end