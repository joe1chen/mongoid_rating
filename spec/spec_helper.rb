$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rubygems"
require "rspec"
require "mongoid"
require 'mongoid/compatibility'
require "mongoid_rating"
require "database_cleaner/mongoid"

MODELS = File.join(File.dirname(__FILE__), "models")
Dir["#{MODELS}/*.rb"].each { |f| require f }

if Mongoid::Compatibility::Version.mongoid2?
  Mongoid.config.master = Mongo::Connection.new.db("mongoid_rating_test")
else
  Mongoid.configure do |config|
    name = "mongoid_rating_test"
    config.respond_to?(:connect_to) ? config.connect_to(name) : config.master = Mongo::Connection.new.db(name)
  end
end

Mongoid.logger = Logger.new($stdout)

DatabaseCleaner[:mongoid].strategy = [:deletion]

RSpec.configure do |c|
  c.before(:each) { DatabaseCleaner.clean }
end

# RSpec 3 with the RSpec 2-era `should` syntax still enabled, so the existing specs run unchanged.
RSpec.configure do |c|
  c.expect_with(:rspec) { |e| e.syntax = [:should, :expect] }
  c.mock_with(:rspec) { |m| m.syntax = [:should, :expect] }
end
