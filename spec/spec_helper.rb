require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "rspec"
require "mongoid"
require "mongoid/compatibility"
require "mongoid_rating"
require "database_cleaner"
require "mongoid_rating"

MODELS = File.join(File.dirname(__FILE__), "models")
Dir["#{MODELS}/*.rb"].each { |f| require f }

if Mongoid::Rating::mongoid2?
  Mongoid.config.master = Mongo::Connection.new.db("mongoid_rating_test")
else
  Mongoid.configure do |config|
    name = "mongoid_rating_test"
    config.respond_to?(:connect_to) ? config.connect_to(name) : config.master = Mongo::Connection.new.db(name)
  end
end

Mongoid.logger = Logger.new($stdout)

DatabaseCleaner.orm = "mongoid"

RSpec.configure do |config|
  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
