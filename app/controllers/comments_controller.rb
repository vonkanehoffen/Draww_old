class CommentsController < ApplicationController
  before_filter :require_user
  respond_to :html, :js
  def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(params[:comment])
      
      if @comment.save
        current_user.comments << @comment
        flash[:notice] = 'Comment Posted. Thanks!'
      else 
        flash[:error] = 'Sorry, the comment could not be saved.'
      end

      respond_with(@post)
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    
    if @comment.user == current_user
      @comment.destroy
      flash[:notice] = 'Your comment has been deleted.'
    else
      flash[:error] = "Oi! That's not your comment to delete!"
    end
    
    respond_with(@post)
  end
end
