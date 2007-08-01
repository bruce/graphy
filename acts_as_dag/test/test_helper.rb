$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__) + '/../../../..'

require 'rubygems'
require 'test/unit'

######################
# Firing up a test environment for ActiveRecord should not be this hard, but it is...
db_config = begin
  require "#{RAILS_ROOT}/vendor/rails/activerecord/lib/active_record" 
  require "#{RAILS_ROOT}/vendor/rails/activerecord/lib/active_record/fixtures" 
  require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
  "#{RAILS_ROOT}/config/database.yml"
rescue LoadError => e
  puts "Unable to find owning project environment, using local configuration"
  require 'active_record' 
  require 'active_record/fixtures'
  "test/database.yml"
end

require 'erb'
require "#{File.dirname(__FILE__)}/../init"

config = YAML::load(ERB.new(IO.read(db_config)).result)
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, [:nodes, :nodes_edges])
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

####################


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
end