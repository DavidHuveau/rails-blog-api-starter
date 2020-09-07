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
  # MongoID Like query => regex with i to make the query case insensitive
  scope :filter_by_title, -> (keyword) { where(title: /.*#{keyword}.*/i) }
  scope :recent, -> { unscoped.desc(:updated_at) }


  # def self.search(params = {})
  #   products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all

  #   products = products.filter_by_title(params[:keyword]) if params[:keyword]
  #   products = products.above_or_equal_to_price(params[:min_price].to_f) if params[:min_price]
  #   products = products.below_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
  #   products = products.recent(params[:recent]) if params[:recent].present?

  #   products
  # end
end
