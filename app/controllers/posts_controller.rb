class PostsController < ApplicationController

  before_filter :require_user, :only => [:new, :create, :update, :edit, :destroy]
  
  # GET /posts
  # GET /posts.json
  def index
    if params[:tag_name]
      # find posts by tag: /tags/tagname
      @posts = Tag.find_by_name(params[:tag_name]).posts.order("created_at DESC").page params[:page]
    else
      # find all posts
      @posts = Post.order("created_at DESC").page params[:page]
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end
  
  # /posts/new/1
  def new_child
    @post = Post.new
    @post.parent = Post.find(params[:id])
    # @post_parent = Post.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    # TODO: Isn't this creating the object twice? Thre's already Post.new in 'new' action
    @post = Post.new(params[:post])
    @post.parent = Post.find(params[:parent_id]) if params[:parent_id]
    respond_to do |format|
      if @post.save
        current_user.posts << @post
        format.html { redirect_to @post, :notice => 'Post was successfully created.' }
        format.json { render :json => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
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

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end
  
  def upvote
    puts "Upvote Called"
    @post = Post.find(params[:id])
    @post.upvote += 1
    
    respond_to do |format|
      if @post.save
        format.html { render :upvote, :notice => "Successful upvote" }
        format.json { head :ok }
      else
        format.html 
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
