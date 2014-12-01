class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id]);
    @comment = @post.comments.build(comment_params)
    @comment.creator = current_user
    
    if @comment.save
      flash[:notice] = "Your comment was created."
      redirect_to post_path(@post)
    else
      flash[:error] = "Comment must not be empty."
      @post.reload.comments
      redirect_to post_path(@post)
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Vote counted!"
        else
          flash[:error] = "You can only vote for that comment once!"
        end
        redirect_to :back 
      end
      format.js
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
  
end