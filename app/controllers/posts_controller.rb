class PostsController < ApplicationController

  before_filter :require_user, :only => [:new, :create, :update, :edit, :destroy, :vote]
  respond_to :html, :json, :js

  # NOTE: This could be simplified with the following.
  # from http://railscasts.com/episodes/302-in-place-editing
  #
  # respond_to :html, :json
  # def update
  #   @user = User.find(params[:id])
  #   @user.update_attributes(params[:user])
  #   respond_with @user
  # end
  
  # GET /posts
  # GET /posts.json
  def index
    if params[:tag_name]
      # find posts by tag: /tags/tagname
      @posts = Tag.find_by_name(params[:tag_name]).posts.order("created_at DESC").page params[:page]
    else
      # find all posts
      @posts = Post.order("cached_hotness DESC").page params[:page]
    end

    respond_with(@posts)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build

    respond_with(@post)
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_with(@post)
  end
  
  def new_child
    @post = Post.new
    @post_parent = Post.find(params[:id])

    respond_with(@post)
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    relation_id = params[:post][:relation_id]
    params[:post].delete(:relation_id) if relation_id

    @post = Post.new(params[:post])
    # If it's new_child, build relationship to parent
    @post.relationships.build(:relation_id => relation_id) if relation_id
    
    if @post.save
      current_user.posts << @post
      current_user.vote!(@post)
       flash[:notice] = 'Post was successfully created.'
    end

    respond_with(@post, :layout => !request.xhr? )
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
 
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
        format.json { respond_with_bip(@post) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@post) }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_with(@post, :location => posts_url)
  end
  
  def vote
    @post = Post.find(params[:id])    
    logger.info "#{current_user.username } voting for #{@post.title}"
    vote = current_user.vote!(@post)
    if vote.valid?
      flash[:notice] = "You voted for #{@post.title}!\nOn behalf of #{@post.user.username}, thanks!"
    elsif vote.errors.messages.has_key?(:user_id)
      flash[:errors] = "You've already voted for #{@post.title}!"
    else
      flash[:errors] = "Could vote sorry!"
    end
    redirect_to request.referer
    #respond_to do |format|
    #  if current_user.vote!(@post).save
    #    format.html { render :upvote, :notice => "You voted for #{@post.title}!\nOn behalf of #{@post.user.username}, thanks!" }
    #    format.json { head :ok }
    #  else
    #    format.html { render :upvote, :errors => @post.errors }
    #    format.json { render :json => @post.errors, :status => :unprocessable_entity }
    #  end
    #end
  end
  
  def sweep_hotness_cache
    t = Time.now
    logger.info "Starting Cache Sweep..."
    Post.all.each do |p|
      p.cached_hotness = p.calculate_votes_hotness
      p.save! # where will errors get raised?
    end
    logger.info "Cache Swept (in #{((Time.now-t)/6).to_i/10.0} minutes)"
    flash[:notice] = "Cache Swept"
    redirect_to :action => :index
  end
  
end
