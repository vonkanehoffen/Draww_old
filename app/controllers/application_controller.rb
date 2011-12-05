class ApplicationController < ActionController::Base
  protect_from_forgery
  # filter_parameter_logging :password, :password_confirmation 
  # that bit's deprecated in rails 3 so set stuff in config/application.rb
  helper_method :current_user_session, :current_user

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
    # TODO: WTF is going on here and does this help:
    # http://railspikes.com/2008/5/1/quick-tip-store_location-with-subdomains
    # need to redirect to original page on before_filter :require_user
    #session[:return_to] = request.request_uri
  end
end
