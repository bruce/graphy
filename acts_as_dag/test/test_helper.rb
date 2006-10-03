$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require 'rubygems'
require 'active_support/breakpoint'
require 'active_record/fixtures'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite'])

load(File.dirname(__FILE__) + "/schema.rb")

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase #:nodoc:
  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end

  # Turn off transactional fixtures if you're working with MyISAM tables in MySQL
  self.use_transactional_fixtures = true
  
  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  def assert_edge(source_id, destination_id)
    ActiveRecord::Base.connection.select_all('select * from nodes_edges').each do |row|
      return assert(true) if row['source_id'].to_i == source_id.to_i and 
                             row['destination_id'].to_i == destination_id.to_i
    end
    assert false, "source_id[#{source_id}] & destination_id[#{destination_id}] not found"
  end
  
  def assert_not_edge(source_id, destination_id)
    ActiveRecord::Base.connection.select_all('select * from nodes_edges').each do |row|
      return assert(false, "source_id[#{source_id}] & destination_id[#{destination_id}] found in [#{row.inspect}]") if row['source_id'].to_i == source_id.to_i and row['destination_id'].to_i == destination_id.to_i
    end
    assert true
  end
  
  # http://project.ioni.st/post/217#post-217
  #
  #  def test_new_publication
  #    assert_difference(Publication, :count) do
  #      post :create, :publication => {...}
  #      # ...
  #    end
  #  end
  # 
  def assert_difference(object, method = nil, difference = 1)
    initial_value = object.send(method)
    yield
    assert_equal initial_value + difference, object.send(method), "#{object}##{method}"
  end

  def assert_no_difference(object, method, &block)
    assert_difference object, method, 0, &block
  end
  
  
end