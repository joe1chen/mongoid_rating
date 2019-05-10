class Post
  include Mongoid::Document

  field :name, type: String
  
  embeds_many :comments
  embeds_many :non_validated_comments

  rateable :rate
end
