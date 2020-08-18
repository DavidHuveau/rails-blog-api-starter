class Chicken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :detail, type: String

  default_scope -> { desc(:created_at) }
end
