class CommentsController < ApplicationController
  before_filter :require_user
  def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(params[:comment])
      
      respond_to do |format|
        if @comment.save
          current_user.comments << @comment
          format.html { redirect_to post_path(@post), :notice => 'Comment Posted. Thanks!' }
          # format.json { render :json => @post, :status => :created, :location => @post }
        else
          format.html { render "posts/show", :error => "Couldn't save the comment!" }
          # format.json { render :json => @post.errors, :status => :unprocessable_entity }
        end
      end
            
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    respond_to do |format|
      if @comment.user == current_user
        @comment.destroy
        format.html { redirect_to post_path(@post), 
          :notice => 'Your comment has been deleted.' }
      else
        # TODO: This should be an error. Howd I do that?
        format.html { redirect_to post_path(@post), 
          :notice => "Oi! That's not your comment to delete!" }
      end     
    end
  end
end
