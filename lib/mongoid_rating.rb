require "mongoid_rating/version"
require 'mongoid_rating/rate'
require 'mongoid_rating/model'

Mongoid::Document.send :include, Mongoid::Rating::Model

module Mongoid::Rating
  def self.mongoid3?
    !mongoid2? && (::Mongoid.const_defined? :Observer) # deprecated in Mongoid 4.x
  end

  def self.mongoid2?
    ::Mongoid.const_defined? :Contexts # deprecated in Mongoid 3.x
  end
end