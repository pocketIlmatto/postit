class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]

  def index
  	@posts = Post.all
  end

  def show
  	
  end

  def new

  end

  def create

  end

  def edit

  end

  def update
    if @post.update(post_params)
      redirect_to(@post)
    else
      render :edit
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
  	params.require(:post).permit(:url, :description, :user_id, :title)
  end
end
