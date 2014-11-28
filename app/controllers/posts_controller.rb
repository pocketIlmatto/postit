class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]
  before_action :require_user, only: [:new, :create]
  before_action only: [:edit, :update, :destroy] do
    require_logged_in_object_owner(@post.user_id)
  end

  def index
  	@posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    if @post.save
      flash[:notice] = "Your post was created"
      redirect_to(@post)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Your post was updated"
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
  	params.require(:post).permit(:url, :description, :user_id, :title, :category_ids => [])
  end
end
