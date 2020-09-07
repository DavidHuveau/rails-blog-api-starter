class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :detail, type: String
  field :published, type: Boolean, default: false

  belongs_to :user

  validates_presence_of :title, :user_id

  index({ user_id: 1 }, background: true)

  def as_json(_options = {})
    {
      id: id,
      title: title,
      detail: detail,
      published: published,
      user: self.user
    }
  end

  default_scope -> { desc(:created_at) }
end
