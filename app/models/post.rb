class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :detail, type: String
  field :published, type: Boolean, default: false

  belongs_to :user

  validates_presence_of :title, :user_id
  after_save :send_confirmation_email

  index({ user_id: 1 }, background: true)

  def as_json(_options = {})
    {
      id: id,
      title: title,
      detail: detail,
      published: published,
      user: user
    }
  end

  default_scope -> { desc(:created_at) }
  scope :recent, -> { unscoped.desc(:updated_at) }
  # MongoID Like query => regex with i to make the query case insensitive
  scope :filter_by_title, ->(keyword) { where(title: /.*#{keyword}.*/i) }

  def self.search(params = {})
    # uses in function instead of find function to be compatible with the paginate method
    posts = params[:post_ids].present? ? Post.in(id: params[:post_ids]) : Post.all
    posts = posts.filter_by_title(params[:keyword]) if params[:keyword].present?
    posts = posts.recent if params[:recent].present?
    posts
  end

  private

  def send_confirmation_email
    return unless published_changed? && published

    PostMailer.send_confirmation(self).deliver
  end
end
