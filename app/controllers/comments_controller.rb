class CommentsController < ApplicationController
  def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.new(params[:comment])
      
      respond_to do |format|
        if @comment.save
          current_user.comments << @comment
          format.html { redirect_to post_path(@post), :notice => 'Comment was successfully created.' }
          # format.json { render :json => @post, :status => :created, :location => @post }
        else
          format.html { redirect_to post_path(@post), :notice => 'You need to write something!' }
          # format.json { render :json => @post.errors, :status => :unprocessable_entity }
        end
      end
            
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end
end
