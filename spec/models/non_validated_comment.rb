class NonValidatedComment
  include Mongoid::Document

  rateable :rate, float: false, validate: false

  embedded_in :post

  field :content
end
