class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    
    # TODO: how the fuck does OAuth work?
    # https://github.com/viatropos/authlogic-connect-example
    # https://github.com/viatropos/authlogic-connect
    
    respond_to do |format|
      if @user_session.save
        format.html { redirect_to(name_user_path(@user_session.username), :notice => 'Login Successful') }
        format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        puts "ERRORS: "+@user_session.errors.inspect
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    respond_to do |format|
      format.html { redirect_to(:root, :notice => 'Goodbye!') }
      format.xml  { head :ok }
    end
  end
end