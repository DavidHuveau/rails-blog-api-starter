class Api::V1::PostsController < ApplicationController
  include SmartRenderer

  before_action :set_post, only: %i[show]
  before_action :authenticate_with_token, only: %i[create update destroy]

  def index
    posts = params[:post_ids].present? ? Post.find(params[:post_ids]) : Post.all
    render json: posts
  end

  def show
    render json: @post
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
    render_or_error(post, :ok)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :detail, :published, :post_ids)
  end
end
