class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]
  before_action :authenticate_with_token, only: %i[create]

  def index
    render json: Post.all
  end

  def show
    render json: @post
  end

  def create
    debugger
    post = current_user.posts.create(post_params)
    render_or_error(post)
  end

  # def update
  #   if @post.update(post_params)
  #     render json: @post
  #   else
  #     render json: @post.errors, status: :unprocessable_entity
  #   end
  # end

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
