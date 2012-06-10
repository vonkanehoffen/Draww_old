class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user
  
  before_filter :instantiate_controller_and_action_names
  caches_action :instantiate_controller_and_action_names

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end

  private
  
  def current_user_session
   return @current_user_session if defined?(@current_user_session)
   @current_user_session = UserSession.find
  end

  def current_user
   return @current_user if defined?(@current_user)
   @current_user = current_user_session && current_user_session.user
  end

  def require_user 
    # TODO_HELP: Needs to redirect back to the same page after login and highlight the login box. 
    # Currently :store_location fucks up and gets .../comments for the current 
    # URL on some pages, cos the comments model is called as part of the 
    # posts/show view etc.
    
   unless current_user 
     store_location 
     flash[:notice] = "You must be logged in to do this." 
     redirect_to login_path 
     return false 
   end 
  end

  def require_no_user 
    if current_user 
      store_location 
      flash[:notice] = "You must be logged out to access this page" 
      redirect_to root_url 
      return false 
    end 
  end
  
  def store_location
    # TODO_HELP: The location stored doesn't help redirect after login. 
    # This points to stuff like /posts/94/comments which is no good as comments never viewed directly.

    session[:return_to] = request.fullpath
  end
  
  def prepare_new_session
    @user_session = UserSession.new if current_user.blank?
  end
end
