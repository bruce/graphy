require 'active_record/acts/implementation'
require 'active_record/acts/graph'

ActiveRecord::Base.class_eval { include ActiveRecord::Acts::Graph }