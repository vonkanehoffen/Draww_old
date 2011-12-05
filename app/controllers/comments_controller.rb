class CommentsController < ApplicationController
  def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(params[:comment])
      if @comment.save
        redirect_to post_path(@post), :notice => "Comment Posted, Thanks!"
      else
        render "posts/show", :error => "Couldn't save comment!"
      end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end
end
