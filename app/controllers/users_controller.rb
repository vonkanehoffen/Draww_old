class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if(params[:username])
      @user = User.where(:username => params[:username]).first
    else
      @user = User.find(params[:id])
    end
    
    respond_to do |format|
      if @user    
        @posts = @user.posts.order("created_at DESC").page params[:page]
        format.html # show.html.erb
        format.json { render :json => @user }
      else
        format.html { render :action=> 'not_found' }
        # redirect_to :action => 'not_found'  # TODO: can this be an action so we don't end up with duplicate content
      end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @authentications = @user.authentications if current_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'Registration successfull.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" } # TODO_HELP: How do I redirect this to 'user_sessions/new' without losing validation errors? user_session/new and user/new now occupy the same view (combined login and signup). Am I even doing that the right way?
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
