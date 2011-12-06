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
          # TODO: Trouble with this is we get duplicated content "/posts/xx/comments"
          # and the index action gets callewd for it in some cases, which doesn't exist
          format.html { render "posts/show", :error => "Couldn't save the comment!" }
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
