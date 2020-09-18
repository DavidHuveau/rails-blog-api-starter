class Api::V1::PostsController < ApplicationController
  include SmartRenderer
  include Paginable

  before_action :set_post, only: %i[show]
  before_action :authenticate_with_token, only: %i[create update destroy]

  def index
    # posts = Post.search(params)
    # posts = Post.search(params).paginate(page: params[:page], per_page: params[:per_page])
    posts = Post.search(params).paginate(page: current_page, per_page: per_page)
    render json: { data: posts }.merge(pagination_data('api_v1_posts_path', posts))
  end

  def show
    render json: { data: @post }
  end

  def create
    post = current_user.posts.create(post_params)
    render_or_error(post)
  end

  def update
    post = current_user.posts.find(params[:id])
    post.update(post_params)
    render_or_error(post, :ok)
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    render json: { data: post }
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :detail, :published, post_ids: [])
  end
end
