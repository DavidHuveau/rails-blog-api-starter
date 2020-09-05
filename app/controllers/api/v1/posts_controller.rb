class Api::V1::PostsController < ApplicationController
  include SmartRenderer

  before_action :set_post, only: %i[show destroy]
  before_action :authenticate_with_token, only: %i[create update]

  def index
    render json: Post.all
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

  # def destroy
  #   @post.destroy
  # end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :detail, :published)
  end
end
